use utf8;
package LaoFab::Schema::LaoFabDB::Locations;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LaoFab::Schema::LaoFabDB::Locations

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

=head1 TABLE: C<locations>

=cut

__PACKAGE__->table("locations");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 description

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 polygon

  data_type: 'geometry'
  is_nullable: 0

=head2 color

  data_type: 'char'
  default_value: 'FF0000'
  is_nullable: 1
  size: 6

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "description",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "polygon",
  { data_type => "geometry", is_nullable => 0 },
  "color",
  { data_type => "char", default_value => "FF0000", is_nullable => 1, size => 6 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-05-12 22:17:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:thLi2OaO500mzMKfLgI5Aw

__PACKAGE__->geom_columns('polygon');

sub pairs_polygon {
    my $self = shift;

    my $str_pol = $self->polygon;

    $str_pol =~ s/^POLYGON\(+//;
    $str_pol =~ s/\)+$//;

    my @pairs = map { [ split /\s+/, $_ ] } split /,\s*/, $str_pol;
    pop @pairs;

    return @pairs;
}

sub google_polygon {
    my $self = shift;

    my $str_pol = $self->polygon;

    $str_pol =~ s/^POLYGON\(+//;
    $str_pol =~ s/\)+$//;

    my @pairs = map { join (', ', split /\s+/, $_) } split /,\s*/, $str_pol;
    pop @pairs;

    return @pairs;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
