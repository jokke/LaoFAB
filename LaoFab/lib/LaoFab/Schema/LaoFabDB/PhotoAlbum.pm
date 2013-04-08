use utf8;
package LaoFab::Schema::LaoFabDB::PhotoAlbum;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LaoFab::Schema::LaoFabDB::PhotoAlbum

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::FS>

=item * L<DBIx::Class::PK::Auto>

=item * L<DBIx::Class::GeomColumns>

=back

=cut

__PACKAGE__->load_components("InflateColumn::FS", "PK::Auto", "GeomColumns");

=head1 TABLE: C<photo_album>

=cut

__PACKAGE__->table("photo_album");

=head1 ACCESSORS

=head2 photo

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 album

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "photo",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "album",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</photo>

=item * L</album>

=back

=cut

__PACKAGE__->set_primary_key("photo", "album");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-03-31 11:54:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BzV+ZV42beEFJwOaH8+rww

__PACKAGE__->belongs_to('photo' => 'LaoFab::Schema::LaoFabDB::Photos');
__PACKAGE__->belongs_to('album' => 'LaoFab::Schema::LaoFabDB::Albums');

# You can replace this text with custom content, and it will be preserved on regeneration
1;
