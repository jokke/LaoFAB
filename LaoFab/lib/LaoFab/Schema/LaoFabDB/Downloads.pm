package LaoFab::Schema::LaoFabDB::Downloads;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::FS", "PK::Auto", "Core");
__PACKAGE__->table("downloads");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "download_dt",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
    size => 14,
  },
  "user",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "document",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 10 },
  "photo",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 10 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-28 10:57:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XSpuQKyvISMom+FK7BwpkQ

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
