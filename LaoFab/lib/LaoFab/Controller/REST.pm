package LaoFab::Controller::REST;

use strict;
use warnings;
use parent 'Catalyst::Controller::REST';
use Data::Dumper;
use utf8;
use Encode;


__PACKAGE__->config(
    # Set the default serialization to JSON
    'default' => 'JSON',
    'map' => {
        # Remap x-www-form-urlencoded to use JSON for serialization
        'application/x-www-form-urlencoded' => 'JSON',
        'text/plain' => 'JSON',
    },
);
#__PACKAGE__->config->{serialize}{default} = 'JSON';
=head1 NAME

LaoFab::Controller::REST - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

org
org_GET
mk_org_entity
author
author_GET
mk_author_entity
rating
rating_POST
mk_rating_entity

=cut


=head2 location

=cut

sub solr : Local : ActionClass('REST') {
    my ( $self, $c) = @_;
}

sub solr_POST {
	my ($self, $c) = @_;
	

    my $q = $c->req->param('query');
    $q =~ tr/\+/ /;
    $q =~ s/\%([A-Fa-f0-9]{2})/pack('C', hex($1))/eg;
    my %req;
    for my $field (split /&/, $q) {
        my ($key, $val) = split /=/, $field;
        if ($req{$key} and ref $req{$key} eq 'ARRAY') {
            push @{$req{$key}}, $val;
        } elsif ($req{$key}) {
            $req{$key} = [ $req{$key}, $val ];
        } else {
            $req{$key} = $val;
        }
    }

    my $options;
    $options->{fq} = $req{fq} if $req{fq};
    $options->{'facet.field'} = $req{'facet.field'} if $req{'facet.field'};
    $options->{'facet'} = $req{'facet'} if $req{'facet'};
    $options->{'facet.limit'} = $req{'facet.limit'} if $req{'facet.limit'};
    $options->{'facet.mincount'} = $req{'facet.mincount'} if $req{'facet.mincount'};
    $options->{'f.topics.facet.limit'} = $req{'f.topics.facet.limit'} if $req{'f.topics.facet.limit'};
    $options->{'json.nl'} = $req{'json.nl'} if $req{'json.nl'};
    $options->{'df'} = $req{'df'} if $req{'df'};
    $options->{'start'} = $req{'start'} if $req{'start'};
    $options->{'sort'} = $req{'sort'} if $req{'sort'};
    
#highlight
    $options->{'hl'} = 'true';
    $options->{'hl.simple.pre'} = '<span class="highlight">';
    $options->{'hl.simple.post'} = '</span>';
    $options->{'hl.fragsize'} = 300;

# limit fields
    $options->{'fl'} = 'id,folder,author,title,subcat,preview,keyword,doctype,pubyear,sub_title';

#sort
    $options->{'sort'} = 'id desc' unless defined $options->{'sort'};
    
    my $response = $c->model('Solr')->search( $req{'q'}, $options);
# need to make it utf8
	$self->status_ok($c, entity => $response->content );
}

sub location : Local : ActionClass('REST') {
    my ( $self, $c, $id) = @_;
	$c->stash->{id} = $id;
}

sub location_GET {
	my ($self, $c) = @_;
	
	eval {
		my $location = $c->model('LaoFabDB::Locations')->find({
			id => $c->stash->{id},
		});
						
		$self->status_ok($c,
			entity => { 
                polygon => [ $location->pairs_polygon ],# '(' . join (')(', $location->google_polygon) . ')' }
                color   => '#' . $location->color,
            }
		);
	};
	if ($@) {
		$self->status_bad_request($c,
			message => "Invalid data supplied: $@");
	}
}

=head2 keywords

=cut

sub keywords : Local : ActionClass('REST') {
    my ( $self, $c, $start_char) = @_;
    if (not $start_char and $c->req->param('query')) {
        $start_char = $c->req->param('query');
    }
	$c->stash->{start_char} = $start_char;
}

