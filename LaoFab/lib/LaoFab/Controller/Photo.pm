package LaoFab::Controller::Photo;
use strict;
use warnings;
use parent 'Catalyst::Controller';
use MIME::Types;
use File::MimeInfo ();
use Catalyst::Request::Upload;
use Imager;
use File::Temp qw/ tempfile /;

# use Date::Format;
# use DateTime;

__PACKAGE__->mk_accessors(qw(thumbnail_size));

=head2 get_photos

set up photo stash

=cut

sub get_photos : Chained('/') PathPart('photo') CaptureArgs(1) {
    my ( $self, $c, $photo_id ) = @_;

    my $photo = $c->model('LaoFabDB::Photos')->find($photo_id);

    unless ( $photo ) {
        $c->stash->{error} = "No such photo.";
    } else {
        $c->stash->{photo} = $photo;
    }
}

=head2 get_original

this method returns the originale of a given image

=cut

sub get_original : Chained('get_photos') PathPart('original') Args(0) {
    my ( $self, $c ) = @_;

    my $photo = $c->stash->{photo};

    my $mimeinfo = File::MimeInfo->new;
    my $extension;
    if ($photo->mime =~ /\/(.+)$/) {
        $extension = $1;
    }

    my $out = $photo->file->open('r');
    $c->res->content_type( $photo->mime );
    $c->res->content_length( -s $out );
    $c->res->header( "Content-Disposition" => "inline; filename=laofab_photo_original_".$photo->id .".". $extension);# 
    
    binmode $out;
    $c->res->body($out);
}

=head2 generate_thumbnail

this method generates a thumbnail of a given image

=cut

sub generate_thumbnail : Chained('get_photos') PathPart('thumbnail') Args(0) {
    my ( $self, $c ) = @_;

    my $photo = $c->stash->{photo};

    my $mimeinfo = File::MimeInfo->new;
    my $out;
    my $extension;
    if ($photo->mime =~ /\/(.+)$/) {
        $extension = $1;
    }

    unless ($photo->thumbnail) {
        my $data = $photo->file->open('r') or die "Error: $!";
        my $img = Imager->new;
        $img->read( fh => $data ) or die $img->errstr;
        my $scaled = $img->scale(xpixels=>150,ypixels=>150,type=>'min');

        $scaled->write(
            type => $extension,
            data => \$out,
        ) or die $scaled->errstr;
        
        my ($fh, $filename) = tempfile();

        $scaled->write(file=>$filename, type=>$extension) or die $scaled->errstr;
        $photo->thumbnail($fh);
        $photo->update;
    } else {
        $out = $photo->thumbnail->open('r');
    }
    $c->res->content_type( $photo->mime );
    $c->res->content_length( -s $out );
    $c->res->header( "Content-Disposition" => "inline; filename=laofab_photo_thumbnail_".$photo->id .".". $extension);# 
    
    binmode $out;
    $c->res->body($out);
}

=head2 generate_normal

this method generates a scaled version of a given image

=cut

sub generate_normal : Chained('get_photos') PathPart('normal') Args(0) {
    my ( $self, $c ) = @_;

    my $photo = $c->stash->{photo};

    my $mimeinfo = File::MimeInfo->new;
    my $out;
    my $extension;
    if ($photo->mime =~ /\/(.+)$/) {
        $extension = $1;
    }

    unless ($photo->normal) {
        my $data = $photo->file->open('r') or die "Error: $!";
        my $img = Imager->new;
        $img->read( fh => $data ) or die $img->errstr;
        my $scaled = $img->scale(xpixels=>800,type=>'min');

        $scaled->write(
            type => $extension,
            data => \$out,
        ) or die $scaled->errstr;

        my ($fh, $filename) = tempfile();

        $scaled->write(file=>$filename, type=>$extension) or die $scaled->errstr;
        $photo->normal($fh);
        $photo->update;
    } else {    
        $out = $photo->normal->open('r');
    }
    $c->res->content_type( $photo->mime );
    $c->res->content_length( -s $out );
    $c->res->header( "Content-Disposition" => "inline; filename=laofab_photo_800size_".$photo->id .".". $extension);# 
    
    binmode $out;
    $c->res->body($out);
}

=head2 generate_normal

this method generates a scaled version of a given image

=cut

