package LaoFab::Controller::User;

use strict;
use warnings;
use parent 'Catalyst::Controller::reCAPTCHA';
use Catalyst::Request::Upload;
use Text::CSV::Encoded;
use HTTP::BrowserDetect;
use DateTime;
use DateTime::Format::MySQL;

=head1 NAME

LaoFab::Controller::User - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

_email_valid
_check_user_email
_send_password_recovery
_send_added_user
password_recovery
_valid_email
_valid_password
edit
edit_info
edit_password

=cut


=head2 _email_valid

Checks wether a supplied email address is valid (on string basis) and returns 1 if so.

=cut

sub _email_valid {
    my $email = shift;
    return 1 if $email =~ /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/;
    return 0;
}

=head2 _check_user_email

Checks if a suplied param is a registered email address or not, returns 0 if it is valid.

=cut

sub _check_user_email {
    my ($self, $c) = @_;

    my $reg_user = $c->model('LaoFabDB::User')->find({
        username => $c->req->param('__username'),
    });
    if ($reg_user && (my $password = $reg_user->password)) {
        return 0;
    }
    return 1;
}

=head2 _send_password_recovery

private helper method to send out email for password_recovery

=cut

sub _send_password_recovery {
    my ($self, $c) = @_;
	my $user = $c->model('LaoFabDB::User')->find({
		username => $c->req->param('__username')
	});
	my $recovery = $c->model('LaoFabDB::PasswordRecovery')->new({
		user => $user,
	});
	$recovery->insert;
	
    $c->stash->{email} = {
        to       => $c->req->param('__username'),
        from     => $c->config->{email}->{from_address},
        subject  => '[LaoFAB repo] Your requested password',
        template => 'password_recovery.tt2',
        content_type => 'text/plain',
    };

    $c->stash->{ip_address} = $c->req->address;
    $c->stash->{date_now} = DateTime->now;
	$c->stash->{reset_url} = 
		$c->uri_for('/user/reset/' . $user->id . '/' . $recovery->secret)->as_string;

    $c->forward( $c->view('Email::Template') );

}

=head2 reset

Action to reset a password for a user, takes the user id and a stored secret

=cut

sub reset : Local {
    my ( $self, $c, $u_id, $secret ) = @_;
    my $user = $c->model('LaoFabDB::User')->find({ id => $u_id });

    unless ($user) {
        $c->flash->{error} = "Could't find a valid user.";
        $c->res->redirect($c->uri_for('/default'));
        $c->detach;
    }

	my $recovery = $c->model('LaoFabDB::PasswordRecovery')->search({
		user => $user->id,
	},{
		order_by => 'expire_dt DESC',
	})->first;
    unless ($recovery) {
        $c->flash->{error} = "Could't find any restore request.";
        $c->res->redirect($c->uri_for('/default'));
        $c->detach;
    }

	if (DateTime->compare(DateTime::Format::MySQL->parse_datetime($recovery->expire_dt), DateTime->now) < 1) {
        $c->stash->{error} = "Reset request is too old, password reset must be done within 24 hours.";
        $c->res->redirect($c->uri_for('/default'));
        $c->detach;
    }

	unless ($recovery->validate($secret, $user, $c)) {
        $c->flash->{error} = "Unable to validate the password request.";
        $c->res->redirect($c->uri_for('/default'));
        $c->detach;
    }

	# We are now validated and can proceed with reseting password.

	if ($c->req->param("submit")) {
		if (!defined($c->req->param('password')) or !length($c->req->param('password'))) {
			$c->flash->{error} = "The password must be provided.";
			$c->detach;
		} elsif (length ($c->req->param('password')) < 6) {
			$c->flash->{error} = "The password must be at least 6 characters long.";
			$c->detach;
		} elsif ($c->req->param('password') ne $c->req->param('validate_password')) {
			$c->flash->{error} = "The password and confirmation password must be identical.";
			$c->detach;
		}
		
		$user->password($c->req->param('password'));
		$user->update;
		$c->stash->{message} = "The password is successfully changed.";
        $c->res->redirect($c->uri_for('/'));
        $c->detach;
	}

	# else - make the form
	$c->log->debug("all good!");
	$c->log->debug('are we here 6');
}


