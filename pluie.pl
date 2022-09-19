#!/usr/bin/perl -w
use strict;

use LWP::UserAgent;
use JSON;
use DBI;
use lib './lib';
use Mesures::Utils;
use Data::Dumper;
use feature qw/say/;


my $date=Mesures::Utils::get_yesterday();
my $stations = "";
foreach my $s (@{Mesures::Utils::get_infoclimat_stations()}) {
	$stations = $stations."stations[]=$s&";
}
my $url = sprintf("https://www.infoclimat.fr/opendata/?method=get&format=csv&%sstart=%s&end=%s&token=%s", $stations, $date, $date, Mesures::Utils::get_infoclimat_token());

#my $dbh = Mesures::Utils::connect_db();
my $ua = LWP::UserAgent->new();

my $res = $ua->get("$url");
my $csv = $res->decoded_content;
my $p = {};
# On lit le csv et on garde une valeur par jour et par heure pour chaque station
foreach my $line (split '\n', $csv) {
	chomp $line;
	next if $line =~ /^station_id/;
	next if $line =~ /^#/;
	my @datas = split ';', $line;
	my $station = $datas[0];
	my $indice = 9;
	if ( @datas > 11) {
		$indice = 11;
	}
	my ($date, $heure) = split '\s', $datas[1];
	$heure =~ s/:.*//;
	# On initialise la valeur à 0 pour éviter d'avoir à tester sans arret si elle existe.
	$p->{$station}->{$date}->{$heure} = 0 unless $p->{$station}->{$date}->{$heure};
	my $pluie = $datas[$indice];
	if ($pluie) {
		if ($pluie > $p->{$station}->{$date}->{$heure}) {
			$p->{$station}->{$date}->{$heure} = $pluie;
		}
	}
}
# On fait le cumul par stations
my $nstations = 0;
my $cumul;
foreach my $s (keys %{$p}) {
	$nstations++;
	# pour chaque date 
	my $cs = 0;
	foreach my $d (keys %{$p->{$s}}) {
		# pour chaque heure
		foreach my $h (keys %{$p->{$s}->{$d}}) {
			$cs +=  $p->{$s}->{$d}->{$h}; 
		}
	}
	print "Station $s : $cs mm\n";
	$cumul += $cs;
}

my $dbh = Mesures::Utils::connect_db();
$dbh->do(sprintf("INSERT into pluviometrie (date, moyenne) values ('%s', '%.2f') ON CONFLICT DO NOTHING\n", $date, $cumul / $nstations));
print "$cumul / $nstations = ", $cumul / $nstations ;


# vim: ai ts=2 sw=2 expandtab paste mouse=
