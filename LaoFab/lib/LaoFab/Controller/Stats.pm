package LaoFab::Controller::Stats;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

LaoFab::Controller::Stats - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

stats

=cut

=head2 stats

Action for showing some statistics, reads them from the DB.

=cut

sub stats : Global {
    my ( $self, $c ) = @_;
    my $last_month = DateTime->now;
    $last_month->subtract( months => 1);
    my $search_dt = DateTime::Format::MySQL->format_datetime($last_month);

    my $top_downloads = $c->model('LaoFabDB::Downloads')->search({
        download_dt => { '>=', $search_dt },
    },{
        select => [ 'document', { count => '*' }],
#        as => [qw/ document id /],
#        prefetch => 'document',
        group_by => [qw/ document /],
        order_by => [' count(*) desc '],
    })->slice(0,9);

    $c->stash->{top_downloads} = $top_downloads;
    my $top_downloaders = $c->model('LaoFabDB::Downloads')->search({
        download_dt => { '>=', $search_dt },
    },{
        select => [ 'user', { count => '*' }],
#        as => [qw/ user id /],
#        prefetch => 'user',
        group_by => [qw/ user /],
        order_by => [' count(*) desc '],
    })->slice(0,9);

    $c->stash->{top_downloaders} = $top_downloaders;
    my $top_logins = $c->model('LaoFabDB::Logins')->search({
        create_dt => { '>=', $search_dt },
    },{
        select => [ 'user', { count => '*' }],
        as => [qw/ user id /],
        group_by => [qw/ user /],
        order_by => [' count(*) desc '],
    })->slice(0,9);

    $c->stash->{top_logins} = $top_logins;
    my $top_ratings = $c->model('LaoFabDB::Comments')->search({
        comment_dt => { '>=', $search_dt },
    },{
        select => [ 'user', { count => '*' }],
        as => [qw/ user rating /],
        group_by => [qw/ user /],
        order_by => [' count(*) desc '],
    })->slice(0,9);

    $c->stash->{top_ratings} = $top_ratings;
    my $top_searches = $c->model('LaoFabDB::Phrases')->search({
        search_dt => { '>=', $search_dt },
    },{
        select => [ 'word', { count => '*' }],
        as => [qw/ word id /],
        group_by => [qw/ word /],
        order_by => [' count(*) desc '],
    })->slice(0,9);

    $c->stash->{top_searches} = $top_searches;
    my $most_rated = $c->model('LaoFabDB::Comments')->search({
        comment_dt => { '>=', $search_dt },
    },{
        select => [ 'document', { count => '*' }],
        as => [qw/ document rating /],
        group_by => [qw/ document /],
        order_by => [' count(*) desc '],
    })->slice(0,9);

    $c->stash->{most_rated} = $most_rated;
    my $highest_rated = $c->model('LaoFabDB::Comments')->search({
        comment_dt => { '>=', $search_dt },
    },{
        select => [ 'document', { avg => 'rating' }],
        as => [qw/ document rating /],
        group_by => [qw/ document /],
        order_by => [' avg(rating) desc '],
    })->slice(0,9);

    $c->stash->{highest_rated} = $highest_rated;
}

=head1 AUTHOR

Joakim Lagerqvist

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
