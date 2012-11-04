package LaoFab::Schema::LaoFabDB::Phrases;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::FS", "PK::Auto", "Core");
__PACKAGE__->table("phrases");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "word",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "user",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "search_dt",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
    size => 14,
  },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-28 10:57:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5srtAhPWzYlq7NTXrmz9eQ

__PACKAGE__->belongs_to(
    user => 'LaoFab::Schema::LaoFabDB::User');

# You can replace this text with custom content, and it will be preserved on regeneration
1;
