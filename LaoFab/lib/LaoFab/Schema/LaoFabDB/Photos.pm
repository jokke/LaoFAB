package LaoFab::Schema::LaoFabDB::Photos;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::FS", "PK::Auto", "Core");
__PACKAGE__->table("photos");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "caption",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "location",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "taken_dt",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 1,
    size => 19,
  },
  "photographer",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "create_dt",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
    size => 14,
  },
  "create_user",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "checked_dt",
  {
    data_type => "TIMESTAMP",
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
    size => 14,
  },
  "checked_user",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 10 },
  "mime",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "file",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "filesize",
  { data_type => "INT", default_value => 0, is_nullable => 1, size => 10 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-28 10:57:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:w65BPe98xIHHf48O9/FPqg
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
            fs_column_path   => '/var/www/LaoFab/root/photos/',
        },
    "thumbnail",
        {
            data_type        => 'VARCHAR',
            is_fs_column     => 1,
#            fs_column_path   => LaoFab->path_to('root', 'thumbnail_photos') . "",
            fs_column_path   => '/var/www/LaoFab/root/thumbnail_photos/',
        },
    "normal",
        {
            data_type        => 'VARCHAR',
            is_fs_column     => 1,
#            fs_column_path   => LaoFab->path_to('root', 'normal_size_photos') . "",
            fs_column_path   => '/var/www/LaoFab/root/normal_size_photos/',
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
