use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'LaoFab' }
BEGIN { use_ok 'LaoFab::Controller::Search' }

ok( request('/search')->is_success, 'Request should succeed' );


