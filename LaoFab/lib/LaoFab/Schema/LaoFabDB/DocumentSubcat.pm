package LaoFab::Schema::LaoFabDB::DocumentSubcat;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::FS", "PK::Auto", "Core");
__PACKAGE__->table("document_subcat");
__PACKAGE__->add_columns(
  "document",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "subcat",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
);
__PACKAGE__->set_primary_key("document", "subcat");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-28 10:57:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:uA5TkIOPa4hq/DbjhTKTSQ

__PACKAGE__->belongs_to('document' => 'LaoFab::Schema::LaoFabDB::Documents');
__PACKAGE__->belongs_to('subcat' => 'LaoFab::Schema::LaoFabDB::Subcats');

# You can replace this text with custom content, and it will be preserved on regeneration
1;
