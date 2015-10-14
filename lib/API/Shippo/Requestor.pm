use strict;
use warnings;
use MRO::Compat 'c3';

package API::Shippo::Requestor;
use constant _CERTIFICATE_VERIFIED => 0;

sub new
{
    my ( $class, $api_key, $client ) = @_;
    $class = ref( $class ) || $class;
    my $self = { api_key => $api_key };
    bless $self, $class;
}

sub request
{
    my ($self, $method, $url, %params) = @_;
    
}

1;
