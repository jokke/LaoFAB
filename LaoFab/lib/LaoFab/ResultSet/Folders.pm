package LaoFab::ResultSet::Folders;
use strict;
use warnings;
use base qw/
			DBIx::Class::ResultSet
			/;

sub get_radio_tree {
    my ($self, $selected) = @_;
    my @res;
    my $rs = $self->search( {parent => undef},
                            {order_by => [ 'name' ] },
                         );
    while (my $node =  $rs->next) {
        push @res, $self->get_radio_children($node, $selected);
    }
    return \@res;
}

sub get_radio_children {
    my ($self, $node, $selected) = @_;
    my $res = {};
    
    $res->{title} = $node->name ;
    $res->{key} = $node->id;
    $res->{isFolder} = 1;
    my @kids = $node->folders;
    if ($node->id == $selected) {
        $res->{select} = 1;
        return $res;
    }
    if (@kids) {
        my @children;
        foreach (@kids) {
            push @children, $self->get_radio_children($_, $selected);
            $res->{expand} = 1 if grep {$_->{select} or $_->{expand}} @children;
        }
        $res->{children} = \@children;
    }
    return $res;
}

sub get_album_tree {
    my ($self, $selected) = @_;
    my @res;
    my $rs = $self->search( {parent => undef},
                            {order_by => [ 'name' ] },
                         );
    while (my $node =  $rs->next) {
        push @res, $self->get_album_children($node, $selected);
    }
    return \@res;
}

sub get_album_children {
    my ($self, $node, $selected) = @_;
    my $res = {};
    
    $res->{title} = $node->name ;
    $res->{key} = $node->id;
    $res->{isFolder} = 1;
    my @kids = $node->folders;
    if ($node->id == $selected) {
        $res->{select} = 1;
    }
    if (@kids) {
        my @children;
        foreach (@kids) {
            push @children, $self->get_album_children($_, $selected);
            $res->{expand} = 1 if grep {$_->{select} or $_->{expand}} @children;
        }
        $res->{children} = \@children;
    }
    return $res;
}

sub get_check_tree {
    my ($self, $selected) = @_;
    my @res;
    my $rs = $self->search( {parent => undef},
                            {order_by => [ 'name' ] },
                         );
    while (my $node =  $rs->next) {
        push @res, $self->get_check_children($node, $selected);
    }
    return \@res;
}

sub get_check_children {
    my ($self, $node, $selected) = @_;
    my $res = {};
    
    $res->{title} = $node->name ;
    $res->{key} = $node->id;
    $res->{isFolder} = 1;
    my @kids = $node->folders;
    if (grep {$_ == $node->id} @$selected) {
        $res->{select} = 1;
    }
    if (@kids) {
        my @children;
        foreach (@kids) {
            push @children, $self->get_check_children($_, $selected);
            $res->{expand} = 1 if grep {$_->{select} or $_->{expand}} @children;
        }
        $res->{children} = \@children;
    }
    return $res;
}
1;