=head2 password_recovery

This action uses capcha_get. If correct captcha is supplied and the user is in the DB, an email will be send to that user.

=cut

sub password_recovery : Local {
    my ( $self, $c ) = @_;

    if (defined($c->req->param("__username")) and _email_valid($c->req->param('__username'))) {
        $c->forward('captcha_check');
        if ($c->stash->{recaptcha_error}) {
			o
            $c->stash->{error} = 'You did not supply the correct words for the <em>reCAPTCHA</em>. Please try again';
        } elsif ($self->_check_user_email($c)) {
            $c->stash->{error} = 'You did not supply the correct email address. Please try again';
        } else {
            $self->_send_password_recovery($c);
            $c->flash->{message} = 'Your password is sent to your registered email account. Thank you.';
            $c->res->redirect($c->uri_for('/'));
            $c->detach;
        }
    }
    $c->forward('captcha_get');
}

=head2 view

Action to view a user, either the user view it self, or an administrator view a user, in which case more statistical information is shown.

=cut

sub view : Local {
    my ( $self, $c, $u_id ) = @_;

    $u_id = $c->user->id unless $u_id;

    my $user = $c->model('LaoFabDB::User')->find({ id => $u_id });

    unless ($user) {
        $c->stash->{error} = "Could't find a user with user id '$u_id'.";
        $c->res->redirect($c->uri_for('/default'));
        $c->detach;
    }

    my $downloads = $c->model('LaoFabDB::Downloads')->search(
        { 
            user => $user->id, 
        },{
            order_by => 'download_dt DESC',
        })->slice(0,9);
    my $uploads = $c->model('LaoFabDB::Documents')->search(
        {
            create_user => $user->id,
        },{
            order_by => 'create_dt DESC',
        })->slice(0,9);
    my $comments = $c->model('LaoFabDB::Comments')->search(
        {
            user => $user->id,
        },{
            order_by => 'comment_dt DESC',
        })->slice(0,9);
    my $logins = $c->model('LaoFabDB::Logins')->search(
        {
            user => $user->id,
        },{
            order_by => 'create_dt DESC',
        })->slice(0,9);

    my $roles = $c->model('LaoFabDB::UserRole')->search({ user => $user->id });
    while (my $role = $roles->next) {
        $c->log->info("role ", $role->role->role);
    }
    $c->stash->{uploads} = $uploads;
    $c->stash->{downloads} = $downloads;
    $c->stash->{comments} = $comments;
    $c->stash->{logins} = $logins;
    $c->stash->{browser} = new HTTP::BrowserDetect();
    $c->stash->{user} = $user;
}

sub _send_added_user {
    my ($self, $c, $user) = @_;
    $c->stash->{email} = {
        to       => $user->username,
        from     => $c->config->{email}->{from_address},
        subject  => '[LaoFAB repo] Welcome to the LaoFAB Document Repository',
        template => 'added_user.tt2',
    };

    $c->stash->{password} = $user->password;
    $c->stash->{email_addr} = $user->username;

    $c->forward( $c->view('Email::Template') );
}

=head2 add_multi

action for adding multiple users from a supplied CSV file from google groupls and an initial password.

=cut

