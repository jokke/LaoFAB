package LaoFab::Schema::LaoFabDB::Mimes;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::FS", "PK::Auto", "Core");
__PACKAGE__->table("mimes");
__PACKAGE__->add_columns(
  "ext",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "app",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "icon",
  {
    data_type => "VARCHAR",
    default_value => "unknown",
    is_nullable => 1,
    size => 20,
  },
);
__PACKAGE__->set_primary_key("ext");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-28 10:57:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:m8wGSE6TYvcGcmjZ3thKlg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
