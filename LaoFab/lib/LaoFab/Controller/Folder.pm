package LaoFab::Controller::Folder;
use strict;
use warnings;
use parent 'Catalyst::Controller';

use JSON::Any;

=head1 NAME

LaoFab::Controller::Folder - Folder Controller for LaoFab

=head1 DESCRIPTION

This controller handles the various actions for the folders such as view, edit etc.

=head1 METHODS

view
do_list
delete
edit
add
_get_items
_check_folder_name
_check_parent_folder
_trim

=cut

=head2 _get_items (private)

Helper method for do_list that returns a array reference of all folders with various properties (recursive)

=cut

sub _get_items {
    my ($self, $c, $folder_id, $selected, $disabled) = @_;
    my $items = [];
    my $sub_folders = $c->model('LaoFabDB::Folders')->search({
            parent => $folder_id,
        },{
            order_by => 'name',
        });
    while (my $sub = $sub_folders->next) {
        my $checked = 'false';
        my $sub_disabled = $disabled;
        $checked = 'true' if grep {$sub->id eq $_} @$selected;
        $sub_disabled = 'true' if ($checked eq 'true' and $sub_disabled != -1);
        my $item = {
            value => $sub->id,
            description => $sub->name,
            checked => $checked,
            disabled => $disabled,
            expand   => $checked,
            children => $self->_get_items($c, $sub->id, $selected, $sub_disabled),
        };
        foreach my $child (@{$item->{children}}) {
            if ($child->{expand} eq 'true') {
                $c->log->info($child->{description} . "is true");
                $item->{expand} = 'true';
            }
        }
        push @$items, $item;
    }
    return $items;
}

=head2 _get_items (private)

action to get a complete folder listing in JSON format that is used to build dojo trees with check boxes and radio buttons.

The JSON will contain which folders should be checked, expanded and so on

=cut

sub do_list : Local {
    my ($self, $c, $s) = @_;
    my @selected;
    my $checked = 'false';
    my $radio_en = 'false';

    if (defined $c->req->param("fid")) {
        @selected = $c->req->param("fid");
        $radio_en = -1;
    } elsif (defined $s) {
        @selected = ( $s );
    }
    
    $checked = 'true' if grep {"0" eq $_} @selected;
    my $ret = {
        identifier => 'value', #'name',
        label => 'description',
    };

    my $item = {
            value => 0,
            description => 'Root folder',
            checked => $checked,
            expand   => $checked,
            children => $self->_get_items($c, 0, \@selected, $radio_en),
    };
    foreach my $child (@{$item->{children}}) {
        if ($child->{expand} eq 'true') {
            $c->log->info($child->{description} . "is true");
            $item->{expand} = 'true';
        }
    }

    $ret->{items} = [ $item ];
    $c->stash->{json} = $ret;
    $c->forward('LaoFab::View::JSON');
}


=head2 view

action to view a folder, prepares the stash with information, such as containing files etc. 

=cut

sub view : Local {
    my ($self, $c, $folderid) = @_;
    my $order = $c->req->param('order') || $c->session->{order} || 'name';
    my $direction = $c->req->param('direction') || $c->session->{direction} || 'asc';
    
    $c->session->{order} = $order;
    $c->stash->{order} = $order;
    
    $c->session->{direction} = $direction;
    $c->stash->{direction} = $direction;
    
    $folderid = 0 unless ($folderid);
    $c->stash->{folder_id} = $folderid;
    $c->stash->{folder_parent} = 0;
    my $folder_icon = '<img alt="folder icon" src="'.
            $c->uri_for("/static/images/folder-yellow-open-24x24.png").
            '" />';

	my $folder = $c->model('LaoFabDB::Folders')->find({
		id => $folderid
	}); 
	unless ($folder) { 
		$c->response->status(404);
		$c->stash->{template} = 'not_found.tt2'; 
		$c->detach; 
	}
	my $doc_order = 'title';
	if ($order eq 'author') {
	    $doc_order = 'authors.name'
	} elsif ($order eq 'type') {
	    $doc_order = 'doctype.name'
	} elsif ($order eq 'year') {
	    $doc_order = 'pubyear';
	} elsif ($order eq 'size') {
	    $doc_order = 'filesize';
	} elsif ($order eq 'date') {
	    $doc_order = 'create_dt';
	}
	$c->stash->{documents} = $folder->documents->order($doc_order, $direction);
	$c->stash->{folder_name} = $folder->name;

	my $folder_tmp = $folder; 
	my $location_str = ''; 
	do { 
		if (length($location_str)) { 
			$location_str = $folder_icon . '&nbsp;<a href="'. 
				$c->uri_for("/folder/view/".$folder_tmp->id).'">'.
				HTML::Entities::encode_entities($folder_tmp->name) . 
				"</a> -> $location_str"; 
		} else { 
			$location_str = $folder_icon . 
				HTML::Entities::encode_entities($folder_tmp->name); 
		} 
	} while (($folder_tmp = $folder_tmp->parent) and $folder_tmp->id); 
	
	$location_str = $folder_icon . '<a href="'.$c->uri_for("/folder/view/0"). 
		'">Root</a> ->'.$location_str if ($folderid); 
	$c->stash->{location_str} = $location_str; 
	if ($folder->parent) { 
		$c->stash->{folder_parent} = $folder->parent->id; 
	}
	my $folder_order = 'name';
	if ($order eq 'date') {
	    $folder_order = 'create_dt';
	}
    my $folders = $c->model('LaoFabDB::Folders')->search({
        parent => $folderid,
    },{
        order_by => "$folder_order $direction",
    });
    my $albums = $c->model('LaoFabDB::Albums')->search({
        parent_id => $folderid,
    },{
        order_by => "$folder_order $direction",
    });
#    $c->log->info("no: ".$c->model('LaoFabDB')->files_in_album($albums->next));
    $c->stash->{albums} = $albums;
    $c->stash->{folders} = $folders;
    $c->stash->{admin} = 1;
}