sub keywords_GET {
	my ($self, $c) = @_;
	
	eval {
		my $words = $c->model('LaoFabDB::Keywords')->search({
			word => {
				-like => $c->stash->{start_char}.'%',
			}
		},{
			select => [
				{ distinct => 'word', },
			],
			as => 'word',
			order_by => "word asc",
			group_by => 'word',
		})->slice(0,9);
						
		$self->status_ok($c,
			entity => {
                query => $c->stash->{start_char},
                suggestions => mk_keywords_entity($c, $words),
            }
			#location => $c->uri_for('/rest/author_name/'.$c->stash->{start_char})
		);
	};
	if ($@) {
		$self->status_bad_request($c,
			message => "Invalid data supplied: $@");
	}
}

sub mk_keywords_entity {
	my $c = shift;
	my $words = shift;
	
	my @values;
	
	while (my $word = $words->next) {
		push @values, $word->word; #{ id => 'id', label => 'label', value => $word->word };
	}
	
	return \@values;;
}

=head2 org

REST action for organisation auto complete for adding and editing documents, returns a list of possible organisations. Using org_GET for GET requests which in turn uses mk_org_entity to create the JSON.

=cut

sub org : Local : ActionClass('REST') {
    my ( $self, $c, $start_char) = @_;
    if (not $start_char and $c->req->param('query')) {
        $start_char = $c->req->param('query');
    }
	$c->stash->{start_char} = $start_char;
}

sub org_GET {
	my ($self, $c) = @_;
	
	eval {
		my $orgs = $c->model('LaoFabDB::Authors')->search({
			org => {
				-like => $c->stash->{start_char}.'%',
			}
		},{
			select => [
				{ distinct => 'org', },
			],
			as => 'org',
			order_by => "org asc",
			group_by => 'org',
		})->slice(0,9);
						
		$self->status_ok($c,
			entity => {
                query => $c->stash->{start_char},
                suggestions => mk_org_entity($c, $orgs),
            }
			#location => $c->uri_for('/rest/author_name/'.$c->stash->{start_char})
		);
	};
	if ($@) {
		$self->status_bad_request($c,
			message => "Invalid data supplied: $@");
	}
}

sub mk_org_entity {
	my $c = shift;
	my $orgs = shift;
	
	my @names;
	
	while (my $org = $orgs->next) {
		push @names, $org->org; #{ name => $org->org };
	}

    return \@names;
#	return { 
#		label => 'name',
#		items => \@names,
#	};
}

=head2 laofind

REST action for author name auto complete for adding and editing documents, returns a list of possible author names. Using author_GET for GET requests which in turn uses mk_author_entity to create the JSON.

=cut

sub laofind : Local : ActionClass('REST') {
    my ( $self, $c ) = @_;
	$c->stash->{query} = $c->req->param('q');
}

sub mk_hits_laofind {
    my $documents = shift;
    my $hits = shift;
    my $value = shift;
    
    while (my $doc = $documents->next) {
        $$hits->{$doc->id}->{value} += $value;
        $$hits->{$doc->id}->{title} = $doc->title;
        $$hits->{$doc->id}->{sub_title} = $doc->sub_title;
        $$hits->{$doc->id}->{url} = "/document/view/".$doc->id;
        $$hits->{$doc->id}->{authors} = $doc->long_authors;
        $$hits->{$doc->id}->{keywords} = join (", ", map { $_->word } $doc->keywords);
        $$hits->{$doc->id}->{type} = $doc->doctype->name;
        $$hits->{$doc->id}->{loggin} = 1;
    }
}

sub laofind_GET {
	my ($self, $c) = @_;
	
	eval {
        #search
        my $hits;
        my @tokens = split /\s+/, $c->stash->{query};
        for (@tokens) {
            my $documents = $c->model('LaoFabDB::Documents')->search({
                title => { 
                        -like => "%$_%"
                    }
            });
            mk_hits_laofind($documents, \$hits, 3);
            $documents = $c->model('LaoFabDB::Documents')->search({
                sub_title => {
                    -like => "%$_%"
                }
            });
            mk_hits_laofind($documents, \$hits, 2);
            $documents = $c->model('LaoFabDB::Documents')->search({
                'authors.name' => { -like => "%$_%" }
                },{
                    join => 'authors',
                }
            );
            mk_hits_laofind($documents, \$hits, 2);
            $documents = $c->model('LaoFabDB::Documents')->search({
                'authors.org' => { -like => "%$_%" }
                },{
                    join => 'authors',
                }
            );
            mk_hits_laofind($documents, \$hits, 2);
            $documents = $c->model('LaoFabDB::Documents')->search({
                'keywords.word' => { -like => "%$_%" }
                },{
                    join => 'keywords',
                }
            );
            mk_hits_laofind($documents, \$hits, 1);
        }
        
        my @hit_array = map { $hits->{$_} } keys %{$hits};
        $self->status_ok($c, entity => \@hit_array);
	};
	if ($@) {
		$self->status_bad_request($c,
			message => "Invalid data supplied: $@");
	}
}

