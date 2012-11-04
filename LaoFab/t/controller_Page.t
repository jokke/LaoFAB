use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'LaoFab' }
BEGIN { use_ok 'LaoFab::Controller::Page' }

ok( request('/page')->is_success, 'Request should succeed' );


