package LaoFab::Controller::Document;
use strict;
use warnings;
use parent 'Catalyst::Controller';
use HTML::Entities;
use MIME::Types;
use File::MimeInfo ();
use Data::Dumper;
use Catalyst::Request::Upload;
use Net::Twitter;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use File::Temp qw/ :POSIX /;
use HTTP::BrowserDetect;
use JSON::Any;
use DateTime::Format::MySQL;
use URI;

=head1 NAME

LaoFab::Controller::Document - Document Controller for LaoFab

=head1 DESCRIPTION

This controller handles the various actions for the documents such as view, edit etc.

=head1 METHODS

view
do_tag_cloud
delete
edit
add
download
resent
_send_document_added
_validate_file
_validate_form
_trim
_notify_new_doc
_make_tags
_insert_meta_data
_get_authors

=cut

=head2 _send_document_added (private)

Sends an email to the admin(s) once a new document is uploaded.

=cut

sub _send_document_added {
    my $self = shift;
    my $c = shift;
    my $document = shift;
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
        subject  => '[LaoFAB repo] New document added!',
        template => 'document_added.tt2',
    };
    $c->stash->{document} = $document;
    $c->forward( $c->view('Email::Template') );
}

=head2 view

action for viewing a document with a certain id

=cut

sub view : Local {
    my ($self, $c, $docid) = @_;

    $c->stash->{menupage} = 'browse';
    my $folderid;
    if ($c->req->referer and $c->req->referer =~ m/folder\/view\/(\d+)$/) {
        $folderid = $1;
        my $folder = $c->model('LaoFabDB::Folders')->find({id => $folderid});
        $c->stash->{back} = {
            url => $c->uri_for("/folder/view/$folderid"),
            name => $folder->name,
        };#$c->req->referer;
    }
    my $document = $c->model('LaoFabDB::Documents')->find({id => $docid});
    unless ($document) {
        my $redir = "/folder/view/$folderid";
        $redir = "/default" unless ($folderid); 
        $c->res->redirect( $redir ); # require login
        $c->flash->{error} = "The document you requested can not be found, sorry.";
        $c->detach;
    }

    # restricted documents and no login?
    if ($document->permission eq 're' and not $c->user_exists) {
    	my $login_page = $c->model('LaoFabDB::Content')->find({
	    	page => 'login',
    	});
	    $c->stash->{error} = 'This document is restricted to members only, please login to gain access'.
    	$c->stash->{login_page} = $login_page;
	    $c->stash->{ 'template' } = 'login_auth.tt2';
    	return 0;
    }

    my $downloads = $c->model('LaoFabDB::Downloads')->search({
        document => $document->id,
    },{
        prefetch => 'user',
        order_by => ['download_dt desc'],
    })->slice(0,14);

    my $mailq = 'content:laofab.org/document/view/'.$document->id . ' AND -from:noreply@laofab.org';
#    {
#        'content' => "laofab.org/document/view/" . $document->id,
#        '-from' => 'noreply@laofab.org',
#    };

    my $options = {
        fl    => 'sentDate,subject,uuid',
        sort  => 'sentDate desc',
        rows  => 20,
    };

    my $emails = [];
    
    eval {
        my $response = $c->model('SolrMail')->search( $mailq, $options);

        for my $mail ( $response->docs ) {
            my $digest = { 
                sentDate => $mail->value_for('sentDate'),
                subject => $mail->value_for('subject'),
                uuid => $mail->value_for('uuid'),
            };
            push @$emails, $digest;
        }
    };

    if ($document->permission ne 're') {
        my $facebook = {
            title => $document->title,
        };

        $facebook->{title} .= ' ('. $document->sub_title . ')' if ($document->sub_title);
        $facebook->{image} = $c->uri_for('/static/images/doc/prev/' . $document->id . '.jpg') if $document->preview;
        $c->stash->{facebook} = $facebook;
    }

    $c->stash->{document} = $document;
    $c->stash->{downloads} = $downloads;
    $c->stash->{emails} = $emails;
}

