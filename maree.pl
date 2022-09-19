#!/usr/bin/perl -w
use strict;

use LWP::UserAgent;
use JSON;
use DBI;
use lib './lib';
use Mesures::Utils;
use Data::Dumper;
use feature qw/say/;

# On récupère les marées sur meteoconsult
# L'API du service public est payante

my $url="http://webservices.meteoconsult.fr/meteoconsultmarine/androidtab/115/fr/v20/previsionsSpot.php?lat=%s&lon=%s";
my $dbh = Mesures::Utils::connect_db();
my $ua = LWP::UserAgent->new();

# Sur meteoconsult les ports sont réferencés d'après leurs coordonnées
my $sth = $dbh->prepare("SELECT id, lat, lon from ports");
$sth->execute;
my $ports = $sth->fetchall_hashref('id');
print Dumper $ports;

# Pour chaque port on récupère les marées pour les 7 prochains jours
foreach my $p (keys %{$ports}) {
	my $req = sprintf($url, $ports->{$p}->{lat}, $ports->{$p}->{lon});
  my $res = $ua->get("$req");
	if ($res->is_success) {
    my $mesures = from_json($res->decoded_content)->{contenu}->{marees};
		foreach my $m (@{$mesures}) {
			foreach my $e (@{$m->{etales}}) {
				printf "Marée : %s, %s, %s\n", $p, $e->{datetime}, $e->{hauteur};
				$dbh->do(sprintf "INSERT INTO marees VALUES (%d, '%s', '%s') ON CONFLICT DO NOTHING;", $p, $e->{datetime}, $e->{hauteur});;
			}
		}
	}
	else {
    say "Mesurment station $ports failed : ", $res->status_line;
	}
	
}

# vim: ai ts=2 sw=2 expandtab paste mouse=
