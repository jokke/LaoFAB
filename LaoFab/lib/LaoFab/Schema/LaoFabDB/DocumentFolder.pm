use utf8;
package LaoFab::Schema::LaoFabDB::DocumentFolder;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LaoFab::Schema::LaoFabDB::DocumentFolder

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

=head1 TABLE: C<document_folder>

=cut

__PACKAGE__->table("document_folder");

=head1 ACCESSORS

=head2 document

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 folder

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "document",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "folder",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</document>

=item * L</folder>

=back

=cut

__PACKAGE__->set_primary_key("document", "folder");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-03-31 11:54:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TJeYBgnTOGtis+4TtvAnBw

__PACKAGE__->belongs_to('document' => 'LaoFab::Schema::LaoFabDB::Documents');
__PACKAGE__->belongs_to('folder' => 'LaoFab::Schema::LaoFabDB::Folders');

# You can replace this text with custom content, and it will be preserved on regeneration
1;
