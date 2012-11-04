package LaoFab::Schema::LaoFabDB::Authors;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::FS", "PK::Auto", "Core");
__PACKAGE__->table("authors");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "org",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "document",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-28 10:57:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rkvfLIMgPqZlW3EwwucIAw

__PACKAGE__->belongs_to(
    document => 'LaoFab::Schema::LaoFabDB::Documents'
    );

sub xml_string {
    my $self = shift;
    my $xml_string = shift;
    $xml_string =~ s/[^\w\s]//g;
    $xml_string =~ s/\s+/ /g;
    $xml_string =~ s/^\s+//;
    $xml_string =~ s/\s+$//;

    return $xml_string;
}

sub xml_name {
    my $self = shift;
    return $self->xml_string($self->name);
}

sub xml_org {
    my $self = shift;
    return $self->xml_string($self->org);
}

# You can replace this text with custom content, and it will be preserved on regeneration
1;
