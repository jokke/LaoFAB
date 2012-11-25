use utf8;
package LaoFab::Schema::LaoFabDB::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LaoFab::Schema::LaoFabDB::User

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

=head1 TABLE: C<user>

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 username

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 password

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 create_dt

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "username",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "password",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "create_dt",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 100 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<username>

=over 4

=item * L</username>

=back

=cut

__PACKAGE__->add_unique_constraint("username", ["username"]);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-11-18 13:01:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3lGHilSPaNKjnj2Yuxypqg

__PACKAGE__->has_many(map_user_role => 'LaoFab::Schema::LaoFabDB::UserRole', 'user');

__PACKAGE__->many_to_many(roles => 'map_user_role', 'role');

__PACKAGE__->has_many(
    documents => 'LaoFab::Schema::LaoFabDB::Documents', 'create_user');

__PACKAGE__->has_many(
    ch_documents => 'LaoFab::Schema::LaoFabDB::Documents', 'checked_user');

__PACKAGE__->has_many(
    phrases => 'LaoFab::Schema::LaoFabDB::Phrases', 'user');

__PACKAGE__->has_many(
    downloads => 'LaoFab::Schema::LaoFabDB::Downloads', 'user');

__PACKAGE__->has_many(
    logins => 'LaoFab::Schema::LaoFabDB::Logins', 'user');

__PACKAGE__->has_many(
    comments => 'LaoFab::Schema::LaoFabDB::Comments', 'user');

__PACKAGE__->has_many(
    passwordrecoveries => 'LaoFab::Schema::LaoFabDB::PasswordRecovery', 'user');

use Digest;

sub store_column {
	my ($self, $col, $val) = @_;

	$val = Digest->new('SHA1')->add($val)->b64digest
		if $col eq 'password';

	return $self->next::method( $col, $val);
}

# You can replace this text with custom content, and it will be preserved on regeneration
1;
