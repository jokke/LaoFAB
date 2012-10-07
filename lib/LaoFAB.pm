package LaoFAB;
use Dancer ':syntax';
use Dancer::Plugin::FlashMessage;

use LaoFAB::Search;

our $VERSION = '3.1';

get '/' => sub {
    template 'index';
};

true;
