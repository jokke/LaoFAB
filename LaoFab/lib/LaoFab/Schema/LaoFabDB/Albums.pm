package LaoFab::Schema::LaoFabDB::Albums;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::FS", "PK::Auto", "Core");
__PACKAGE__->table("albums");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "parent_id",
  { data_type => "INT", default_value => 0, is_nullable => 1, size => 10 },
  "create_dt",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
    size => 14,
  },
  "create_user",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-28 10:57:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:j5AoM8wjz+MvLl38XgDJmA

__PACKAGE__->belongs_to(
    parent_id => 'LaoFab::Schema::LaoFabDB::Folders'
);

__PACKAGE__->has_many(
    photos => 'LaoFab::Schema::LaoFabDB::Photos',
    'album', { order_by => \'create_dt DESC'});

# You can replace this text with custom content, and it will be preserved on regeneration
1;
