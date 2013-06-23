use utf8;
package LaoFab::Schema::LaoFabDB::Folders;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LaoFab::Schema::LaoFabDB::Folders

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

=head1 TABLE: C<folders>

=cut

__PACKAGE__->table("folders");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 parent

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 create_dt

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 create_user

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 priority

  data_type: 'tinyint'
  default_value: 0
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
  "name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "parent",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "create_dt",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "create_user",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "priority",
  { data_type => "tinyint", default_value => 0, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-06-10 14:01:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TLCU68hr6Ab/xWRfei6ldg

__PACKAGE__->has_many(
    folders => 'LaoFab::Schema::LaoFabDB::Folders',
    'parent', {
        cascading_delete => 1,
        order_by => \'name ASC',
    });

__PACKAGE__->belongs_to(
    parent => 'LaoFab::Schema::LaoFabDB::Folders'
);

__PACKAGE__->has_many(
    document_folder => 'LaoFab::Schema::LaoFabDB::DocumentFolder', 'folder');
__PACKAGE__->many_to_many(
    documents => 'document_folder', 'document', { order_by => \'title ASC'});

__PACKAGE__->resultset_class(
	'LaoFab::ResultSet::Folders');
	
# You can replace this text with custom content, and it will be preserved on regeneration
1;
