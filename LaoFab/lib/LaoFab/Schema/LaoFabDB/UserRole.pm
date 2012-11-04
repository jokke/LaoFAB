package LaoFab::Schema::LaoFabDB::UserRole;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::FS", "PK::Auto", "Core");
__PACKAGE__->table("user_role");
__PACKAGE__->add_columns(
  "user",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "role",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
);
__PACKAGE__->set_primary_key("user", "role");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-28 10:57:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:J8frTYXBh157DoFbsCLLmA

__PACKAGE__->belongs_to(user => 'LaoFab::Schema::LaoFabDB::User', 'user');
__PACKAGE__->belongs_to(role => 'LaoFab::Schema::LaoFabDB::Role', 'role');

# You can replace this text with custom content, and it will be preserved on regeneration
1;
