use strict;
use warnings;
use MRO::Compat 'c3';

package API::Shippo::Requestor;

sub new
{
    my ( $class, $api_key, $client ) = @_;
    $class = ref( $class ) || $class;
    my $self = { api_key => $api_key };
    bless $self, $class;
}

1;
