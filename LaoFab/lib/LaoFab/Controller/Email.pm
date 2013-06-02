package LaoFab::Controller::Email;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

LaoFab::Controller::Email - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub view : Local {
    my ( $self, $c, $uuid ) = @_;

    my $mailq = {
        uuid => $uuid,
    };
    my $options = {
        fl    => 'sentDate,subject,content,from,uuid',
        rows  => 1,
        df    => 'uuid',
    };
    my $response = $c->model('SolrMail')->search( $uuid , $options);
    use Data::Dumper;
    $c->log->debug(Dumper($response));
    
    my ($mail) = $response->docs;

    my ($subject, $content, $sentDate, $from) = ("Error: Cannot find email", '', 'n/a', 'n/a');
    if ($mail) {
        $subject = $mail->value_for('subject');
        $content = $mail->value_for('content');
        $sentDate = $mail->value_for('sentDate');
        $from = $mail->value_for('from');

        $sentDate =~ s/T/ /;
        $sentDate =~ s/Z//;
        $subject =~ s/\[laofab\]//gi;
        $subject =~ s/Re:\s*(Re:)/$1/gi;
        $content = _parse_junk($content);
    }

    $c->stash->{subject} = $subject;
    $c->stash->{uuid} = $uuid;
    $c->stash->{email_content} = $content;
    $c->stash->{sentDate} = $sentDate;
    $c->stash->{from} = $from;

    $c->stash->{wrapper} = 'site/layout_minimal';
}

sub _parse_junk {
    my $e = shift;

    $e =~ s/^[A-Za-z\-]+:(.*?)\r\n\r\n//s;
    return $e;
}

=head1 AUTHOR

Joakim Lagerqvist

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