=head2 do_tag_cloud

action to return a JSON structure for the tag cloud. Takes the most used phrases for documents from the database.

=cut

sub do_tag_cloud : Local {
    my ($self, $c) = @_;
    my $ret;
    my @tags;

    my $result = $c->model('LaoFabDB::Tags')->search(undef,
        {
            select => [ 'tag', { sum => 'weight' }],
            as => [qw/ tag weight /],
            group_by => [qw/ tag /],
            order_by => ['sum(weight) desc'],
        })->slice(0,30);
    
    while (my $row = $result->next) {
        push @tags, { name => $row->tag, count => int($row->weight) };
    }

    @tags = sort { lc($a->{name}) cmp lc($b->{name}) } @tags;

    $ret->{items} = \@tags;
    $c->stash->{json} = $ret;
    $c->forward('LaoFab::View::JSON');    
}

=head2 _validate_file

helper method (private) for add and edit actions. checks so that a file has been uploaded and returns 1 of OK.

=cut

sub _validate_file {
    my ($self, $c) = @_;
    unless (defined($c->req->upload("document")) and
             length($c->req->upload("document")->basename)) {
        $c->stash->{error} = 
            'Couldn\'t find any uploaded file, please correct.';
        return 0;
    }
    return 1;
}

=head2 _validate_form

helper method (private) for add and edit actions. Checks the necessary fields so that they are correct and returns 1 if OK.

=cut

