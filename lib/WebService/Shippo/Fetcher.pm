use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Fetcher;
require WebService::Shippo::Request;

sub get
{
    my ( $self, $id, $params ) = @_;
    my $response = Shippo::Request->get( $self->url( $id ), $params );
    return $self->construct_from( $response );
}

1;
