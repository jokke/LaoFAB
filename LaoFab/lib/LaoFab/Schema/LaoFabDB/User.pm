package LaoFab::Schema::LaoFabDB::User;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::FS", "PK::Auto", "Core");
__PACKAGE__->table("user");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "username",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "password",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "create_dt",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
    size => 14,
  },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("username", ["username"]);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-28 10:57:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vhAuSffqMiA01k2hRp3/SQ

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


# You can replace this text with custom content, and it will be preserved on regeneration
1;
