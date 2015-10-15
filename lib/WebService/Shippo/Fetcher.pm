use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Fetcher;
require WebService::Shippo::Request;

sub get
{
    my ( $self, $object_id, $params ) = @_;
    my $url = $self->url($object_id);
    my $response = WebService::Shippo::Request->get( $url, $params );
    return $self->construct_from( $response );
}

1;
