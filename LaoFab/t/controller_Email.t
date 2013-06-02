use strict;
use warnings;
use Test::More;


use Catalyst::Test 'LaoFab';
use LaoFab::Controller::Email;

ok( request('/email')->is_success, 'Request should succeed' );
done_testing();
