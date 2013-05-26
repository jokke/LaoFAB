use utf8;
package LaoFab::Schema::LaoFabDB::Solrupdates;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LaoFab::Schema::LaoFabDB::Solrupdates

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

=head1 TABLE: C<solrupdates>

=cut

__PACKAGE__->table("solrupdates");

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

=head2 update_type

  data_type: 'char'
  default_value: 'n'
  is_nullable: 1
  size: 1

=head2 indexed

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 1

=head2 request_dt

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 indexed_dt

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
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
  "update_type",
  { data_type => "char", default_value => "n", is_nullable => 1, size => 1 },
  "indexed",
  { data_type => "tinyint", default_value => 0, is_nullable => 1 },
  "request_dt",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "indexed_dt",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-05-19 14:48:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GpWjVdaeSTe5RwLh8FRFCg

__PACKAGE__->belongs_to(
    document => 'LaoFab::Schema::LaoFabDB::Documents',
    'document', { 
        join_type => 'left',
    });

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
