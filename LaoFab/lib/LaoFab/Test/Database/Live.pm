package LaoFab::Test::Database::Live;
use strict;
use warnings;

use LaoFab::Schema;
use Directory::Scratch;
use YAML qw(DumpFile);
use FindBin qw($Bin);

use base 'Exporter';
our @EXPORT = qw/log_in schema/;

my $schema;
my $config;

BEGIN {
	my $tmp = Directory::Scratch->new;
	my $db = $tmp->touch('db');
	
	my $dsn = 'DBI:SQLite:$db';
	$schema = LaoFab::Schema->connect($dsn);
	$schema->deploy;
	
	$config = "$Bin/../laofab_local.yml";
	DumpFile($config, {'Model::DB' => {connect_info => [$dsn]}});
}

sub schema { $schema };

sub log_in { #counts as 4 tests
	my $mech = shift;
	
	my $user = schema()->resultset('Users')->create({
		username => 'test@test.com',
		password => 'qwerty',
		name 	 => 'Mr. Test',
	});
	
	$mech->get_ok('http://localhost:3000/');
	$mech->form_name('login_form');
	$mech->field('__username' => 'test@test.com');
	$mech->field('__password' => 'qwerty');
	$mech->click('Login');
	$mech->content_like(qr/Welcome/);
	
	return $user;
}

END { unlink $config };

1;