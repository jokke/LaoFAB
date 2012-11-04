package LaoFab::Controller::Search;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Data::Dumper;

=head1 NAME

LaoFab::Controller::Search - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

search

=cut


=head2 search

Global action to handle search queries. If a query is supplied, it will return a result ordered by relevance (from the tags table) and store the search words in the database for statistical reasons. In this case, it will use the result template. If no query is supplied, the default template search.tt2 will be used with a search form.

=cut

sub search : Global {
    my ( $self, $c, $query ) = @_;
    
    $query ||= $c->req->param('s') 
        if (defined ($c->req->param('s')));

    unless ($query) {
		my @subcats_obj = $c->model("LaoFabDB::Subcats")->all();
	    @subcats_obj = sort {$a->main_cat cmp $b->main_cat} @subcats_obj;
	    $c->stash->{subcats} = \@subcats_obj;

	    my @doctypes_obj = $c->model("LaoFabDB::Doctypes")->all();
	    @doctypes_obj = sort {$a->id <=> $b->id} @doctypes_obj;
	    $c->stash->{doctypes} = \@doctypes_obj;
		return;
	}

    $c->stash->{query} = $query;

    my @tokens;
    my @tmp_tokens = split /\s+/, $query;
    my @ignore_words = qw/ i a am the in is are you me we and an for from not at be by do go if in no of ok on or so to up us/;
    
    my $total_docs = $c->model('LaoFabDB::Documents')->search({})->count;
    
    foreach my $word (@tmp_tokens) {
        next if grep {lc($word) eq $_} @ignore_words;
        my $number_of_docs = $c->model('LaoFabDB::Tags')->search({
            tag => { -like => lc($word)."%" },
        },{
            group_by => 'me.document',
        })->count;
        if (($number_of_docs/$total_docs) > 0.1) { 
            $c->stash->{error} .= '<br/>The search word <em>'.$word.'</em> generates many hits, consider refrase your search query. ';
        }
        
        push @tokens, $word;
    }
    
    my @test_words;
    push @test_words, (map +{'tag' => {-like => "%$_%"}}, @tokens);
     
    my $exact_match = $c->model('LaoFabDB::Tags')->search({
        -and => \@test_words,
    },{
        group_by => [qw/ me.document /],
    })->count;
    
    unless ($exact_match) {
#        $c->stash->{error} .= '<br/>No document found containing all your search words: <em>'.(join ", ", @tokens)."</em>. Consider refrasing your search query.";
    }
	
    my $user = $c->model('LaoFabDB::User')->find({ id => $c->user->id });
    if ($user and ($c->req->param('b') eq 'search' or $c->req->param('b') eq 'go') 
			and not $c->req->param('page')) {
			    
		
        foreach my $word (@tokens) {
            next if grep {lc($word) eq $_} @ignore_words;
            $c->model('LaoFabDB::Phrases')->create({ 
                word => $word,
                user => $user,
            });
        }
    }

    my @free_words;
    push @free_words, (map +{'tag' => {-like => "%$_%"}}, @tokens);

	my $ands = [
		-or => \@free_words,
		'document.viewable' => 1,
	];

	if ($c->req->param('d') && $c->req->param('d') > 0) {
		push @$ands, +{'document.doctype' => $c->req->param('d')};
	}
	
	my @fields;
		
	if ($c->req->param('f')) {
		foreach my $field ($c->req->param('f')) {
			if ($field eq 't') {
				push @fields, (map +{'document.title' => {-like => "%$_%"}}, @tokens);
			} elsif ($field eq 'a') {
				push @fields, (map +{'authors.name' => {-like => "%$_%"}}, @tokens);
			} elsif ($field eq 'o') {
				push @fields, (map +{'authors.org' => {-like => "%$_%"}}, @tokens);
			} elsif ($field eq 'k') {
				push @fields, (map +{'keywords.word' => {-like => "%$_%"}}, @tokens);
			}
		}
	}
	
	my @subcats;
	
	if ($c->req->param('c') && !($c->req->param('ca') && $c->req->param('ca') eq 'ca')) {
		foreach my $c ($c->req->param('c')) {
			push @subcats, {'document_subcat.subcat' => $c };
		}
	}
	push @$ands, [ -or => \@fields ] if scalar(@fields);
	push @$ands, [ -or => \@subcats ] if scalar(@subcats);
	
	my $result = $c->model('LaoFabDB::Tags')->search({
            -and => $ands,
        },{
            join => { 'document' => [qw/authors keywords document_subcat/] },#'authors' },#[qw/ document authors /],
            select => [ 'me.document', { sum => 'weight' }],
            as => [qw/ document weight /],
            group_by => [qw/ me.document /],
            order_by => ['sum(weight) desc'],
        });

    my $page = $c->req->param('page');
    $page = 1 if ($page !~ /^\d+$/);
    $result = $result->page($page);

    $c->stash->{results} = $result;
    $c->stash->{pager} = $result->pager;
    $c->stash->{page} = $page;

    $c->stash->{template} = 'search/result.tt2';
}


=head1 AUTHOR

Joakim Lagerqvist

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
