use utf8;
package LaoFab::Schema::LaoFabDB::Area;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LaoFab::Schema::LaoFabDB::Area

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

=head1 TABLE: C<area>

=cut

__PACKAGE__->table("area");

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
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-03-31 11:54:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aUwBxs8G4xsAOJcb1trYLw

__PACKAGE__->belongs_to(
    document => 'LaoFab::Schema::LaoFabDB::Documents'
);

use Math::Polygon;

__PACKAGE__->geom_columns('center','polygon');

sub bbox {
    my $self = shift;

    my $poly = $self->real_polygon;

    return $poly->bbox;
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

sub google_center {
    my $self = shift;

    my $str_pol = $self->center;
    
    $str_pol =~ s/^POINT\(+//;
    $str_pol =~ s/\)+$//;

    my @pairs = map { join (', ', split /\s+/, $_) } split /,\s*/, $str_pol;

    return @pairs;
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

sub to_polygon {
    my ($self, $str_pol) = @_;

    $str_pol =~ s/^\(//;
    $str_pol =~ s/\)$//;
    my @pairs = map { [ split /,\s/, $_ ] } split /\)\(/, $str_pol;
    push @pairs, [$pairs[0]->[0], $pairs[0]->[1]]; # complete the polygon
    my $mysql_polygon = 'POLYGON(('.join (', ', map { join (' ', @$_) } @pairs).'))';
    return $mysql_polygon;
}

sub from_polygon {
    my ($self, $str_pol) = @_;
    
    $str_pol =~ s/^POLYGON\(+//;
    $str_pol =~ s/\)+$//;

    my @pairs = map { join (', ', split /\s+/, $_) } split /,\s+/, $str_pol;
    pop @pairs;

    return @pairs;
}


sub to_center {
    my ($self, $str_ctr) = @_;

    $str_ctr =~ s/^\(//;
    $str_ctr =~ s/\)$//;
    my @pair = split /,\s*/, $str_ctr;

    my $mysql_center = 'POINT('.join (' ', @pair).')';
    return $mysql_center;
}

#around polygon => sub {
#    my ($orig, $self) = (shift, shift);
#
#    if (@_) {
#        my $value = shift;
#        $value =~ s/^POLYGON\(+//;
#        $value =~ s/\)+$//;
#        my @pairs = map { [ split /\s+/, $_ ] } split /,\s*/, $value;
#        push @pairs, [$pairs[0]->[0], $pairs[0]->[1]]; # complete the polygon
#        my $poly = Math::Polygon->new(@pairs);
#        use feature 'say';
#        say $poly->center;
#        $self->squared( $value * $value );
#    }

#    $self->$orig(@_);
#};

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
