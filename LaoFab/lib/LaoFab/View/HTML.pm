package LaoFab::View::HTML;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config({
    INCLUDE_PATH => [
        LaoFab->path_to( 'root', 'src' ),
        LaoFab->path_to( 'root', 'lib' )
    ],
    PRE_PROCESS        => 'config/main',
    WRAPPER            => 'site/wrapper',
    ERROR              => 'error.tt2',
    TEMPLATE_EXTENSION => '.tt2',
    TIMER              => 0
});

=head1 NAME

LaoFab::View::HTML - Catalyst TTSite View

=head1 SYNOPSIS

See L<LaoFab>

=head1 DESCRIPTION

Catalyst TTSite View.

=head1 AUTHOR

Joakim Lagerqvist

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

