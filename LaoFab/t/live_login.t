use strict;
use warnings;
use Test::More tests => 4;
use LaoFab::Test::Database::Live;
use Test::WWW::Mechanize::Catalyst 'LaoFab';

my $schema = schema();
my $mech Test::WWW::Mechanize::Catalyst->new;
log_in($mech);
