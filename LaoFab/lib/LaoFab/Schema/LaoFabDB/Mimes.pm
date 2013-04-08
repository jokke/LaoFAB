use utf8;
package LaoFab::Schema::LaoFabDB::Mimes;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LaoFab::Schema::LaoFabDB::Mimes

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

=head1 TABLE: C<mimes>

=cut

__PACKAGE__->table("mimes");

=head1 ACCESSORS

=head2 ext

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=head2 app

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 icon

  data_type: 'varchar'
  default_value: 'unknown'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "ext",
  { data_type => "varchar", is_nullable => 0, size => 10 },
  "app",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "icon",
  {
    data_type => "varchar",
    default_value => "unknown",
    is_nullable => 1,
    size => 20,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</ext>

=back

=cut

__PACKAGE__->set_primary_key("ext");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-03-31 11:54:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OU7QceNw5vcA8qBjEYGIng


# You can replace this text with custom content, and it will be preserved on regeneration
1;
