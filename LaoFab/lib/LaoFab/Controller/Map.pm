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
    
    $c->stash->{menupage} = 'browse';

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

sub _get_areas_in_folder {
    my ($folder, $c) = @_;

    my @areas = ();

    for my $d ($folder->documents) {
        for my $a ($d->areas) {
            push @areas, $a;
        }
    }

    my $folders = $c->model('LaoFabDB::Folders')->search({
        parent => $folder->id,
    });

    for my $f ($folders->next) {
        push @areas, _get_areas_in_folder($f, $c) if $f;
    }
    return @areas;
}

sub folder : Local {
    my ( $self, $c, $folderid ) = @_;
    
    $c->stash->{menupage} = 'browse';

    my $folder = $c->model('LaoFabDB::Folders')->find({id => $folderid});
    my @areas = _get_areas_in_folder($folder, $c) if $folder;

    $c->stash->{folder} = $folder;
    $c->stash->{areas} = \@areas;
}


=head1 AUTHOR

Joakim Lagerqvist

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
