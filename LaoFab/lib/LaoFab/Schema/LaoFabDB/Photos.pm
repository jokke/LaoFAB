use utf8;
package LaoFab::Schema::LaoFabDB::Photos;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LaoFab::Schema::LaoFabDB::Photos

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

=head1 TABLE: C<photos>

=cut

__PACKAGE__->table("photos");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 caption

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 location

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 taken_dt

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 photographer

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 create_dt

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 create_user

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 checked_dt

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 checked_user

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 mime

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 file

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 filesize

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 1

=head2 album

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 thumbnail

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 normal

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 width

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 height

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "caption",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "location",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "taken_dt",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "photographer",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "create_dt",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "create_user",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "checked_dt",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "checked_user",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "mime",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "file",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "filesize",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
  "album",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "thumbnail",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "normal",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "width",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "height",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-05-12 22:17:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+MAKvdHVR5oZ6MhjvX8eJg
__PACKAGE__->add_columns(
  "album",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
);

__PACKAGE__->belongs_to(
    album => 'LaoFab::Schema::LaoFabDB::Albums');

__PACKAGE__->belongs_to(
    create_user => 'LaoFab::Schema::LaoFabDB::User');

__PACKAGE__->resultset_class(
	'LaoFab::ResultSet::Photos');
	
#TODO fixme
#use LaoFab;
__PACKAGE__->add_columns(
    "file",
        {
            data_type        => 'VARCHAR',
            is_fs_column     => 1,
#            fs_column_path   => LaoFab->path_to('root', 'photos') . "",
            fs_column_path   => '/var/www/laofab/LaoFab/root/photos/',
        },
    "thumbnail",
        {
            data_type        => 'VARCHAR',
            is_fs_column     => 1,
#            fs_column_path   => LaoFab->path_to('root', 'thumbnail_photos') . "",
            fs_column_path   => '/var/www/laofab/LaoFab/root/thumbnail_photos/',
        },
    "normal",
        {
            data_type        => 'VARCHAR',
            is_fs_column     => 1,
#            fs_column_path   => LaoFab->path_to('root', 'normal_size_photos') . "",
            fs_column_path   => '/var/www//laofab/LaoFab/root/normal_size_photos/',
        },
    );

sub friendly_size {
    my $self = shift;
    return "0B" unless($self->filesize);
    use POSIX qw|ceil floor log pow|;
    my @size_names = qw|B KB MB GB TB PB EB ZB YB|;
    my $file_size = $self->filesize;
    my $e = floor(log($file_size)/log(1024));
    return sprintf("%.2f".$size_names[$e], ($file_size/pow(1024, floor($e))));
}

sub date_only {
    my $self = shift;

    return substr($self->taken_dt, 0, 10);
}
# You can replace this text with custom content, and it will be preserved on regeneration
1;
