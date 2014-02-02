use utf8;
package LaoFab::Schema::LaoFabDB::Documents;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LaoFab::Schema::LaoFabDB::Documents

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

=head1 TABLE: C<documents>

=cut

__PACKAGE__->table("documents");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 sub_title

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 viewable

  data_type: 'tinyint'
  default_value: 1
  is_nullable: 1

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

=head2 doctype

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 mime

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 pubyear

  data_type: 'char'
  is_nullable: 1
  size: 4

=head2 file

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 filename

  data_type: 'varchar'
  default_value: 'no file name'
  is_nullable: 1
  size: 255

=head2 filesize

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 1

=head2 permission

  data_type: 'char'
  default_value: 're'
  is_nullable: 0
  size: 2

=head2 preview

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 1

=head2 hot

  data_type: 'integer'
  default_value: 0
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
  "title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "sub_title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "viewable",
  { data_type => "tinyint", default_value => 1, is_nullable => 1 },
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
  "doctype",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "mime",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "pubyear",
  { data_type => "char", is_nullable => 1, size => 4 },
  "file",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "filename",
  {
    data_type => "varchar",
    default_value => "no file name",
    is_nullable => 1,
    size => 255,
  },
  "filesize",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
  "permission",
  { data_type => "char", default_value => "re", is_nullable => 0, size => 2 },
  "preview",
  { data_type => "tinyint", default_value => 0, is_nullable => 1 },
  "hot",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-02-02 02:23:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Hkrq4cqXfka8n5QW/yX9IQ

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
__PACKAGE__->has_many(
    areas => 'LaoFab::Schema::LaoFabDB::Areas',
    'document', {
        cascading_delete => 1
    });
__PACKAGE__->has_many(
    solrupdates => 'LaoFab::Schema::LaoFabDB::Solrupdates',
    'document');

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

sub insert {
    my ( $self, @args ) = @_;

    my $guard = $self->result_source->schema->txn_scope_guard;

    $self->next::method(@args);
    $self->create_related ('solrupdates', {
        update_type => 'n',
    });
    $guard->commit;
                          
    return $self;
};

sub update {
    my ( $self, @args ) = @_;

    my $guard = $self->result_source->schema->txn_scope_guard;

    $self->next::method(@args);
    $self->create_related ('solrupdates', {
        update_type => 'u',
    });
    $guard->commit;
                          
    return $self;
};

sub delete {
    my ( $self, @args ) = @_;

    my $guard = $self->result_source->schema->txn_scope_guard;

    $self->next::method(@args);
    $self->create_related ('solrupdates', {
        update_type => 'd',
    });
    $guard->commit;
                          
    return $self;
};

#TODO fixme
#use LaoFab;
__PACKAGE__->add_columns(
    "file",
        {
            data_type        => 'VARCHAR',
            is_fs_column     => 1,
            #fs_column_path   => '/var/www/LaoFab/root/docs/',
            fs_column_path   => '/var/www/laofab/LaoFab/root/docs/',
        }
    );


# You can replace this text with custom content, and it will be preserved on regeneration
1;