sub download : Local {
    my ( $self, $c, $photo_id ) = @_;

    my $photo = $c->model('LaoFabDB::Photos')->find({
        id => $photo_id,
    });
    
    unless ($photo)  { 
        $c->response->status(404);
        $c->stash->{template} = 'not_found.tt2'; 
        $c->stash->{error} = "Could not find photo with id: $photo_id". "!";
        $c->detach; 
    }

    
    my $user = $c->model('LaoFabDB::User')->find({id => $c->user->id });
    $c->model('LaoFabDB::Downloads')->create({
        user     => $user,
        photo    => $photo,
    }) if $user;
    
    my $extension;
    if ($photo->mime =~ /\/(.+)$/) {
        $extension = $1;
    }
    
    $c->response->header('Content-Type' => $photo->mime);
    $c->response->header('Content-Disposition' => 'attachment; filename=laofab_photo_'.$photo->id . '.' .$extension);
    my $out = $photo->file->open('r');
    binmode($out);
    $c->response->body($out);
}

sub delete : Local {
    my ($self, $c, $photo_id) = @_;
    my $from = $c->req->param("from");
    my $photo = $c->model("LaoFabDB::Photos")->find({ id => $photo_id });
    
    unless ($photo) {
        $c->flash->{error} = 'Couln\'t find photo with id '.$photo_id.', no photo deleted.';
    } else {

        $c->flash->{message} = $photo->caption . " deleted successfully.";
        $photo->delete;
    }
    
    if ($from =~ /^\d+$/) { #more options to redir to
        $c->res->redirect($c->uri_for("/album/view/$from"));
    } else {
        $c->res->redirect($c->uri_for("/default"));
    }

    $c->detach;
}

sub _send_photo_added {
    my $self = shift;
    my $c = shift;
    my $photo = shift;
    my @admin_arr;

    my $admin_role = $c->model('LaoFabDB::Role')->search({
        role => 'admin',
    })->next;

    return unless $admin_role;

    my $admins = $c->model('LaoFabDB::UserRole')->search({
        role => $admin_role->id,
    });

    while (my $admin = $admins->next) {
        push @admin_arr, $admin->user->username;
    }

    return unless scalar(@admin_arr);

    $c->stash->{email} = {
        to       => join(', ', @admin_arr),
        from     => $c->config->{email}->{from_address},
        subject  => '[LaoFAB repo] New photo added!',
        template => 'photo_added.tt2',
    };
    $c->stash->{photo} = $photo;
    $c->forward( $c->view('Email::Template') );
}

sub _resize_photo {
    my ($self, $c, $photo, $width, $height) = @_;

    my $mimeinfo = File::MimeInfo->new;

    my $data = $photo->file->open('r') or die "Error: $!";
    my $img = Imager->new;
    $img->read( fh => $data ) or die $img->errstr;
    
    $photo->width($img->getwidth);
    $photo->height($img->getheight);

    my $scaled;
    if ($height) {
        $scaled = $img->scale(xpixels=>$width,ypixels=>$height,type=>'min');#xheight => $size );
    } else {
        $scaled = $img->scale(xpixels=>$width,type=>'min');
    }
    my $out;
    my $extension;
    if ($photo->mime =~ /\/(.+)$/) {
        $extension = $1;
    }
    $scaled->write(
        type => $extension,
        # type => $mimeinfo->extensions( $photo->mime ),
        data => \$out,
    ) or die $scaled->errstr;
    
    my ($fh, $filename) = tempfile();

    $scaled->write(file=>$filename, type=>$extension) or die $scaled->errstr;
    if ($height) {
        $photo->thumbnail($fh);
    } else {
        $photo->normal($fh);
    }
}

sub add : Local {
    my ( $self, $c, $album_id ) = @_;
    
    my $album;
    
    if ($album_id) {
        $album = $c->model('LaoFabDB::Albums')->find({
            id => $album_id
        });
    } elsif ($c->req->param("album")) {
        $album = $c->model('LaoFabDB::Albums')->find({
            id => $c->req->param("album")
        });
    }

    
    my $photo = $c->model("LaoFabDB::Photos")->new({});
    
    
    if ($c->req->param("submit")) {
        $photo->caption(_trim($c->req->param("caption")));
        $photo->location(_trim($c->req->param("location")));
        $photo->photographer(_trim($c->req->param("photographer")));
        $photo->taken_dt(_trim($c->req->param("taken_dt")));
        if ($self->_validate_form($c, $photo) and $self->_validate_file($c)) {
            my $message = 'The photo '.$photo->caption.' was added successfully. ';
            my $mime = MIME::Types->new;
            my $user = $c->model('LaoFabDB::User')->find({ id => $c->user->id });
            $photo->create_user($user);
            $photo->mime($mime->mimeTypeOf($c->req->upload("photo")->basename));
            $photo->file($c->req->upload("photo")->fh);
            $photo->filesize($c->req->upload("photo")->size);
            $photo->album($album->id);
            
            $self->_resize_photo($c, $photo, 150, 150);
            $self->_resize_photo($c, $photo, 800);
                        
            $photo->insert;
            if (!($c->check_user_roles(qw|admin|)) and lc($c->config->{email}->{enabled}) eq 'true') {
                $self->_send_photo_added($c, $photo);
            }
            
            if (lc($c->config->{twitter}->{enabled}) eq 'true') {
                # twitter
                my $twit = Net::Twitter->new({ 
                    username => $c->config->{twitter}->{username}, 
                    password => $c->config->{twitter}->{password},
                    source => 'laofab.org',
                    clientname => 'laofab.org',
                    clientver => '2.0',
                    clienturl => $c->uri_for('/'),
                });
                my $status = 'New photo uploaded: "' .
                    $photo->caption . '" at ' .
                    $c->uri_for('/album/slide/'.$photo->album()->id .'/'.$photo->id );

                $twit->update({status => $status});
            }
            
            $c->flash->{message} = $message;
            $c->res->redirect($c->uri_for("/album/view/".$album->id));
            $c->detach;
        } 
    }
    
    my $albums = $c->model('LaoFabDB::Albums')->search({},{order_by => 'name'});
    
    $c->stash->{albums} = $albums;
    $c->stash->{album} = $album;
    $c->stash->{photo} = $photo;
 #   $c->stash->{today} = DateTime->now()->ymd();
}

