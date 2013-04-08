use utf8;
package LaoFab::Schema::LaoFabDB::Subcats;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LaoFab::Schema::LaoFabDB::Subcats

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

=head1 TABLE: C<subcats>

=cut

__PACKAGE__->table("subcats");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 main_cat

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 sub_cat

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "main_cat",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "sub_cat",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-03-31 11:54:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:e6HPkoz2dZgekC/jvoHLSg

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
