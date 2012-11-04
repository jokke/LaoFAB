package LaoFab::Schema::LaoFabDB::Comments;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::FS", "PK::Auto", "Core");
__PACKAGE__->table("comments");
__PACKAGE__->add_columns(
  "user",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "document",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "rating",
  { data_type => "TINYINT", default_value => 3, is_nullable => 1, size => 3 },
  "comment",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "comment_dt",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
    size => 14,
  },
);
__PACKAGE__->set_primary_key("user", "document");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-28 10:57:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pOGwGTjGKre1y+1HfN2vKw


__PACKAGE__->belongs_to(
    user => 'LaoFab::Schema::LaoFabDB::User'
);
__PACKAGE__->belongs_to(
    document => 'LaoFab::Schema::LaoFabDB::Documents'
);

# You can replace this text with custom content, and it will be preserved on regeneration
1;
