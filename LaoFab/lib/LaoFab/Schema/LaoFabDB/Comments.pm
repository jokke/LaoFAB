use utf8;
package LaoFab::Schema::LaoFabDB::Comments;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LaoFab::Schema::LaoFabDB::Comments

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

=head1 TABLE: C<comments>

=cut

__PACKAGE__->table("comments");

=head1 ACCESSORS

=head2 user

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 document

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 rating

  data_type: 'tinyint'
  default_value: 3
  extra: {unsigned => 1}
  is_nullable: 1

=head2 comment

  data_type: 'text'
  is_nullable: 1

=head2 comment_dt

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "document",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "rating",
  {
    data_type => "tinyint",
    default_value => 3,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
  "comment",
  { data_type => "text", is_nullable => 1 },
  "comment_dt",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</user>

=item * L</document>

=back

=cut

__PACKAGE__->set_primary_key("user", "document");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-03-31 11:54:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XxbjFwltkMun36iOhldz3A


__PACKAGE__->belongs_to(
    user => 'LaoFab::Schema::LaoFabDB::User'
);
__PACKAGE__->belongs_to(
    document => 'LaoFab::Schema::LaoFabDB::Documents'
);

# You can replace this text with custom content, and it will be preserved on regeneration
1;
