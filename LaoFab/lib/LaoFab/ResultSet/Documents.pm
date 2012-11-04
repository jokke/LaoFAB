package LaoFab::ResultSet::Documents;
use strict;
use warnings;
use base qw/
			DBIx::Class::ResultSet
			/;
			
sub viewable {
	my $self = shift;
	$self->search({
		viewable => 1
	});
}

sub order {
    my $self = shift;
    my $order = shift;
    my $direction = shift;
    
    my $order_by = "$order $direction";
    
    if ($order eq 'authors.name') {
        $order_by = "(case when length(authors.name) = 0 and length(authors.org) =0 then 'ZZZZZZZ' when length(authors.name) = 0 and length(authors.org) > 0 then authors.org else authors.name end) $direction";
    }
    
    $self->search({
        viewable => 1,
    },{
        join => [ qw/ authors doctype /],
        order_by => $order_by,
        group_by => 'document.id',
    });
}
1;