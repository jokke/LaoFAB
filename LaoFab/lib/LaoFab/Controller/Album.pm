package LaoFab::Controller::Album;
use strict;
use warnings;
use parent 'Catalyst::Controller';
use JSON::Any;

=head1 NAME

LaoFab::Controller::Folder - Folder Controller for LaoFab

=head1 DESCRIPTION

This controller handles the various actions for the folders such as view, edit etc.

=head1 METHODS

_trim

=cut

=head2 _get_items (private)

Helper method for do_list that returns a array reference of all folders with various properties (recursive)

=cut


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
    my $album_name = $c->req->param("album_name");

    my $album = $c->model('LaoFabDB::Albums')->find({
        name        => $album_name,
        parent_id   => $folder_id,
    });

    if ($album) {
# not unique
        $c->flash->{error} = "This album name already exisis in this folder.";
    } elsif (!length(_trim($album_name))) {
        $c->flash->{error} = "The album must have a name.";
    } else {
        $album = $c->model('LaoFabDB::Albums')->new({
            parent_id => $folder_id,
            name => $album_name,
            create_user => $c->user->id,
        });
        $album->insert;
        $c->flash->{message} = "The folder '$album_name' created.";
    }
    $c->res->redirect($c->uri_for("/folder/view/$folder_id"));
    $c->detach;
}

sub delete : Local {
    my ($self, $c, $album_id) = @_;
    
    my $album = $c->model('LaoFabDB::Albums')->find({id => $album_id});
    
    unless ($album) {
        $c->forward( "/default" ); # require login
        $c->stash->{error} = "The album you requested can not be found, sorry.";
        $c->detach;        
    }
    
    my $parent_id = $album->parent_id()->id;
    
    foreach my $photo ($album->photos) {
        $photo->delete;
    }
    
    $c->flash->{message} = "Album ".$c->req->param("name")." deleted.";
    
    $album->delete;
    
    $c->res->redirect($c->uri_for("/folder/view/$parent_id"));
    $c->detach;
}

sub edit : Local {
    my ($self, $c, $album_id) = @_;
    my $album = $c->model('LaoFabDB::Albums')->find({id => $album_id});
    my ($album_name, $parent_id);

    unless ($album) {
        $c->forward( "/default" ); # require login
        $c->stash->{error} = "The album you requested can not be found, sorry.";
        $c->detach;
    }

    if (defined ($c->req->param("edit"))) {
        # check the values and perhaps continue
        # 1. folder name can not be empty
        # 2. folder name must be unique in that parent
        # 3. parent folder can not be a sub-folder of itself
        if ($self->_check_album_name($c, $album_id) and
            $self->_check_parent_folder($c)) {
            my $parent_id = 0;
            if ($album->parent_id) {
                $parent_id = $album->parent_id->id;
            }
            $album->name($c->req->param("name"));
            if ($album_id != $c->req->param("folder")) {
                $album->parent_id($c->req->param("folder"));
            }
            $album->update;
            $c->flash->{message} = "Album ".$c->req->param("name")." updated.";
            $c->res->redirect($c->uri_for("/folder/view/$parent_id"));
            $c->detach;
        }
    } 
    # do the tree
    my $j = JSON::Any->new;
    my $tree = $c->model('LaoFabDB::Folders')->get_album_tree($album->parent_id->id);

    $c->stash->{tree} = $j->objToJson($tree);
    $c->stash->{jquery} = 1;
    # draw the form with values
    $album_name ||= $album->name;
    $parent_id ||= $album->parent_id->id;
    $c->stash->{album_name} = $album_name;
    $c->stash->{parent_id} = $parent_id;
    $c->stash->{album_id} = $album_id;
}

sub _check_album_name {
    my ($self, $c, $album_id) = @_;
    unless (length($c->req->param("name")) > 0) {
        $c->stash->{error} = "The album must have a name!";
        return 0;
    }
    return 1;
}

sub _check_parent_folder {
    my ($self, $c, $folder_id) = @_;
    
    return 1;
}

