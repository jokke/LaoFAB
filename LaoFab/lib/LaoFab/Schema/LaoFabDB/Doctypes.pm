package LaoFab::Schema::LaoFabDB::Doctypes;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::FS", "PK::Auto", "Core");
__PACKAGE__->table("doctypes");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-28 10:57:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EyfiMS/Uadi9t/iH/rIC4A

__PACKAGE__->has_many(
    documents => 'LaoFab::Schema::LaoFabDB::Documents',
    'doctype');


# You can replace this text with custom content, and it will be preserved on regeneration
1;
