package LaoFab::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use DateTime::Format::MySQL;
use DateTime;
use Data::Dumper;

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

LaoFab::Controller::Root - Root Controller for LaoFab

=head1 DESCRIPTION

This controller handles the start page, index, login, logout, authorization as well as manage and stats pages

=head1 METHODS

auto
index
default
access_denied
logout
check_login
manage - should be moved to its own controller
stats - should be moved to its own controller
end

=cut

=head2 auto

Runs before anything and checkes if the path needs a login or not, if login is needed it will forward to check_login

=cut

sub auto : Private {
    my ( $self, $c ) = @_;
	$c->log->debug('path is '.$c->req->path);
    return 1 if ($c->req->path =~ /^feed/ or $c->req->path =~ /^user\/password_recovery/ or $c->req->path =~ /^rest\/laofind/ or $c->req->path =~ /^user\/reset/);
    $c->forward( '/check_login' ) || return 0;
    return 1;
}

sub test : Local {
    my ( $self, $c ) = @_;
    $c->forward('index');
    $c->stash->{template} = 'index.tt2';
}

=head2 index

The first page. Fills up the stash with some statistics and stuff for view on the first page.

=cut
sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

	# set the header
	$c->stash->{page_header} = 'Welcome';

    my $last_month = DateTime->now;
    $last_month->subtract( months => 1);
    my $search_dt = DateTime::Format::MySQL->format_datetime($last_month);
    my $top_downloads = $c->model('LaoFabDB::Downloads')->search({
        download_dt => { '>=', $search_dt },
        document    => { '>', 0 }, #fix for documents
    },{
        select => [ 'document', { count => 'distinct user' }],
#        as => [qw/ document id /],
#        prefetch => 'document',
        group_by => [qw/ document /],
        order_by => [' count(distinct user) desc '],
    })->slice(0,9);

    $c->stash->{top_downloads} = $top_downloads;

    my $latest_uploads = $c->model('LaoFabDB::Documents')->search({},
    {
        order_by => ['create_dt desc'],
    })->viewable->slice(0,9);

    $c->stash->{latest_uploads} = $latest_uploads;

    my $page = $c->model('LaoFabDB::Content')->find({ page => 'start' });
    unless ($page) {
        $c->stash->{error} = "Couldn't get the content from the database.";
        $c->detach;
    }
    $c->stash->{content} = $page;

    my $doc_obj = $c->model('LaoFabDB::Documents')->search({},{
        select => [ { count => '*' } ],
        as => [qw/ id /],
    })->slice(0,0);
    if (my $doc = $doc_obj->next) {
        $c->stash->{no_docs} = $doc->id;
    }
    $doc_obj = $c->model('LaoFabDB::Documents')->search({},{
        select => [ { sum => 'filesize' } ],
        as => [qw/ filesize /],
    })->slice(0,0);
    if (my $doc = $doc_obj->next) {
        $c->stash->{size} = $doc->friendly_size;
    }
    my $folder_obj = $c->model('LaoFabDB::Folders')->search({},{
        select => [ { count => '*' } ],
        as => [qw/ id /],
    })->slice(0,0);
    if (my $folder = $folder_obj->next) {
        $c->stash->{no_folders} = $folder->id;
    }
    
    my $photo_obj = $c->model('LaoFabDB::Photos')->search({},{
        select => [ { count => '*' } ],
        as => [qw/ id /],
    })->slice(0,0);
    if (my $photo = $photo_obj->next) {
        $c->stash->{no_photos} = $photo->id;
    }
    $photo_obj = $c->model('LaoFabDB::Photos')->search({},{
        select => [ { sum => 'filesize' } ],
        as => [qw/ filesize /],
    })->slice(0,0);
    if (my $photo = $photo_obj->next) {
        $c->stash->{photo_size} = $photo->friendly_size;
    }
    my $album_obj = $c->model('LaoFabDB::Albums')->search({},{
        select => [ { count => '*' } ],
        as => [qw/ id /],
    })->slice(0,0);
    if (my $album = $album_obj->next) {
        $c->stash->{no_albums} = $album->id;
    }
    
    my $user_obj = $c->model('LaoFabDB::User')->search({},{
        select => [ { count => '*' } ],
        as => [qw/ id /],
    })->slice(0,0);
    if (my $user = $user_obj->next) {
        $c->stash->{no_users} = $user->id;
    }
    my $last_week = DateTime->now;
    $last_week->subtract( weeks => 1);
    my $new_search_dt = DateTime::Format::MySQL->format_datetime($last_week);
    my $top_search = $c->model('LaoFabDB::Phrases')->search({
        search_dt => { '>=', $new_search_dt },
    },{
        select => [ 'word', { count => '*' }],
        as => [qw/ word id /],
        group_by => [qw/ word /],
        order_by => [' count(*) desc '],
    })->slice(0,0);
    if (my $search = $top_search->next) {
        $c->stash->{week_word} = $search->word;
    }
    
    my $latest_photos = $c->model('LaoFabDB::Photos')->search({},{
        order_by => ['create_dt desc'],
    })->slice(0,2);
    
    $c->stash->{latest_photos} = $latest_photos;
}


