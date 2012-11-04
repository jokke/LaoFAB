package LaoFab::Controller::Buzz;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

LaoFab::Controller::Buzz - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 add

Adds a phrase in a given buzz column

=cut

sub add : Local {
    my ( $self, $c, $col ) = @_;
    
    my $word = $c->req->param('word');
    
    if (length($word) && $col > 0 && $col < 4) {
        eval {
            $c->model("LaoFabDB::Buzz$col")->create({
                name => $word,
            });
        };
        
        if ($@) {
            $c->flash->{error} = "Could not create buzz word '$word' in column '$col'...";
        } else {
            $c->flash->{message} = "'$word' created in column '$col'.";
        }
    } else {
        $c->flash->{error} = 'No legal word or column to add.';
    }
    $c->res->redirect($c->uri_for('/manage'));
    $c->detach;
}


=head2 delete

Deletes a phrase in a given buzz column

=cut

sub delete : Local {
    my ( $self, $c, $col ) = @_;
    
    my $word_id = $c->req->param('word');
    
    if ($col > 0 && $col < 4 && $word_id > 0) {
        eval {
            my $buzz = $c->model("LaoFabDB::Buzz$col")->find({ id => $word_id});
            $buzz->delete;
        };
        
        if ($@) {
            $c->flash->{error} = "Could not delete word...";
        } else {
            $c->flash->{message} = "Buzz word deleted!";
        }
    } else {
        $c->flash->{error} = "Illigal column or weird word, could not delete word!";
    }
    
    $c->res->redirect($c->uri_for('/manage'));
    $c->detach;
}


=head1 AUTHOR

Joakim Lagerqvist

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
