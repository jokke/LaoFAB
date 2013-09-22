package LaoFab;

use strict;
use warnings;

use Catalyst::Runtime '5.70';

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use parent qw/Catalyst/;
use Catalyst qw/ConfigLoader
                Static::Simple
                Authentication
                StackTrace
                Authorization::Roles
                Authorization::ACL
                Session
                Session::State::Cookie
                Session::Store::DBIC
                /;
our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in laofab.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config( #name => 'LaoFab',
					#'Controller::REST' => 
					#{
					#	stash_key => 'rest',
       				#	default => 'application/json',
					#},
                     'View::JSON' =>
                     {
                         expose_stash => 'json',
                         json_driver => 'JSON::XS'
                     },
                     'View::Excel::Template::Plus' => {
                         etp_config => {
                             INCLUDE_PATH => [
                                 LaoFab->path_to( 'root', 'src', 'excel_templates' ),
                             ]
                         }
                     },
		             'View::Email' => {
                         stash_key => 'email',
                         default => {
                             content_type => 'text/plain',
                             charset => 'utf-8',
                         },
                         sender => {
                             mailer => 'SMTP',
                             mailer_args => {
                                 Host     => 'localhost',
                            },
                         }
                     },
                     'View::Email::Template' => {
                         stash_key       => 'email',
                         template_prefix => 'email_templates',
                         default         => {
                             content_type => 'text/plain',
                             charset => 'utf-8',
                             view => 'TT::NoWrap'
                         },
                         sender => {
                             mailer => 'SMTP',
                             mailer_args => {
                                 Host     => 'localhost',
                             },
                         },
                     }
                    );

# Start the application
__PACKAGE__->setup();

#__PACKAGE__->deny_access_unless('/document', [qw/viewer/]);
__PACKAGE__->deny_access_unless('/document/edit', [qw/admin/]);
__PACKAGE__->deny_access_unless('/document/recent', [qw/admin/]);
__PACKAGE__->deny_access_unless('/export', [qw/viewer/]);
__PACKAGE__->deny_access_unless('/folder', [qw/viewer/]);
__PACKAGE__->deny_access_unless('/folder/edit', [qw/admin/]);
__PACKAGE__->deny_access_unless('/folder/add', [qw/admin/]);
__PACKAGE__->deny_access_unless('/folder/delete', [qw/admin/]);
#__PACKAGE__->deny_access_unless('/rest/rating', [qw/viewer/]);
__PACKAGE__->deny_access_unless('/manage', [qw/admin/]);
__PACKAGE__->deny_access_unless('/stats', [qw/admin/]);
__PACKAGE__->deny_access_unless('/search', [qw/viewer/]);
#__PACKAGE__->deny_access_unless('/user', [qw/viewer/]);
__PACKAGE__->deny_access_unless('/user/add', [qw/admin/]);
__PACKAGE__->deny_access_unless('/user/add_multi', [qw/admin/]);
__PACKAGE__->deny_access_unless('/user/search', [qw/admin/]);
__PACKAGE__->deny_access_unless('/user/list', [qw/admin/]);
__PACKAGE__->deny_access_unless('/user/delete', [qw/admin/]);
__PACKAGE__->deny_access_unless('/user/edit', [qw/admin/]);
__PACKAGE__->deny_access_unless('/user/edit_info', [qw/viewer/]);
__PACKAGE__->deny_access_unless('/user/edit_password', [qw/viewer/]);
__PACKAGE__->deny_access_unless('/user/view', [qw/viewer/]);

#__PACKAGE__->deny_access_unless('/', [qw/viewer/]);

#__PACKAGE__->allow_access('/index');
__PACKAGE__->allow_access('/user/reset');
__PACKAGE__->allow_access('/user/password_recovery');
__PACKAGE__->allow_access('/logout');
__PACKAGE__->allow_access('/document/view');
#__PACKAGE__->allow_access('/login');
=head1 NAME

LaoFab - Catalyst based application

=head1 SYNOPSIS

    script/laofab_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<LaoFab::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Joakim Lagerqvist

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
