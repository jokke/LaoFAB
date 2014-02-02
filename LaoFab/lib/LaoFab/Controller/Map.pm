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
    my %documents;

    for my $area (@inter_areas) {
        next if $area->document->id == $document->id;
        next if grep { $_->id == $area->id } @filtered_areas;
        push @filtered_areas, $area;
        $documents{$area->document->id} = $area->document;
    }

    $c->stash->{inter_docs} = [ values %documents ];
    $c->stash->{document} = $document;
    $c->stash->{inter_areas} = \@filtered_areas;
}

sub _get_doc_for_folder {
    my ($folder, $c) = @_;

    my %docs;
    for my $d ($folder->documents) {
        $docs{$d->id} = $d if scalar ($d->areas);
    }

    my $folders = $c->model('LaoFabDB::Folders')->search({
        parent => $folder->id,
    });

    while (my $f = $folders->next) {
        for my $d (_get_doc_for_folder($f,$c)) {
            $docs{$d->id} = $d;
        }
    }

    return values %docs;
}

sub _get_areas_in_folder {
    my ($folder, $c) = @_;

    my @areas = ();
    my %areas;
    # all docs with areas;
    my $start = time;
    my @docs = _get_doc_for_folder($folder,$c);
    for my $d (_get_doc_for_folder($folder,$c)) {
        for my $a ($d->areas) {
            $areas{$a->id} = $a;
        }
    }
    @areas = values %areas;

    return (\@areas, \@docs);
}

sub folder : Local {
    my ( $self, $c, $folderid ) = @_;
    my $start = time;
    $c->stash->{menupage} = 'browse';

    my $folder = $c->model('LaoFabDB::Folders')->find({id => $folderid});
    my ($areas, $docs) = _get_areas_in_folder($folder, $c) if $folder;

    $c->stash->{folder} = $folder;
    $c->stash->{areas} = $areas;
    $c->stash->{box} = _get_box($c, @$areas);
    $c->stash->{documents} = $docs;
}

sub _get_box {
    my ($c, $first, @areas) = @_;

    my @bbox = $first->get_bbox;
    my $box = {
        east => $bbox[0],
        north => $bbox[1],
        west => $bbox[2],
        south => $bbox[3],
    };

    for my $a (@areas) {
        @bbox = $a->get_bbox;
        if ( $bbox[0] < $box->{east}) { $box->{east} = $bbox[0] };
        if ( $bbox[1] < $box->{north}) { $box->{north} = $bbox[1] };
        if ( $bbox[2] > $box->{west}) { $box->{west} = $bbox[2] };
        if ( $bbox[3] > $box->{south}) { $box->{south} = $bbox[3] };
    }

    return $box;
}

=head1 AUTHOR

Joakim Lagerqvist

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
