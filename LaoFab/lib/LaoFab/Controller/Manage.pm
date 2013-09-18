package LaoFab::Controller::Manage;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

LaoFab::Controller::Manage - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

manage

=cut

=head2 manage

Basically just reads the different pages from the database.

=cut

sub manage : Global {
    my ( $self, $c ) = @_;
    $c->stash->{menupage} = 'manage';
    # my $login_page = $c->model('DB::Content')->find({
    #       page => 'login',
    #   });
    # 
    # $c->stash->{login_page} = $login_page;
    # 
    # my $first_page = $c->model('DB::Content')->find({
    #   page => 'start',
    # });
    # 
    # $c->stash->{first_page} = $first_page;
	$c->stash->{buzz1} = $c->model('LaoFabDB::Buzz1')->search({},{order_by => 'name'});
	$c->stash->{buzz2} = $c->model('LaoFabDB::Buzz2')->search({},{order_by => 'name'});
	$c->stash->{buzz3} = $c->model('LaoFabDB::Buzz3')->search({},{order_by => 'name'});
}

=head1 AUTHOR

Joakim Lagerqvist

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