=head2 _check_folder_name

helper method for add and edit to check if the given name is valid.

=cut

sub _check_folder_name {
    my ($self, $c, $folder_id) = @_;
    unless (length($c->req->param("name")) > 0) {
        $c->stash->{error} = "The folder must have a name!";
        return 0;
    }
    return 1;
}


=head2 _check_parent_folder

Helper method for edit that checks so that a folder is not moved to a subfolder of it selves.

=cut

sub _check_parent_folder {
    my ($self, $c, $folder_id) = @_;
    
    return 1;
}


=head2 edit

Action to edit a folder, move it to another parent and/or change the name

=cut

sub edit : Local {
    my ($self, $c, $folder_id) = @_;
    my $folder = $c->model('LaoFabDB::Folders')->find({id => $folder_id});
    my ($folder_name, $parent_id);

    unless ($folder) {
        $c->forward( "/default" ); # require login
        $c->stash->{error} = "The folder you requested can not be found, sorry.";
        $c->detach;
    }

    if (defined ($c->req->param("edit"))) {
        # check the values and perhaps continue
        # 1. folder name can not be empty
        # 2. folder name must be unique in that parent
        # 3. parent folder can not be a sub-folder of itself
        if ($self->_check_folder_name($c, $folder_id) and
            $self->_check_parent_folder($c)) {
            my $parent_id = 0;
            if ($folder->parent) {
                $parent_id = $folder->parent->id;
            }
            $folder->name($c->req->param("name"));
            if ($folder_id != $c->req->param("folder")) {
                $folder->parent($c->req->param("folder"));
            }
            $folder->update;
            $c->flash->{message} = "Folder ".$c->req->param("name")." updated.";
            $c->res->redirect($c->uri_for("/folder/view/$parent_id"));
            $c->detach;
        }
    } 
    # do the tree
    my $j = JSON::Any->new;
    my $tree = $c->model('LaoFabDB::Folders')->get_radio_tree($folder->id);

    $c->stash->{tree} = $j->objToJson($tree);
    $c->stash->{jquery} = 1;
    # draw the form with values
    $folder_name ||= $folder->name;
    $parent_id ||= $folder->parent;
    $c->stash->{folder_name} = $folder_name;
    $c->stash->{parent_id} = $parent_id;
    $c->stash->{folder_id} = $folder_id;
}

=head2 delete

action to delete a folder...

=cut

sub delete : Local {
    my ($self, $c, $folder_id) = @_;

    my $folder = $c->model('LaoFabDB::Folders')->find({id => $folder_id});
    my $parent_id = 0;
    if ($folder) {
        $c->flash->{message} = 'Deleted the folder ' . 
             HTML::Entities::encode_entities($folder->name);
        $parent_id = $folder->parent->id if ($folder->parent);
        $folder->delete;
    } else {
        $c->flash->{message} = 'No such folder to delete...';
    }
    $c->res->redirect($c->uri_for("/folder/view/$parent_id"));
    $c->detach;
}


=head2 _trim

Just a sub for trimming spaces

=cut

sub _trim {
    my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
    return $string;
}


=head2 add

action for add a folder, needs a param for name and id of folder to be inside.

=cut

sub add : Local {
    my ($self, $c) = @_;

    my $folder_id = $c->req->param("folder_id") || 0;
    my $folder_name = $c->req->param("folder_name");

    my $folder = $c->model('LaoFabDB::Folders')->find({
        name   => $folder_name,
        parent => $folder_id,
    });

    if ($folder) {
# not unique
        $c->flash->{error} = "This name already exisis in this folder.";
    } elsif (!length(_trim($folder_name))) {
        $c->flash->{error} = "The folder must have a name.";
    } else {
        $folder = $c->model('LaoFabDB::Folders')->new({
            parent => $folder_id,
            name => $folder_name,
            create_user => $c->user->id,
        });
#        $folder->parent($folder_id);
#        $folder->name($folder_name);
#        $folder->create_user($c->user->id);
        $folder->insert;
        $c->flash->{message} = "The folder '$folder_name' created.";
    }
    $c->res->redirect($c->uri_for("/folder/view/$folder_id"));
    $c->detach;
}

1;
