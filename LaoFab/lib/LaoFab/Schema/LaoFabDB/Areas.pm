use utf8;
package LaoFab::Schema::LaoFabDB::Areas;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LaoFab::Schema::LaoFabDB::Areas

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::FS>

=item * L<DBIx::Class::PK::Auto>

=item * L<DBIx::Class::GeomColumns>

=back

=cut

__PACKAGE__->load_components("InflateColumn::FS", "PK::Auto", "GeomColumns");

=head1 TABLE: C<areas>

=cut

__PACKAGE__->table("areas");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 document

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 polygon

  data_type: 'geometry'
  is_nullable: 0

=head2 center

  data_type: 'geometry'
  is_nullable: 0

=head2 map_point

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 bbox

  data_type: 'geometry'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "document",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "polygon",
  { data_type => "geometry", is_nullable => 0 },
  "center",
  { data_type => "geometry", is_nullable => 0 },
  "map_point",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "bbox",
  { data_type => "geometry", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-02-02 02:23:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vfPwJBewkbzpwbb1adC7/A

__PACKAGE__->belongs_to(
    document => 'LaoFab::Schema::LaoFabDB::Documents'
);
__PACKAGE__->resultset_class(
    'LaoFab::ResultSet::Areas');

use Math::Polygon;

__PACKAGE__->geom_columns('center','polygon','bbox');

#sub bbox {
#    my $self = shift;
#
#    my $poly = $self->real_polygon;
#
#    return $poly->bbox;
#}

sub google_polygon {
    my $self = shift;

    my $str_pol = $self->polygon;

    $str_pol =~ s/^POLYGON\(+//;
    $str_pol =~ s/\)+$//;

    my @pairs = map { join (', ', split /\s+/, $_) } split /,\s*/, $str_pol;
    pop @pairs;

    return @pairs;
}

sub google_center {
    my $self = shift;

    my $str_pol = $self->center;

    $str_pol =~ s/^POINT\(+//;
    $str_pol =~ s/\)+$//;

    my @pairs = map { join (', ', split /\s+/, $_) } split /,\s*/, $str_pol;

    return @pairs;
}

sub calc_bbox {
    my $self = shift;
    my $poly = $self->real_polygon;
    my @bbox = $poly->bbox;

    return 'POLYGON(('.$bbox[0].' '.$bbox[1].', '.
                       $bbox[2].' '.$bbox[1].', '.
                       $bbox[2].' '.$bbox[3].', '.
                       $bbox[0].' '.$bbox[3].', '.
                       $bbox[0].' '.$bbox[1].'))';
}

sub calc_map_point {
    my $self = shift;
    my $poly = $self->real_polygon;
    my @bbox = $self->get_bbox;
    my @point;
    do {
        $point[0] = sprintf("%.12f", rand ($bbox[2]-$bbox[0])) + $bbox[0];
        $point[1] = sprintf("%.12f", rand ($bbox[3]-$bbox[1])) + $bbox[1];
    } until ($poly->contains(\@point));
    return $point[0].', '.$point[1];
}

sub get_bbox {
    my $self = shift;
    my $value = $self->bbox;
    $value =~ s/^POLYGON\(+//;
    $value =~ s/\)+$//;
    my @pairs = map { [ split /\s+/, $_ ] } split /,\s*/, $value;
    my $poly = Math::Polygon->new(@pairs);
    return $poly->bbox;
}

sub calc_center {
    my $self = shift;
    my $poly = $self->real_polygon;

    return 'POINT('.join (' ',@{$poly->centroid}).')';
}

sub real_polygon {
    my $self = shift;

    my $value = $self->polygon;
    $value =~ s/^POLYGON\(+//;
    $value =~ s/\)+$//;
    my @pairs = map { [ split /\s+/, $_ ] } split /,\s*/, $value;
#    push @pairs, [$pairs[0]->[0], $pairs[0]->[1]]; # complete the polygon
    my $poly = Math::Polygon->new(@pairs);
    return $poly;
}


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