sub view : Local {
    my ($self, $c, $album_id) = @_;
    
    my $album = $c->model('LaoFabDB::Albums')->find({
        id => $album_id
    }); 
    unless ($album) { 
        $c->response->status(404);
        $c->stash->{template} = 'not_found.tt2'; 
        $c->detach; 
    }
    
    my $folder_tmp = $album->parent_id; 
    my $location_str = ''; 
    do { 
        $location_str = '<img alt="folder icon" src="' .
            $c->uri_for("/static/images/folder-yellow-open-24x24.png"). '" />' 
            . '&nbsp;<a href="'. 
            $c->uri_for("/folder/view/".$folder_tmp->id).'">'.
            HTML::Entities::encode_entities($folder_tmp->name) . 
            "</a> -&gt; $location_str"; 
    } while (($folder_tmp = $folder_tmp->parent) and $folder_tmp->id); 

    $location_str .= '  <img alt="folder icon" src="' .
                $c->uri_for("/static/images/folder-image-24x24.png"). '" /> '.
                HTML::Entities::encode_entities($album->name); 
    $location_str = '<img alt="folder icon" src="' .
        $c->uri_for("/static/images/folder-yellow-open-24x24.png"). '" />' 
        . ' <a href="'.$c->uri_for("/folder/view/0"). 
		'">Root</a> -&gt;'.$location_str if ($album->parent_id->id); 
    $c->stash->{location_str} = $location_str; 
    
    my $photos = $c->model('LaoFabDB::Photos')->search({
        album => $album->id,
    },{
        order_by => 'create_dt DESC',
    });
    
    my $page = $c->req->param('page');
    $page = 1 if ($page !~ /^\d+$/);


#    my $prs = $c->model('LaoFabDB::Photos')->search({ album => $album->id });
#    my $max_w = $prs->get_column('width')->max;
#    my $max_h = $prs->get_column('height')->max;
#    $c->log->error("height is $max_h and width is $max_w and factor is ". ($max_w / 800));

#    $c->stash->{max_w} = 800;
#    $c->stash->{max_h} = $max_h / ( $max_w / 800 );

    #$photos = $photos->page($page);

    #$c->stash->{pager} = $photos->pager;
    $c->stash->{page} = $page;
    
    $c->stash->{photos} = $photos;
    $c->stash->{album_name} = $album->name;
    $c->stash->{album_id} = $album->id;

}

sub slide : Local {
    my ($self, $c, $album_id, $photo_id) = @_;
    
    my $album = $c->model('LaoFabDB::Albums')->find({
        id => $album_id
    }); 

    
    my $photo = $c->model('LaoFabDB::Photos')->find({
        id => $photo_id,
    });
    
    unless ($album || $photo) { 
        $c->response->status(404);
        $c->stash->{template} = 'not_found.tt2'; 
        $c->detach; 
    }
    
    my $prev_photo = $c->model('LaoFabDB::Photos')->search({
        create_dt => { '<' => $photo->create_dt },
        album     => $album->id,
    },{
        order_by => 'create_dt DESC',
    })->first;
        
    my $next_photo = $c->model('LaoFabDB::Photos')->search({
        create_dt => { '>' => $photo->create_dt },
        album     => $album->id,
    },{
        order_by => 'create_dt ASC',
    })->first;
    
    
    my $downloads = $c->model('LaoFabDB::Downloads')->search({
        photo => $photo->id,
    },{
        prefetch => 'user',
        order_by => ['download_dt desc'],
    })->slice(0,14);

    my $folder_tmp = $album->parent_id; 
    my $location_str = ''; 
    do { 
        $location_str = '<img alt="folder icon" src="' .
            $c->uri_for("/static/images/folder-yellow-open-24x24.png"). '" />' 
            . '&nbsp;<a href="'. 
            $c->uri_for("/folder/view/".$folder_tmp->id).'">'.
            HTML::Entities::encode_entities($folder_tmp->name) . 
            "</a> -&gt; $location_str"; 
    } while (($folder_tmp = $folder_tmp->parent) and $folder_tmp->id); 

    $location_str .= '  <img alt="folder icon" src="' .
                $c->uri_for("/static/images/folder-image-24x24.png"). '" /> '.
                '<a href="'.$c->uri_for("/album/view/".$album->id). 
                '">'.HTML::Entities::encode_entities($album->name).'</a>'; 
    $location_str = '<img alt="folder icon" src="' .
        $c->uri_for("/static/images/folder-yellow-open-24x24.png"). '" />' 
        . ' <a href="'.$c->uri_for("/folder/view/0"). 
		'">Root</a> -&gt;'.$location_str if ($album->parent_id->id); 
    $c->stash->{location_str} = $location_str; 

    $c->stash->{downloads} = $downloads;
    $c->stash->{prev_photo} = $prev_photo;
    $c->stash->{next_photo} = $next_photo;
    $c->stash->{photo} = $photo;
    $c->stash->{album_name} = $album->name;
    $c->stash->{album_id} = $album->id;
}

1;
