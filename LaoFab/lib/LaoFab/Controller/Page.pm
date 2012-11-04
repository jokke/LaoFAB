package LaoFab::Controller::Page;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

LaoFab::Controller::Page - Catalyst Controller to control content on pages

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

edit

=cut


=head2 edit

an action for edit a page, must have a param of the page's identifier

=cut

sub edit : Local {
	my ($self, $c, $page) = @_;
	my ($heading, $body);
	if ($c->req->param('heading') && length($c->req->param('heading'))) {
		$heading = $c->req->param('heading');
		$body = $c->req->param('body');
		$heading =~ s/\s+/ /g;
		$body =~ s/\s+/ /g;
		$heading =~ s/^\s//;
		$heading =~ s/\s$//;
		$body =~ s/^\s//;
		$body =~ s/\s$//;
		my $page_obj = $c->model('LaoFabDB::Content')->find({
			page => $page,
		});
		if ($page_obj) {
			$page_obj->heading($heading);
			$page_obj->body($body);
			$page_obj->update;
			$c->flash->{message} = "\u$page page updated successfully!";
			$c->res->redirect($c->uri_for("/manage"));
			$c->detach;
		} else {
			$c->flash->{error} = 'Something went wrong with the update, page is NOT updated!';
			$c->res->redirect($c->uri_for("/manage"));
			$c->detach;
		}
	} else {
		# prepare the form page
		my $page_obj = $c->model('LaoFabDB::Content')->find({
			page => $page,
		});
		if ($page_obj) {
			$c->stash->{page} = $page_obj;
			$c->stash->{heading} = "\u$page";		
		} else {
			$c->flash->{error} = "\u$page not found in the system...";
			$c->res->redirect($c->uri_for("/manage"));
			$c->detach;
		}
	}
}


=head1 AUTHOR

Joakim Lagerqvist

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