sub add_multi : Local {
    my ($self, $c) = @_;

    if (!defined($c->req->param('password')) or !length($c->req->param('password'))) {
        $c->flash->{error} = "The password must be set.";
    } elsif (length($c->req->param('password')) < 6) {
        $c->flash->{error} = "The password must be at least 6 characters long.";
    } elsif (!(defined($c->req->upload("csv")) and
             length($c->req->upload("csv")->basename))) {
        $c->flash->{error} = "Doesn't seem to be any file...";
    } else {
        my $csv_fh = $c->req->upload("csv")->fh;
        my $csv_parser = Text::CSV::Encoded->new ({ encoding  => "utf8" });
        my $no_imports = 0;
        while (my $line = <$csv_fh>) {
            next unless $csv_parser->parse($line);
            my @fields = $csv_parser->fields();
            next if ($fields[0] =~ /^Members for group laofab/);
            next if ($fields[0] =~ /^email address/);
            next unless ($fields[0] =~ /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/);
            eval {
                my $user = $c->model('LaoFabDB::User')->create({
                    username => lc($fields[0]),
                    password => $c->req->param('password'),
                    name     => $fields[1],
                });

                my $role = $c->model('LaoFabDB::Role')->find({ role => 'viewer' });
                $c->model('LaoFabDB::UserRole')->create({
                    user => $user->id,
                    role => $role->id,
                });
				$self->_send_added_user($c, $user);
				$no_imports++;
            };
            next if ($@);
        }
        $c->flash->{message} = "Imported $no_imports users.";
    }

    $c->res->redirect($c->uri_for('/manage'));
}

=head2 add

action for adding a single user with username, name, and an initial password.

=cut

sub add : Local {
    my ($self, $c) = @_;

    if (!defined($c->req->param('email')) or !length($c->req->param('email'))) {
        $c->flash->{error} = "Email must be set.";
    } elsif ($c->req->param('email') !~ /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/) {
        $c->flash->{error} = "Email address is not correct.";
    } elsif (!defined($c->req->param('password')) or !length($c->req->param('password'))) {
        $c->flash->{error} = "The password must be set.";
    } elsif (!defined($c->req->param('password2')) or !length($c->req->param('password2'))) {
        $c->flash->{error} = "The confirmation password must be set.";
    } elsif (length($c->req->param('password')) < 6) {
        $c->flash->{error} = "The password must be at least 6 characters long.";
    } elsif (!($c->req->param('password') eq $c->req->param('password2'))) {
        $c->flash->{error} = "The password and confirmation password must be identical.";
    } else {
        my $name = $c->req->param('name');
        my $email = $c->req->param('email');
        $name =~ s/^\s*(.+)\s*/$1/;
        $email =~ s/^\s*(.+)\s*/$1/;
        eval {
            my $user = $c->model('LaoFabDB::User')->create({
                name     => $name,
                username => lc($email),
                password => $c->req->param('password'),
            });
            # the roles
            $c->model('LaoFabDB::UserRole')->create({
                user => $user->id,
                role => 1,
            });
            if (defined($c->req->param('admin')) and $c->req->param('admin') eq 'on') {
                my $role = $c->model('LaoFabDB::Role')->find({ role => 'admin' });
                $c->model('LaoFabDB::UserRole')->create({
                    user => $user->id,
                    role => $role->id,
                });
            }
			$self->_send_added_user($c, $user);
        };
        if ($@) {
            $c->flash->{error} = "Couldn't create the user, most likely because the email address is already in use by someone else.";
        } else {
            $c->flash->{message} = "The user with email $email has been created.";
        }
    }
    $c->res->redirect($c->uri_for('/manage'));
}

=head2 list

Action for listing all users in the database.

=cut

sub list : Local {
    my ($self, $c) = @_;
	my $order = $c->req->param('order') || 'name';
	my $direction = $c->req->param('direction');
	my $order_by = 'name';
	
	if ($order eq 'name') {
		$order_by = 'me.name';
	} elsif ($order eq 'email') {
		$order_by = 'me.username';
	} elsif ($order eq 'date') {
		$order_by = 'me.create_dt';
#	} elsif ($order eq 'downloads') {
#		$order_by = 'count(downloads.user)';
#	} elsif ($order eq 'uploads') {
#		$order_by = 'count(documents.create_user)';
	} elsif ($order eq 'login') {
		$order_by = 'max(logins.create_dt)';
	} else {
		$order = undef;
	}
	
	if ($direction eq 'desc') {
		$order_by .= ' desc';
	} else {
		$order_by .= ' asc';
		$direction = 'asc';
	}
	
	$c->stash->{order} = $order;
	$c->stash->{direction} = $direction;
	
    my $users = $c->model('LaoFabDB::User')->search(undef,{
#		join 		=> [qw/ downloads logins documents /],
		join 		=> [qw/ logins /],
		group_by 	=> 'me.id',
        order_by 	=> $order_by,
    });
    my $page = $c->req->param('page');
    $page = 1 if ($page !~ /^\d+$/);
    $users = $users->page($page);
    
    $c->stash->{page} = $page;
    $c->stash->{users} = $users;
    $c->stash->{pager} = $users->pager;
}

