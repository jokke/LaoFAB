use utf8;
package LaoFab::Schema::LaoFabDB::DocumentSubcat;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LaoFab::Schema::LaoFabDB::DocumentSubcat

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

=head1 TABLE: C<document_subcat>

=cut

__PACKAGE__->table("document_subcat");

=head1 ACCESSORS

=head2 document

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 subcat

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "document",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "subcat",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</document>

=item * L</subcat>

=back

=cut

__PACKAGE__->set_primary_key("document", "subcat");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-03-31 11:54:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TJecyC0P3NKWXJ/ZKeaRvg

__PACKAGE__->belongs_to('document' => 'LaoFab::Schema::LaoFabDB::Documents');
__PACKAGE__->belongs_to('subcat' => 'LaoFab::Schema::LaoFabDB::Subcats');

# You can replace this text with custom content, and it will be preserved on regeneration
1;
