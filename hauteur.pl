#!/usr/bin/perl -w
use strict;

use LWP::UserAgent;
use JSON;
use DBI;
use lib './lib';
use Mesures::Utils;
use Data::Dumper;
use feature qw/say/;

# On récupère la hauteur des fleuves sur hubeau
# On garde seulement une mesure par heures qu'on insère dans la table mesures

my $date=Mesures::Utils::get_yesterday();
my $hauteur="https://hubeau.eaufrance.fr/api/v1/hydrometrie/observations_tr?code_entite=%s&size=1000&grandeur_hydro=H&date_debut_obs=$date&date_fin_obs=${date}T23:59:59";
my $debit="https://hubeau.eaufrance.fr/api/v1/hydrometrie/obs_elab?code_entite=%s&size=1000&grandeur_hydro=QmJ&date_debut_obs_elab=$date&date_fin_obs_elab=${date}T23:59:59";
my $dbh = Mesures::Utils::connect_db();
my $ua = LWP::UserAgent->new();

my $sth = $dbh->prepare("SELECT id from stations where debit = false");
$sth->execute;
my $stations = $sth->fetchall_arrayref;

# Pour chaque station trouvée dans la table stations on récupère les mesures
foreach my $station (@{$stations}) {
	my $s = $station->[0];
	my $req = sprintf($hauteur, $s);
	say "Requesting : $req";
  my $res = $ua->get("$req");
	if ($res->is_success) {
    foreach my $mesure (@{from_json($res->decoded_content)->{data}}) {
			say "insering $s";
			$dbh->do(sprintf("INSERT into mesures (date, station, hauteur) values ('%s', '%s', '%d') ON CONFLICT DO NOTHING\n", $mesure->{date_obs}, $s, $mesure->{resultat_obs}));
		}
	}
	else {
    say "Mesurment station $station failed : ", $res->status_line;
	}
}

$sth = $dbh->prepare("SELECT id from stations where debit = true");
$sth->execute;
$stations = $sth->fetchall_arrayref;

# Pour chaque station trouvée dans la table stations on récupère les mesures
foreach my $station (@{$stations}) {
	my $s = $station->[0];
	my $req = sprintf($debit,$s);
	say "Requesting : $req";
	my $res = $ua->get("$req");
	if ($res->is_success) {
		foreach my $mesure (@{from_json($res->decoded_content)->{data}}) {
			say "insering $s";
			$dbh->do(sprintf("INSERT into debits (date, station, debit) values ('%s', '%s', '%d') ON CONFLICT DO NOTHING\n", $mesure->{date_obs_elab}, $s, $mesure->{resultat_obs_elab}));
		}
	}
	else {
		say "Mesurment station $station failed : ", $res->status_line;
	}
	
}

	# vim: ai ts=2 sw=2 expandtab paste mouse=
