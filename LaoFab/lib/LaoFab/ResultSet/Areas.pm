package LaoFab::ResultSet::Areas;
use strict;
use warnings;
use base qw/
			DBIx::Class::ResultSet
			/;

sub search_intersecting {
    my ($self, $polygon) = @_;

    return $self->search(\[ 'Intersects(polygon, GeomFromText( ? ))' , 
        [ 
            plain_value => $polygon, #"POLYGON((20 101,17 101,20 101))" 
        ] 
    ]);
}

1;
