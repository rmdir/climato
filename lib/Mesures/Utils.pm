package Mesures::Utils;
use strict;

use YAML qw/LoadFile/;
use DBI;
use DateTime;


sub get_yesterday() {
  my $yesterday = DateTime->today(time_zone => 'Europe/Paris')->add(days => -1);
	return $yesterday->ymd;
	
}

sub parse_conf() {
	my $path = '/usr/local/etc/mesures.yaml';
	if ( -f  $path ) {
		my $config = LoadFile($path) or die "No usable configfile : $!";
		return $config;
	}
	else {
		die "$path does not exist";
	}
}

sub get_infoclimat_token() {
	my $config = parse_conf();
	return $config->{infoclimat};
}
	
sub get_infoclimat_stations() {
	my $config = parse_conf();
	return $config->{stations};
}

sub connect_db() {
	my $config = parse_conf();
	my $dbname = $config->{db}->{name};
	my $host = $config->{db}->{host};
	my $port = $config->{db}->{port};
	my $user = $config->{db}->{user};
	my $pass = $config->{db}->{pass};
	my $dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=$host;port=$port",
		$user, $pass, {AutoCommit => 1, RaiseError => 1, PrintError => 0}) or die DBI->stderr;
	return $dbh;
}

1;
# vim: ai ts=2 sw=2 expandtab paste mouse=
