package LaoFab::Model::Solr;
use Moose;
use namespace::autoclean;

extends 'Catalyst::Model::WebService::Solr';

=head1 NAME

LaoFab::Model::Solr - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.

=head1 AUTHOR

Joakim Lagerqvist

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
__PACKAGE__->config(
    server  => 'http://localhost:8983/solr/',
    options => {
        autocommit => 1,
    }
);

__PACKAGE__->meta->make_immutable;

1;