=head2 search

Action for searching for users takes a query that searches in username and name.

=cut

sub search : Local {
    my ( $self, $c, $query ) = @_;

	my $order = $c->req->param('order') || '';
	my $direction = $c->req->param('direction');
	my $order_by = 'name';
	
	if ($order eq 'name') {
		$order_by = 'me.name';
	} elsif ($order eq 'email') {
		$order_by = 'me.username';
	} elsif ($order eq 'date') {
		$order_by = 'me.create_dt';
#	} elsif ($order eq 'downloads') {
#		$order_by = 'count(downloads.user)';
#	} elsif ($order eq 'uploads') {
#		$order_by = 'count(documents.create_user)';
	} elsif ($order eq 'login') {
		$order_by = 'max(logins.create_dt)';
	} else {
		$order = 'name';
	}
	
	if ($direction eq 'desc') {
		$order_by .= ' desc';
	} else {
		$order_by .= ' asc';
		$direction = 'asc';
	}
	
	$c->stash->{order} = $order;
	$c->stash->{direction} = $direction;
    
    $query ||= $c->req->param('s') 
        if (defined ($c->req->param('s')));

    unless ($query) {
        $c->flash->{error} = 'No search expression....';
        $c->res->redirect($c->uri_for('/manage'));
        $c->detach;
    }

    $c->stash->{query} = $query;

    my @tokens = split /\s+/, $query;

    my @expression;
    push @expression, (map +{'username' => {-like => "%$_%"}}, @tokens);
    push @expression, (map +{'name' => {-like => "%$_%"}}, @tokens);

    my $users = $c->model('LaoFabDB::User')->search(
            \@expression
        ,{
#			join 		=> [qw/ downloads logins documents /],
			join 		=> [qw/ logins /],
			group_by 	=> 'me.id',
	        order_by 	=> $order_by,
            #order_by => ['create_dt asc'],
        });

    my $page = $c->req->param('page');
    $page = 1 if ($page !~ /^\d+$/);
    $users = $users->page($page);

    $c->stash->{page} = $page;
    $c->stash->{users} = $users;
    $c->stash->{pager} = $users->pager;
    $c->stash->{template} = 'user/search_result.tt2';
}

=head2 delet

action for deleteing a user from its user id

=cut

sub delete : Local {
    my ($self, $c, $u_id) = @_;
    
    my $user = $c->model('LaoFabDB::User')->find({ id => $u_id });

    unless ($user || $u_id == 0) {
        $c->flash->{error} = "Could't find a user with user id '$u_id'.";
        $c->res->redirect($c->uri_for('/default'));
        $c->detach;
    }
    
    $c->flash->{message} = "User '".$user->username."' deleted.";
    $user->delete;
    $c->res->redirect($c->req->referer());
}

=head2 _valid_email

helper method to check if a supplied email is set and it is correct. Used by edit and edit_info.

=cut

sub _valid_email {
	my $self = shift;
	my $c = shift;
	
	    if (!defined($c->req->param('email')) or !length($c->req->param('email'))) {
	        $c->flash->{error} = "Email must be set.";
		return 0;
	    } elsif (!_email_valid($c->req->param('email'))) {
	        $c->flash->{error} = "Email address is not correct.";
		return 0;
	}
	return 1;
}

=head2 _valid_password

helper method to check if a supplied password is set and meets the requirements.

=cut

sub _valid_password {
	my $self = shift;
	my $c = shift;
	
	if (defined($c->req->param('password')) &&
	 	length($c->req->param('password')) < 6 &&
	 	length($c->req->param('password')) > 0) {
		$c->flash->{error} = "If set, the password must be at least 6 characters long.";
		return 0;
	    } elsif ($c->req->param('password') ne $c->req->param('password2')) {
	        $c->flash->{error} = "If set, the password and confirmation password must be identical.";
		return 0;
	}
	return 1;
}