=head2 default

If nothing is found this takes over and generates a 404 and corresponding template.

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->status(404);
    $c->stash->{template} = 'not_found.tt2';
}

=head2  access_denied

If the user don't have the right authority to access a resource, sets the right template

=cut

sub access_denied :Path { #:Args(0) {
    my ($self, $c) = @_;
    $c->stash->{template} = 'denied.tt2';
}

=head2 logout

Removes a logged in user and removes possible cookies (that remember a login)

=cut

sub logout : Global {
    my ($self, $c) = @_;
    $c->logout;
    if ($c->req->cookies->{username} and $c->req->cookies->{password}) {
        $c->response->cookies->{username} = { 
            value   => '',
            expires => '-1d',
        };
        $c->response->cookies->{password} = { 
            value   => '',
            expires => '-1d',
        };
    }
    $c->flash->{message} = 'Logged out';
    $c->res->redirect($c->uri_for('/'));
}

=head2 check_login

Called from auto, checks a users credentials and let him/her in or gives a login page. If the user can log in, in stores that information in the database. Possible parameters are saved.

=cut

sub check_login : Private {
    my ( $self, $c ) = @_;

    my ($username, $password, $remember);
    if ( $c->user_exists ) { return 1 }
    elsif ($c->req->cookies->{username} and $c->req->cookies->{password}) {
        $username = $c->req->cookies->{username}->{value}->[0];
        $password = $c->req->cookies->{password}->{value}->[0];
    } else {
        $username = delete $c->request->params->{ '__username' };
        $password = delete $c->request->params->{ '__password' };
        $remember = delete $c->request->params->{ '__remember' };
    }

    if ( $username && $password ) {
        if ($c->authenticate( {
                username    => lc($username),
                password    => $password,
             } )) {
            $c->model('LaoFabDB::Logins')->create({
                user => $c->user->id,
                ip_address => $c->req->address,
                user_agent => $c->req->user_agent,
            });
            if ($remember && $remember eq 'on') {
                $c->response->cookies->{username} = { 
                    value   => $username,
                    expires => '+1y',
                };
                $c->response->cookies->{password} = { 
                    value   => $password,
                    expires => '+1y',
                };
            }
            return 1;
        }
        if ($c->req->cookies->{username} and $c->req->cookies->{password}) {
            $c->response->cookies->{username} = { 
                value   => '',
                expires => '-1d',
            };
            $c->response->cookies->{password} = { 
                value   => '',
                expires => '-1d',
            };
        }
        $c->stash->{ 'error' } = 'Incorrect username or password. Do you need to <a href="'.
            $c->uri_for('/user/password_recovery') .
            '">recover your password</a>?';
    }

	my $login_page = $c->model('LaoFabDB::Content')->find({
		page => 'login',
	});
	
	$c->stash->{login_page} = $login_page;
	$c->stash->{ 'template' } = 'login_auth.tt2';
	return 0;
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {
    my ($self, $c) = @_;
    
    my @buzzes;
    
    for (1..3) {
        my $buzz_obj = $c->model("LaoFabDB::Buzz$_")->search({},{
            order_by => 'rand()'
        })->slice(0,0);
        push @buzzes, $buzz_obj->next->name;
    }
    my $abr;
    for my $buzz (@buzzes) {
        for (split '[\s\-]', $buzz) {
            $abr .= uc(substr($_, 0, 1));
        }
    }
    $c->stash->{buzz_abr} = $abr;
    $c->stash->{buzz_word} = join ' ', @buzzes;
    
    if ($c->check_user_roles(qw|admin|) && 
        $c->model('LaoFabDB::Documents')->search({viewable => 0 })->count()) {
        $c->stash->{message} .= ' You have new pending documents!';
    }
}

=head1 AUTHOR

Joakim Lagerqvist

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
