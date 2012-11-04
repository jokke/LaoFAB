package LaoFab::View::TT::NoWrap;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
    INCLUDE_PATH => [
        LaoFab->path_to( 'root', 'src' ),
    ],
);

=head1 NAME

LaoFab::View::TT::NoWrap - TT View for LaoFab

=head1 DESCRIPTION

TT View for LaoFab. 

=head1 SEE ALSO

L<LaoFab>

=head1 AUTHOR

Joakim Lagerqvist

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
