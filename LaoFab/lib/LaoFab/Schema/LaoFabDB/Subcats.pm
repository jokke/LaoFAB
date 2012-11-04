package LaoFab::Schema::LaoFabDB::Subcats;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::FS", "PK::Auto", "Core");
__PACKAGE__->table("subcats");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "main_cat",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "sub_cat",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-28 10:57:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZQIDuNXFa4wDov+1/fw6WQ

sub full_cat {
    my $self = shift;
    return $self->main_cat.': '.$self->sub_cat;
}

__PACKAGE__->has_many(
    document_subcat => 'LaoFab::Schema::LaoFabDB::DocumentSubcat', 'subcat');
__PACKAGE__->many_to_many(
    documents => 'document_subcat', 'document', { order_by => \'title ASC'});


# You can replace this text with custom content, and it will be preserved on regeneration
1;
