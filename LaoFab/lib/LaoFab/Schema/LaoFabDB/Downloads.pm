use utf8;
package LaoFab::Schema::LaoFabDB::Downloads;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LaoFab::Schema::LaoFabDB::Downloads

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

=head1 TABLE: C<downloads>

=cut

__PACKAGE__->table("downloads");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 download_dt

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 user

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 document

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 photo

  data_type: 'integer'
  extra: {unsigned => 1}
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
  "download_dt",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "user",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "document",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "photo",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-11-18 13:01:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:B6NTMp5Sf9gFlRDI727UxA

__PACKAGE__->belongs_to(
    user => 'LaoFab::Schema::LaoFabDB::User'
);
__PACKAGE__->belongs_to(
    document => 'LaoFab::Schema::LaoFabDB::Documents'
);
__PACKAGE__->belongs_to(
    photo => 'LaoFab::Schema::LaoFabDB::Photos'
);
#albums?

# You can replace this text with custom content, and it will be preserved on regeneration
1;