=head2 edit

action to edit a user, called by an administrator.

=cut

sub edit : Local {
    my ($self, $c, $u_id) = @_;

	my $user = $c->model('LaoFabDB::User')->find({ id => $u_id });

	unless ($user || $u_id == 0) {
		$c->flash->{error} = "Could't find a user with user id '$u_id'.";
		$c->res->redirect($c->uri_for('/default'));
		$c->detach;
	}

	if ($self->_valid_email($c) && $self->_valid_password($c)) {
		my $name = $c->req->param('name');
		my $email = $c->req->param('email');
		$name =~ s/^\s*(.+)\s*/$1/;
		$email =~ s/^\s*(.+)\s*/$1/;

		eval {
			$user->name($name);
			$user->username(lc($email));
			if (defined($c->req->param('password')) and length($c->req->param('password')) > 0) {
				$user->password($c->req->param('password'));
			}
			# the roles
			my $role = $c->model('LaoFabDB::Role')->find({ role => 'admin' });
			if (defined($c->req->param('admin')) and $c->req->param('admin') eq 'on') {
				$c->model('LaoFabDB::UserRole')->find_or_create({
					user => $user->id,
					role => $role->id,
				});
			} else {
				my $role_rel = $c->model('LaoFabDB::UserRole')->find({
					user => $user->id,
					role => $role->id,
				});
				$role_rel->delete if $role_rel;
			}
			$user->update;
		};
		if ($@) {
			$c->flash->{error} = "Couldn't edit the user, most likely because the email address is already in use by someone else.";
		} else {
			$c->flash->{message} = "The user with email $email has been edited.";
		}
	}
	$c->res->redirect($c->req->referer());#$c->uri_for('/manage'));
}

=head2 edit_info

action for edit userinformation such as name and email/username.

=cut

sub edit_info : Local {
	my ( $self, $c, $u_id ) = @_;
    
     $u_id = $c->user->id unless $u_id;
    
     my $user = $c->model('LaoFabDB::User')->find({ id => $u_id });
    
     unless ($user) {
         $c->flash->{error} = "Could't find a user with user id '$u_id'.";
         $c->res->redirect($c->uri_for('/default'));
         $c->detach;
     }
    
     if (!$self->_valid_email($c)) {
         $c->res->redirect($c->uri_for("/user/view/$u_id"));
         $c->detach;
     }
    
     # update name and email, check unique email (how to?)
     my $new_name = $c->req->param('name');
     my $new_email = $c->req->param('email');
     $new_name =~ s/^\s*(.+)\s*/$1/;
     $new_email =~ s/^\s*(.+)\s*/$1/;
     $user->username(lc($new_email));
     $user->name($new_name);
     eval {
         $user->update();
     };
     if ($@) {
         $c->flash->{error} = "Couldn't update information, most likely because the email address is already in use by someone else.";
     }
    
     $c->flash->{message} = 'Updated user information.';
     $c->res->redirect($c->uri_for("/user/view/$u_id"));
}

=head2 edit_password

action for updating a password. Used by users (viewers).

=cut

sub edit_password : Local {
	my ( $self, $c, $u_id ) = @_;
    
     $u_id = $c->user->id unless $u_id;
    
     my $user = $c->model('LaoFabDB::User')->find({ id => $u_id });
    
     unless ($user) {
         $c->flash->{error} = "Could't find a user with user id '$u_id'.";
         $c->res->redirect($c->uri_for('/default'));
         $c->detach;
     }
    
     if (!$self->_valid_password($c)) {
         $c->res->redirect($c->uri_for("/user/view/$u_id"));
         $c->detach;
     }
    
     $user->password($c->req->param('password'));
     $user->update;
     $c->flash->{message} = 'Password updated!';
     $c->res->redirect($c->uri_for("/user/view/$u_id"));
}

=head1 AUTHOR

Joakim Lagerqvist

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
