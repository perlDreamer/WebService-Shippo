use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Creator;
require WebService::Shippo::Request;

sub create
{
    my ( $self, $params ) = @_;
    my $response = Shippo::Request->post( $self->url, $params );
    return $self->construct_from( $response );
}

1;
