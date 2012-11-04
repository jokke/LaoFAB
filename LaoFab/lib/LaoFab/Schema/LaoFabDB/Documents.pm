package LaoFab::Schema::LaoFabDB::Documents;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::FS", "PK::Auto", "Core");
__PACKAGE__->table("documents");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "title",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "sub_title",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "viewable",
  { data_type => "TINYINT", default_value => 1, is_nullable => 1, size => 4 },
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
  "doctype",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 10 },
  "mime",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "pubyear",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 4 },
  "file",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "filename",
  {
    data_type => "VARCHAR",
    default_value => "no file name",
    is_nullable => 1,
    size => 255,
  },
  "filesize",
  { data_type => "INT", default_value => 0, is_nullable => 1, size => 10 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-28 10:57:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7SIM+olgeoOyW8TEfneQIA

__PACKAGE__->resultset_class(
	'LaoFab::ResultSet::Documents');

__PACKAGE__->has_many(
    document_folder => 'LaoFab::Schema::LaoFabDB::DocumentFolder', 'document');
__PACKAGE__->many_to_many(
    folders => 'document_folder', 'folder', { order_by => \'name ASC'});
__PACKAGE__->has_many(
    document_subcat => 'LaoFab::Schema::LaoFabDB::DocumentSubcat', 'document');
__PACKAGE__->many_to_many(
    subcats => 'document_subcat', 'subcat', { order_by => \'main_cat ASC'});
__PACKAGE__->has_many(
    authors => 'LaoFab::Schema::LaoFabDB::Authors',
    'document', {
        cascading_delete => 1
    });
__PACKAGE__->has_many(
    keywords => 'LaoFab::Schema::LaoFabDB::Keywords',
    'document', {
        cascading_delete => 1
    });
__PACKAGE__->belongs_to(
    create_user => 'LaoFab::Schema::LaoFabDB::User');
__PACKAGE__->belongs_to(
    doctype => 'LaoFab::Schema::LaoFabDB::Doctypes');
__PACKAGE__->belongs_to(
    checked_user => 'LaoFab::Schema::LaoFabDB::User');
__PACKAGE__->has_many(
    downloads => 'LaoFab::Schema::LaoFabDB::Downloads',
    'document');
__PACKAGE__->has_many(
    comments => 'LaoFab::Schema::LaoFabDB::Comments',
    'document');
__PACKAGE__->has_many(
    tags => 'LaoFab::Schema::LaoFabDB::Tags',
    'document', {
        cascading_delete => 1
    });

sub short_title {
    my $self = shift;
    if (length($self->title)>34) {
         return substr($self->title, 0, 32)."...";
    }
    return $self->title;
}

sub xml_string {
    my $self = shift;
    my $xml_string = shift;
    $xml_string =~ s/[^\w\s]//g;
    $xml_string =~ s/\s+/ /g;
    $xml_string =~ s/^\s+//;
    $xml_string =~ s/\s+$//;

    return $xml_string;
}

sub xml_title {
    my $self = shift;
    return $self->xml_string($self->title);
}

sub xml_sub_title {
    my $self = shift;
    return $self->xml_string($self->sub_title);
}

sub long_authors {
    my $self = shift;
    my $author_str = "";

    foreach my $author ($self->authors) {
        $author_str .= ", " if ($author_str);
        if ($author->name && $author->org) {
            $author_str .= $author->name . " (" . $author->org . ")";
        } elsif ($author->name) {
            $author_str .= $author->name;
        } elsif ($author->org) {
            $author_str .= $author->org;
        }
    }

    return $author_str;
}

sub short_authors {
    my $self = shift;
    my $author_str = $self->long_authors;

    if (length($author_str)>34) {
        return substr($author_str, 0, 32)."...";
    }

    return $author_str;
}

sub friendly_size {
    my $self = shift;
    return "0B" unless($self->filesize);
    use POSIX qw|ceil floor log pow|;
    my @size_names = qw|B KB MB GB TB PB EB ZB YB|;
    my $file_size = $self->filesize;
    my $e = floor(log($file_size)/log(1024));
    return sprintf("%.2f".$size_names[$e], ($file_size/pow(1024, floor($e))));
}

#TODO fixme
#use LaoFab;
__PACKAGE__->add_columns(
    "file",
        {
            data_type        => 'VARCHAR',
            is_fs_column     => 1,
            #fs_column_path   => LaoFab->path_to('root', 'docs') . "",
            fs_column_path   => '/var/www/LaoFab/root/docs/',
        }
    );


# You can replace this text with custom content, and it will be preserved on regeneration
1;
