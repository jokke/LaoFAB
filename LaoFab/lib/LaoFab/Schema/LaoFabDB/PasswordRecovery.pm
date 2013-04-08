use utf8;
package LaoFab::Schema::LaoFabDB::PasswordRecovery;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

LaoFab::Schema::LaoFabDB::PasswordRecovery

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

=head1 TABLE: C<password_recovery>

=cut

__PACKAGE__->table("password_recovery");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 user

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 user_agent

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 ip_address

  data_type: 'varchar'
  is_nullable: 1
  size: 15

=head2 secret

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 expire_dt

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "user",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "user_agent",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "ip_address",
  { data_type => "varchar", is_nullable => 1, size => 15 },
  "secret",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "expire_dt",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-03-31 11:54:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Eml4R4P5n+XVjkjzgMp8Nw

__PACKAGE__->belongs_to(
    'user', 'LaoFab::Schema::LaoFabDB::User',
    { id => 'user' },
);

use DateTime;
use DateTime::Format::MySQL;
use Digest::SHA;

sub new {
	my ( $class, $attrs ) = @_;

	$attrs->{expire_dt} = DateTime::Format::MySQL->format_datetime(
		DateTime->now->add(days => 1)
	);
	$attrs->{secret} = $class->_generate_secret(
		$attrs->{expire_dt}, 
		$attrs->{user}->username, 
		$attrs->{user}->password,
	);

    my $new = $class->next::method($attrs);

	return $new;
}

sub _generate_secret {
	my ( $self ) = shift;
	my $input = join ',', @_;
	return Digest::SHA::sha1_hex($input);
}

sub validate {
	my ( $self, $provided_secret, $user, $c) = @_;
	my $secret = $self->_generate_secret(
		$self->expire_dt, 
		$self->user->username, 
		$self->user->password,
	);
	if ($secret eq $provided_secret) {
		return 1;
	}
	return 0;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