=head2 author

REST action for author name auto complete for adding and editing documents, returns a list of possible author names. Using author_GET for GET requests which in turn uses mk_author_entity to create the JSON.

=cut

sub author : Local : ActionClass('REST') {
    my ( $self, $c, $start_char) = @_;
    if (not $start_char and $c->req->param('query')) {
        $start_char = $c->req->param('query');
    }
	$c->stash->{start_char} = $start_char;
}

sub author_GET {
	my ($self, $c) = @_;
	
	eval {
		my $authors = $c->model('LaoFabDB::Authors')->search({
			name => {
				-like => $c->stash->{start_char}.'%',
			}
		},{
			select => [
				{ distinct => 'name', },
			],
			as => 'name',
			order_by => "name asc",
			group_by => 'name',
		})->slice(0,9);
						
		$self->status_ok($c,
			entity => {
                query => $c->stash->{start_char},
                suggestions => mk_author_entity($c, $authors),
            }
			#entity => mk_author_entity($c, $authors)
			#location => $c->uri_for('/rest/author_name/'.$c->stash->{start_char})
		);
	};
	if ($@) {
		$self->status_bad_request($c,
			message => "Invalid data supplied: $@");
	}
}

sub mk_author_entity {
	my $c = shift;
	my $authors = shift;
	
	my @names;
	
	while (my $author = $authors->next) {
		push @names, $author->name; #{ name => $author->name };
	}
    return \@names;	
#	return { 
#		label => 'name',
#		items => \@names,
#	};
}


=head2 rating

REST action for recieving ratings from the /document/view/XX, takes a rating and document id and user id, returns the avg. rating, number of ratings and the users registered rating. For this it is using rating_POST and mk_rating_entity.

=cut

sub rating : Local : ActionClass('REST') {
    my ( $self, $c, $doc_id, $user_id ) = @_;
    $c->stash->{doc_id} = $doc_id;
    $c->stash->{user_id} = $user_id;
}

sub rating_POST {
    my ( $self, $c ) = @_;

    eval {
        my $user = $c->model('LaoFabDB::User')->find({ id => $c->stash->{user_id}});
        my $document = $c->model('LaoFabDB::Documents')->find({ id => $c->stash->{doc_id}});
        my $comment = $c->model('LaoFabDB::Comments')->find_or_new({
            document => $document,
            user     => $user,
        });
        $comment->rating($c->req->param("rating"));

        $comment->update_or_insert;

        $self->status_created($c, 
            entity   => mk_rating_entity($c, $comment),
            location => $c->uri_for('/rest/rating/'.$c->stash->{doc_id}.'/'.$c->stash->{user_id}),
            );
    };
    if ($@) {
        $self->status_bad_request($c, 
            message => "Invalid data supplied: $@");
    }
    #$c->stash->{json} = $ret;
    #$c->forward('LaoFab::View::JSON');    
}

sub mk_rating_entity {
    my $c = shift;
    my $comment = shift;
    my $rating_count = 0;
    my $avg_rating = 0;

    my $comments = $c->model('DB::Comments')->search({
        document => $comment->document->id,
    });

    $rating_count = $comments->count if $comments;

    while (my $com = $comments->next) {
        $avg_rating += $com->rating;
    }

    $avg_rating = $avg_rating/$rating_count if $rating_count;

    return {
             rating_mine  => $comment->rating,
             rating_count => $rating_count,
             rating_avg   => sprintf("%.1f", $avg_rating),
    };
}


=head1 AUTHOR

Joakim Lagerqvist

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
