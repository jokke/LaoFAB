package LaoFab::Model::IMAP;

use base 'Catalyst::Model::Adaptor';

#__PACKAGE__->config( 
#    class => 'Net::IMAP::Client' 
#);

sub mangle_arguments { %{$_[1]} }

1;
