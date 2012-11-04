package LaoFab::Schema::LaoFabDB::PhotoAlbum;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::FS", "PK::Auto", "Core");
__PACKAGE__->table("photo_album");
__PACKAGE__->add_columns(
  "photo",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "album",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
);
__PACKAGE__->set_primary_key("photo", "album");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-28 10:57:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Y0hfXRsyW7FgLoxF/xGbdw

__PACKAGE__->belongs_to('photo' => 'LaoFab::Schema::LaoFabDB::Photos');
__PACKAGE__->belongs_to('album' => 'LaoFab::Schema::LaoFabDB::Albums');

# You can replace this text with custom content, and it will be preserved on regeneration
1;
