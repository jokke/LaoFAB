package LaoFab::Controller::Feed;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use XML::Feed;
use DateTime;
use DateTime::Format::MySQL;

=head1 NAME

LaoFab::Controller::Feed - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller to handle RSS and Atmom feeds for the 15 latest uploaded documents.

=head1 METHODS

atom
rss
end

=cut


=head2 atom

Just sets the type to Atmo

=cut

sub atom : Local {
    my ($self, $c) = @_;
    $c->stash->{type} = 'Atom';
}

=head2 rss

Just sets the type to RSS

=cut

sub rss : Local {
    my ($self, $c) = @_;
    $c->stash->{type} = 'RSS';
}

=head2 end

this private action pulls out the latest uploaded documents and creates a RSS/Atom feed that gets returned to the client.

=cut

sub end : Private {
    my ($self, $c) = @_;

    my $latest_posts = $c->model('LaoFabDB::Documents')->search({},{
            order_by => 'create_dt DESC',
        })->viewable->slice(0,14);

    my $feed = XML::Feed->new($c->stash->{type});
    $feed->title("LaoFab");
    $feed->link($c->uri_for('/'));
    $feed->description("The latest entries at the LaoFab Document Repository");
    #$feed->author("Joakim Lagerqvist");
    $feed->language("en-US");
    while (my $doc = $latest_posts->next) {
        my $entry = XML::Feed::Entry->new($c->stash->{type});
        $entry->title($doc->title);
        my $body = '<p>Title: '.$doc->title."</p>";
        $body .= '<p>Sub title: '.$doc->sub_title."</p>" if $doc->sub_title;
        $body .= '<p>Pub. year: '.$doc->pubyear."</p>" if $doc->pubyear;
        $body .= '<p>Author(s): '. $doc->long_authors."</p>" if $doc->long_authors;
        #TODO year etc.
        $entry->content($body);
        $entry->issued(DateTime::Format::MySQL->parse_datetime($doc->create_dt));
        $entry->link($c->uri_for('/document/view/'.$doc->id));
        $feed->add_entry($entry);
    }
    $c->res->content_type('application/xml');
    $c->res->body($feed->as_xml);
}


=head1 AUTHOR

Joakim Lagerqvist

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
