use strict;
use warnings;
use MRO::Compat 'c3';

package # Hide from PAUSE
    API::Shippo::Requestor;

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
