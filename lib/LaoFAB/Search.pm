package LaoFAB::Search;
use Dancer ':syntax';
use Dancer::Plugin::FlashMessage;

use Data::Dumper;
use REST::Client;

our $VERSION = '3.1';

prefix '/search';

get '/' => sub {
	my @results;
	if (params->{'q'}) {
		my $q = params->{'q'};
		debug params->{'q'};
		my $headers = {Accept => 'application/json'};

		my $client = REST::Client->new;
		$client->setHost('http://localhost:8080');
		my $query = $client->buildQuery(
            fl => 'doc_title,id,score',
            hl => 'true',
            sort => 'score desc',
            'hl.fl' => 'attr_content,doc_title,doc_sub_title,doc_subcat',
            wt => 'json',
            q => "attr_content:$q doc_title:$q^2",
		);
		$client->GET(
		    '/solr/select/' . $query, $headers 
		);
		my $response = from_json($client->responseContent());


		foreach my $doc (@{$response->{response}->{docs}}) {
			next unless $doc->{id};
			my $entry;
			$entry->{id} = $doc->{id};
		    $entry->{title} = $doc->{doc_title};
			$entry->{highlights} = join '<br/>', 
				map { 
					join '<br/>', @{$response->{highlighting}->{$doc->{id}}->{$_}} 
				} keys %{$response->{highlighting}->{$doc->{id}}};
			push @results, $entry;
		}
	}
	debug Dumper(\@results);
	template 'search/index', { 'results' => \@results};
};

true;
