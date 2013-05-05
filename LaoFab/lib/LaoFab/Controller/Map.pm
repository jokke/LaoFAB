package LaoFab::Controller::Map;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

LaoFab::Controller::Map - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub intersect : Local {
    my ( $self, $c, $docid ) = @_;

    my $document = $c->model('LaoFabDB::Documents')->find({id => $docid});
    my @inter_areas;
    for my $area ($document->areas) {
        push @inter_areas, $c->model('LaoFabDB::Areas')->search_intersecting($area->polygon);
    }


    my @filtered_areas;

    for my $area (@inter_areas) {
        next if $area->document->id == $document->id;
        next if grep { $_->id == $area->id } @filtered_areas;
        push @filtered_areas, $area;
    }

    $c->stash->{document} = $document;
    $c->stash->{inter_areas} = \@filtered_areas;
}


=head1 AUTHOR

Joakim Lagerqvist

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
