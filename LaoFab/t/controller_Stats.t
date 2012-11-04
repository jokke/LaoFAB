use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'LaoFab' }
BEGIN { use_ok 'LaoFab::Controller::Stats' }

ok( request('/stats')->is_success, 'Request should succeed' );


