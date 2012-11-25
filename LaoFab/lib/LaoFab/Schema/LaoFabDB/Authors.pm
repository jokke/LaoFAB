use utf8;
package LaoFab::Schema::LaoFabDB::Authors;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LaoFab::Schema::LaoFabDB::Authors

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::FS>

=item * L<DBIx::Class::PK::Auto>

=back

=cut

__PACKAGE__->load_components("InflateColumn::FS", "PK::Auto");

=head1 TABLE: C<authors>

=cut

__PACKAGE__->table("authors");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 org

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 document

  data_type: 'integer'
  extra: {unsigned => 1}
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
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "org",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "document",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-11-18 13:01:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QpsdMEZkBxWRASWtEqzuFw

__PACKAGE__->belongs_to(
    document => 'LaoFab::Schema::LaoFabDB::Documents'
    );

sub xml_string {
    my $self = shift;
    my $xml_string = shift;
    $xml_string =~ s/[^\w\s]//g;
    $xml_string =~ s/\s+/ /g;
    $xml_string =~ s/^\s+//;
    $xml_string =~ s/\s+$//;

    return $xml_string;
}

sub xml_name {
    my $self = shift;
    return $self->xml_string($self->name);
}

sub xml_org {
    my $self = shift;
    return $self->xml_string($self->org);
}

# You can replace this text with custom content, and it will be preserved on regeneration
1;