sub edit : Local {
    my ( $self, $c, $photo_id, $album_id ) = @_;
    
    my $photo = $c->model("LaoFabDB::Photos")->find({
        id => $photo_id
    });
    
    my $album = $c->model("LaoFabDB::Albums")->find({
        id => $album_id
    });
    
    unless ($photo && $album) {
        $c->stash->{error} = "Could not find the photo with id: $photo_id". "!";
        $c->forward("/default");
        $c->detach;
    }
    
    if ($c->req->param("submit")) {
        $photo->caption(_trim($c->req->param("caption")));
        $photo->location(_trim($c->req->param("location")));
        $photo->photographer(_trim($c->req->param("photographer")));
        $photo->taken_dt(_trim($c->req->param("taken_dt")));
        $photo->album($c->req->param("album"));
        if ($self->_validate_form($c, $photo) &&
            (!defined($c->req->upload("photo")) || $self->_validate_file($c))) {
            my $message = 'The photo '.$photo->caption.' was edited successfully. ';
            my $mime = MIME::Types->new;
            my $user = $c->model('LaoFabDB::User')->find({ id => $c->user->id });
            $photo->create_user($user);
            if (defined($c->req->upload("photo"))) {
                $photo->mime($mime->mimeTypeOf($c->req->upload("photo")->basename));
                $photo->file($c->req->upload("photo")->fh);
                $photo->filesize($c->req->upload("photo")->size);
                $self->_resize_photo($c, $photo, 150, 150);
                $self->_resize_photo($c, $photo, 800);
            }
            
            $photo->update();
            
            # $c->model("LaoFabDB::PhotoAlbum")->create({
            #     photo => $photo->id,
            #     album => $album->id,
            # });
            
            $c->flash->{message} = $message;
            $c->res->redirect($c->uri_for("/album/view/$album_id"));
            $c->detach;
        }
    }
    my $albums = $c->model('LaoFabDB::Albums')->search({});
    
    $c->stash->{albums} = $albums;
    $c->stash->{album} = $album;
    $c->stash->{photo} = $photo;
}


=head2 _validate_file

helper method (private) for add and edit actions. checks so that a file has been uploaded and returns 1 of OK.

=cut

#TODO mime type
sub _validate_file {
    my ($self, $c) = @_;
    my $mime = MIME::Types->new;
    unless (defined($c->req->upload("photo")) and
             length($c->req->upload("photo")->basename)) {
        $c->stash->{error} = 
            'Couldn\'t find any uploaded image, please correct.';
        return 0;
    }
    unless ( $mime->mimeTypeOf( $c->req->upload('photo')->basename ) =~ /^image\// ) {
        $c->stash->{error} = 
            'The supplied file does not look like an image, please correct.';
        return 0;
    }
    return 1;
}

=head2 _validate_form

helper method (private) for add and edit actions. Checks the necessary fields so that they are correct and returns 1 if OK.

=cut

sub _validate_form {
    my ($self, $c, $photo) = @_;

    unless (defined($photo->caption()) and 
        length($photo->caption())>0) {
        $c->stash->{error} = 'No title entered, please correct.';
        return 0;
    }
    return 1;
}

=head2 _trim

A subrutine for trimming of spaces and also removing redundant spaces

=cut

sub _trim {
    my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	$string =~ s/\s+/ /g;
    return $string;
}
1;