sub _validate_form {
    my ($self, $c, $document) = @_;

    unless (defined($document->title()) and 
        length($document->title())>0) {
        $c->stash->{error} = 'No title entered, please correct.';
        return 0;
    }
    unless (defined($document->pubyear()) and 
        $document->pubyear() =~ /^[12]\d{3}$/) {
        $c->stash->{error} = 'No valid publication year, please correct.';
        return 0;
    }
    unless (defined($c->req->param("folder")) and length($c->req->param("folder"))) {
        $c->stash->{error} = 
            'The document must be available in at least one folder, please correct.';
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

=head2 _notify_new_doc

a private method for notify the uploader and twitter that the document is uploaded and accepted. Calles from edit action.

=cut

sub _notify_new_doc {
    my ($self, $c, $document, $email) = @_;
    if ($email and lc($c->config->{email}->{enabled}) eq 'true') {
        # send mail
        $c->stash->{email} = {
            to       => $document->create_user->username,
            from     => $c->config->{email}->{from_address},
            subject  => '[LaoFAB repo] Your document is approved!',
            template => 'document_approved.tt2',
        };
        $c->stash->{document} = $document;
        $c->forward( $c->view('Email::Template') );
    }

    if (lc($c->config->{twitter}->{enabled}) eq 'true') {
        # twitter
        my $twit = Net::Twitter->new({ 
            username => $c->config->{twitter}->{username}, 
            password => $c->config->{twitter}->{password},
			source => 'laofab.org',
			clientname => 'laofab.org',
			clientver => '2.0',
			clienturl => $c->uri_for('/')->as_string,
        });
        my $status = 'New document uploaded: "' .
            $document->short_title . '" at ' .
            $c->uri_for('/document/view/'.$document->id);

        $twit->update({status => $status});
    }
}

=head2 _make_tage

Private method for stripping out the various tags/words for a document, get's called by add and edit actions.

=cut

sub _make_tags {
    my ($self, $c, $document) = @_;

    my @ignore_words = qw/ i a am the in is are you me we and an for from not at be by do go if in no of ok on or so to up us/;

    
	# keywords
    foreach my $sentance ($document->keywords) {
        foreach my $tag (split(/\s+/, $sentance->word)) {
            next if grep {lc($tag) eq $_} @ignore_words;
            $tag =~ s/\W//g;
            $c->model('LaoFabDB::Tags')->create({
                tag      => lc($tag),
                weight   => 1,
                document => $document,
            });
        }
    }

    # title
    foreach my $tag (split(/\s+/, $document->title)) {
        next if grep {lc($tag) eq $_} @ignore_words;
        $tag =~ s/\W//g;
        $c->model('LaoFabDB::Tags')->create({
            tag      => lc($tag),
            weight   => 3,
            document => $document,
        });
    }
    # sub_title
    foreach my $tag (split(/\s+/, $document->sub_title)) {
        next if grep {lc($tag) eq $_} @ignore_words;
        $tag =~ s/\W//g;
        $c->model('LaoFabDB::Tags')->create({
            tag      => lc($tag),
            weight   => 2,
            document => $document,
        });
    }
    # author name and org
    foreach my $author ($document->authors) {
        foreach my $tag (split(/\s+/, $author->name)) {
            next if grep {lc($tag) eq $_} @ignore_words;
            $tag =~ s/\W//g;
            $c->model('LaoFabDB::Tags')->create({
                tag      => lc($tag),
                weight   => 1,
                document => $document,
            });
        }
        foreach my $tag (split(/\s+/, $author->org)) {
            next if grep {lc($tag) eq $_} @ignore_words;
            $tag =~ s/\W//g;
            $c->model('LaoFabDB::Tags')->create({
                tag      => lc($tag),
                weight   => 1,
                document => $document,
            });
        }
    }
}

=head2 delete

delete action that deletes a document.

=cut

sub delete : Local {
    my ($self, $c, $doc_id) = @_;
    $c->stash->{menupage} = 'browse';
    my $from = $c->req->param("from");
    my $document = $c->model("LaoFabDB::Documents")->find({ id => $doc_id });
    
    unless ($document) {
        $c->flash->{error} = 'Couln\'t find document with id '.$doc_id.', no document deleted.';
    } else {

        $c->flash->{message} = $document->short_title . " deleted successfully.";
        $document->delete;
    }
    if ($from eq 'recent') {
        $c->res->redirect($c->uri_for("/document/recent"));
    } elsif ($from =~ /^\d+$/) { #more options to redir to
        $c->res->redirect($c->uri_for("/folder/view/$from"));
    } else {
        $c->res->redirect($c->uri_for("/default"));
    }

    $c->detach;
}

=head2 _insert_meta_data

a helper method for add and edit actions to insert various meta data to a new document.

=cut

sub _insert_meta_data {
	my $self = shift;
	my $c = shift;
	my $document = shift;
	
	foreach my $word (split (/,/, $c->req->param("keywords"))) {
        $c->model('LaoFabDB::Keywords')->create({
            word     => _trim($word),
            document => $document,
        });
    }
    foreach my $f_id (split (/,/, $c->req->param("folder"))) {
        #root folder doesn't work....how to do? Stupid hack:
        $f_id = 0 if $f_id eq 'on';
        my $tmp_folder = $c->model('LaoFabDB::Folders')->find({
            id => $f_id
        });
        next unless $tmp_folder;
        $c->model('LaoFabDB::DocumentFolder')->create({
            folder   => $tmp_folder,
            document => $document,
        });
    }
    foreach my $s_id ($c->req->param("subcats")) {
        my $tmp_subcat = $c->model('LaoFabDB::Subcats')->find({
            id => $s_id
        });
        next unless $tmp_subcat;
        $c->model('LaoFabDB::DocumentSubcat')->create({
            subcat   => $tmp_subcat,
            document => $document,
        });
    }
}

=head2 _get_authors

a helper method to parse out the authors from the form and return an array, gets called from add and edit actions.

=cut

sub _get_authors {
	my $self = shift;
	my $c = shift;
	my @authors;
	if ($c->req->param("authors")) {
		foreach my $author ($c->req->param("authors")) {
			my ($a_name, $a_org) = split(/=>/, $author);
			push @authors, $c->model("LaoFabDB::Authors")->new({
				name => _trim($a_name),
				org  => _trim($a_org),
			});
		}
	}
	if ($c->req->param("author_name") or $c->req->param("author_org")) {
		push @authors, $c->model("LaoFabDB::Authors")->new({
			name => _trim($c->req->param("author_name")),
			org  => _trim($c->req->param("author_org")),
		});
	}

	return @authors;
}

=head2 edit

edit action that can be called when an administrator needs to edit or accept a document.

=cut

sub edit : Local {
    my ($self, $c, $doc_id) = @_;
    $c->stash->{menupage} = 'browse';
    my $flag_new = 0;
    my $document = $c->model("LaoFabDB::Documents")->find({ id => $doc_id });
    my $selected_folders = [];


    unless ($document) {
        $c->stash->{error} = "Could not find document with id: $doc_id". "!";
        $c->forward("/default");
        $c->detach;
    }

    $flag_new = 1 unless $document->viewable;

    my @authors = ();
    my @keywords = ();
    my @subcats = ();

    if ($c->req->param("submit")) {
		@authors = $self->_get_authors($c);
        $document->pubyear(_trim($c->req->param("pubyear")));
        $document->title(_trim($c->req->param("title")));
        $document->sub_title(_trim($c->req->param("sub_title")));
        if ($self->_validate_form($c, $document)) {

            my $user = $c->model('LaoFabDB::User')->find({ id => $c->user->id });
            $document->checked_user($user) if $user;
            my ($sec,$min,$hour,$mday,$mon,$year)=localtime(time);
            my $timestamp = sprintf("%4d-%02d-%02d %02d:%02d:%02d\n", $year+1900,$mon+1,$mday,$hour,$min,$sec);
            $document->checked_dt($timestamp);
            
            if (defined($c->req->upload("document")) and
                length($c->req->upload("document")->basename)) {
                my $mime = MIME::Types->new;
                unlink ($document->file) if -f $document->file;
                $document->mime($mime->mimeTypeOf(
                    $c->req->upload("document")->basename));
                $document->file($c->req->upload("document")->fh);
                $document->filesize($c->req->upload("document")->size);
                $document->filename($c->req->upload("document")->basename);
            }
            $document->viewable(1);
            my $doctype = $c->model('LaoFabDB::Doctypes')->find({
                id => $c->req->param("doctype"),
            });
       
            $document->doctype($doctype) if $doctype;
            $document->permission(_trim($c->req->param('permission')));

            
            $document->update;

			$document->authors->delete;
			$document->keywords->delete;
			$document->tags->delete;
			$document->set_subcats([]);
			$document->set_folders([]);
            $document->areas->delete;
            if ($c->req->param('mapcoords')) {
                for my $coords (split (/;/, $c->req->param('mapcoords'))) {
                    $coords =~ s/^\(//;
                    $coords =~ s/\)$//;
                    my @pairs = map { [ split /,\s/, $_ ] } split /\)\(/, $coords;
                    push @pairs, [$pairs[0]->[0], $pairs[0]->[1]]; # complete the polygon
                    my $areas = $c->model("LaoFabDB::Areas")->new({
			            document => $document,
			            polygon  => 'POLYGON(('.join (', ', map { join (' ', @$_) } @pairs).'))',
		            });
                    $areas->center($areas->calc_center);
                    $areas->insert;
                }
            }
 
            $self->_insert_meta_data($c, $document);

            foreach my $author (@authors) {
                $author->document($document);
                $author->insert;
            }
            $self->_make_tags($c, $document);

            $self->_notify_new_doc($c, $document, 1) if $flag_new;

            $c->flash->{message} = "The document ".$document->title." is updated and viewable.";
            $c->res->redirect($c->uri_for("/document/view/".$document->id));
            $c->detach;
        } else {
            # repopulate values
            $c->stash->{authors} = \@authors;
            # my $s_folders = "";
            # my $delim = "?";
            # foreach my $s_fid ($c->req->param("folder")) {
            #     #root folder doesn't work....how to do? Stupid hack:
            #     $s_fid = 0 if $s_fid eq 'on';
            #     $s_folders .= $delim."fid=".$s_fid;
            #     $delim = "&" if $delim eq "?";
            # }
            my @s_folders = split(/,/,$c->req->param("folder"));
            $selected_folders = \@s_folders;
            my @s_subcats;
            foreach my $s_id ($c->req->param("subcats")) {
                push (@s_subcats, $s_id);
            }

            $c->stash->{s_subcats} = \@s_subcats;
            $c->stash->{keywords} = $c->req->param("keywords");
            #TODO set coords $c->stash->{coords} = $c->req->param("keywords");
        }
    } else {
        # enter stash values

		foreach my $author ($document->authors) {
			push @authors, $author;
		}

		foreach my $folder ($document->folders) {
		    push @$selected_folders, $folder->id;
		}

		foreach my $word ($document->keywords) {
			push @keywords, $word->word;
		}
			
		foreach my $s_sub ($document->subcats) {
			push @subcats, $s_sub->id;
		}

        $c->stash->{s_subcats} = \@subcats; 
        $c->stash->{keywords} = join (', ', @keywords);
        $c->stash->{authors} = \@authors;
    }
    # do the tree
    my $j = JSON::Any->new;
    my $tree = $c->model('LaoFabDB::Folders')->get_check_tree($selected_folders);
    $c->stash->{tree} = $j->objToJson($tree);
    $c->stash->{jquery} = 1;
    $c->stash->{selected_folders} = join(",", @$selected_folders);
    
    # send to view
    $c->stash->{document} = $document;

    my @subcats_obj = $c->model("LaoFabDB::Subcats")->all();
    @subcats_obj = sort {$a->main_cat cmp $b->main_cat} @subcats_obj;
    $c->stash->{subcats} = \@subcats_obj;

    my @doctypes_obj = $c->model("LaoFabDB::Doctypes")->all();
    @doctypes_obj = sort {$a->id <=> $b->id} @doctypes_obj;
    $c->stash->{doctypes} = \@doctypes_obj;

    my @locations_obj = sort { 
        $a->id <=> $b->id
    } $c->model("LaoFabDB::Locations")->all();
    $c->stash->{locations} = \@locations_obj;
}

=head2 add 

add action that either shows a form or accepts a form and if it is by a regular user, it will be created as a non viewable documents that needs an administrators approval

=cut

sub add : Local {
    my ($self, $c, $folder_id) = @_;
    
    $c->stash->{menupage} = 'docadd';
    
    my @authors = ();
    my $selected_folders;
    
    my $document = $c->model("LaoFabDB::Documents")->new({});
    
    my $folder_obj = $c->model("LaoFabDB::Folders")->find({ id => $folder_id });
    if ($folder_obj) {
        $c->stash->{folder_name} = $folder_obj->name;
    }

    if ($c->req->param("submit")) {
		@authors = $self->_get_authors($c);
        $document->pubyear(_trim($c->req->param("pubyear")));
        $document->title(_trim($c->req->param("title")));
        $document->sub_title(_trim($c->req->param("sub_title")));

        if ($self->_validate_form($c, $document) and $self->_validate_file($c)) {
            my $mime = MIME::Types->new;
            my $message = 'The document '.$document->title.' was added successfully. ';
            my $user = $c->model('LaoFabDB::User')->find({ id => $c->user->id });
            $document->create_user($user);
            $document->mime($mime->mimeTypeOf(
                $c->req->upload("document")->basename));
            $document->file($c->req->upload("document")->fh);
            $document->filesize($c->req->upload("document")->size);
            $document->filename($c->req->upload("document")->basename);
            if ($c->check_user_roles(qw|admin|)) {
                $document->viewable(1);
                my $user = $c->model('LaoFabDB::User')->find({ id => $c->user->id });
                $document->checked_user($user) if $user;
                my ($sec,$min,$hour,$mday,$mon,$year)=localtime(time);
                my $timestamp = sprintf("%4d-%02d-%02d %02d:%02d:%02d\n", $year+1900,$mon+1,$mday,$hour,$min,$sec);
                $document->checked_dt($timestamp);
            } else {
                $document->viewable(0);
                $message .= 'It will be viewable after '.
                    ' the moderator has approved it. Thank you!';
            }
            my $doctype = $c->model('LaoFabDB::Doctypes')->find({
                id => $c->req->param("doctype"),
            });
       
            $document->doctype($doctype) if $doctype;
            $document->permission(_trim($c->req->param('permission')));

            if ($c->req->param('mapcoords')) {
                for my $coords (split (/;/, $c->req->param('mapcoords'))) {
                    $coords =~ s/^\(//;
                    $coords =~ s/\)$//;
                    my @pairs = map { [ split /,\s/, $_ ] } split /\)\(/, $coords;
                    push @pairs, [$pairs[0]->[0], $pairs[0]->[1]]; # complete the polygon
                    my $areas = $c->model("LaoFabDB::Areas")->new({
			            document => $document,
			            polygon  => 'POLYGON(('.join (', ', map { join (' ', @$_) } @pairs).'))',
		            });
                    $areas->center($areas->calc_center);
                    $areas->insert;
                }
            }
            
            $document->insert;

            $self->_insert_meta_data($c, $document);

            foreach my $author (@authors) {
                $author->document($document);
                $author->insert;
            }
            if ($c->check_user_roles(qw|admin|)) {
                $self->_make_tags($c, $document);
            }
            if ($document->viewable == 0 and lc($c->config->{email}->{enabled}) eq 'true') {
                $self->_send_document_added($c, $document);
            } elsif ($document->viewable) {
	            $self->_notify_new_doc($c, $document, 0);
			}
            $c->flash->{message} = $message;
            $c->res->redirect($c->uri_for("/folder/view/$folder_id"));
            $c->detach;

            # forward to another page with message

        } else {
            # repopulate values
            $c->stash->{authors} = \@authors;
            # my $s_folders = "";
            # my $delim = "?";
            # foreach my $s_fid ($c->req->param("folder")) {
            #     #root folder doesn't work....how to do? Stupid hack:
            #     $s_fid = 0 if $s_fid eq 'on';
            #     $s_folders .= $delim."fid=".$s_fid;
            #     $delim = "&" if $delim eq "?";
            # }
            my @s_folders = split(/,/,$c->req->param("folder"));
            $selected_folders = \@s_folders;
            my @s_subcats;
            foreach my $s_id ($c->req->param("subcats")) {
                push (@s_subcats, $s_id);
            }

            $c->stash->{s_subcats} = \@s_subcats;
#            $c->stash->{in_folders} = $s_folders;
            $c->stash->{keywords} = $c->req->param("keywords");
        }
    } else {
        # pupolate values
#        $c->stash->{in_folders} = $folder_id;
        $selected_folders = [ $folder_id ];
    }
    # do the tree
    my $j = JSON::Any->new;
    my $tree = $c->model('LaoFabDB::Folders')->get_check_tree($selected_folders);

    $c->stash->{tree} = $j->objToJson($tree);
    $c->stash->{jquery} = 1;
    $c->stash->{selected_folders} = join(",", @$selected_folders);
    
    $c->stash->{select_key} = $self->_get_select_key($c);
    # show form
    my @subcats_obj = $c->model("LaoFabDB::Subcats")->all();
    @subcats_obj = sort {$a->main_cat cmp $b->main_cat} @subcats_obj;
    $c->stash->{subcats} = \@subcats_obj;

    my @doctypes_obj = $c->model("LaoFabDB::Doctypes")->all();
    @doctypes_obj = sort { if ($a->id == 8) { return -1; } else { return $a->id <=> $b->id } } @doctypes_obj;

    $c->stash->{doctypes} = \@doctypes_obj;
    $c->stash->{document} = $document;

    my @locations_obj = sort { 
        $a->id <=> $b->id
    } $c->model("LaoFabDB::Locations")->all();
    $c->stash->{locations} = \@locations_obj;
}

=head2 _get_select_key

Returns the select key, either CTRL or Command/Apple depending on OS System.

=cut

sub _get_select_key {
    my $self = shift;
    my $c = shift;

    my $bd = HTTP::BrowserDetect->new;
    $bd->user_agent($c->req->user_agent);
    return "Command/Apple"
        if $bd->os_string =~ m/^mac/i;
    return "CTRL";
}

=head2 download

This action handles file downloads, set's the right mime header and returns the document (and update the database)

=cut

sub download_zip : Local {
    my ($self, $c, $doc_id) = @_;

    my $document = $c->model("LaoFabDB::Documents")->find({ id => $doc_id });

    unless ($document) {
        $c->stash->{error} = "Could not find document with id: $doc_id". "!";
        $c->forward("/default");
        $c->detach;
    }
    
    #my $tmp_zip_file = tmpnam();
    my $tmp_zip_file = File::Temp->new;
    
    my $zip = Archive::Zip->new();
    $zip->addFile( $document->file->stringify, $document->filename );
    
    unless ($zip->writeToFileNamed($tmp_zip_file->filename) == AZ_OK) {
        $c->stash->{error} = "Could not ZIP document with id: $doc_id". "!";
        $c->forward("/default");
        $c->detach;    
    }
    
    my $user = $c->model('LaoFabDB::User')->find({id => $c->user->id });
    my $last_hour = DateTime->now;
    $last_hour->subtract( hours => 1);
    my $search_dt = DateTime::Format::MySQL->format_datetime($last_hour);
    
    my $downloads = $c->model('LaoFabDB::Downloads')->search({
        user        => $user->id,
        document    => $document->id,
        download_dt => { '>', $search_dt },
    });
    
    if ($user && $downloads->count() == 0) {
    
        $c->model('LaoFabDB::Downloads')->create({
            user     => $user,
            document => $document,
        });
    }
    $c->response->header('Content-Type' => 'application/zip');
    $c->response->header('Content-Disposition' => 'attachment; filename='.$document->filename . '.zip');
    #$c->response->header('Content-Description' => $document->title); # Optional line
    $c->response->body($tmp_zip_file);
#    $c->serve_static_file($tmp_zip_file->filename);
    #$c->stash->{template} = '';
}

=head2 download

This action handles file downloads, set's the right mime header and returns the document (and update the database)

=cut

sub download : Local {
    my ($self, $c, $doc_id) = @_;

    my $document = $c->model("LaoFabDB::Documents")->find({ id => $doc_id });

    unless ($document) {
        $c->stash->{error} = "Could not find document with id: $doc_id". "!";
        $c->forward("/default");
        $c->detach;
    }
    
    my $user = $c->model('LaoFabDB::User')->find({id => $c->user->id });
    
    my $last_hour = DateTime->now;
    $last_hour->subtract( hours => 1);
    my $search_dt = DateTime::Format::MySQL->format_datetime($last_hour);
    
    my $downloads = $c->model('LaoFabDB::Downloads')->search({
        user        => $user->id,
        document    => $document->id,
        download_dt => { '>', $search_dt },
    });
    
    if ($user && $downloads->count() == 0) {
    
        $c->model('LaoFabDB::Downloads')->create({
            user     => $user,
            document => $document,
        });
    }

    $c->response->header('Content-Type' => $document->mime);
    $c->response->header('Content-Disposition' => 'attachment; filename='.$document->filename);
    #$c->response->header('Content-Description' => $document->title); # Optional line
    $c->response->body($document->file->open('r'));
#    $c->serve_static_file($document->file);
    #$c->stash->{template} = '';
}

=head2 recent

Action that just pulls out the new un-viewable documents for an administrator

=cut

sub recent : Local {
    my ($self, $c) = @_;

    $c->stash->{menupage} = 'recent';
    
    my $documents = $c->model('LaoFabDB::Documents')->search({
        viewable => 0,
    });

    $c->stash->{documents} = $documents;
}
1;
