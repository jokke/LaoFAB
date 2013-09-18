package LaoFab::Controller::Export;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use DateTime;

=head1 NAME

LaoFab::Controller::Export - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

excel

=cut


=head2 excel

action to get all viewable documents (not the actual files, just the data) into an excel file.

=cut

sub excel : Local {
    my ( $self, $c ) = @_;

    my $documents =$c->model('LaoFabDB::Documents')->search({},
	{
        order_by => 'title asc',
    })->viewable;

    $c->stash->{documents} = $documents;

    $c->stash->{current_date} = DateTime->now()->ymd;

    $c->response->header('Content-Disposition' => 'attachment; filename=LaoFAB_DR.xls');
    $c->stash->{template} = 'test_one.xml.tmpl';

    $c->forward('LaoFab::View::EXCEL');
}


=head1 AUTHOR

Joakim Lagerqvist

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
