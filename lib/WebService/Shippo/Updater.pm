use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Updater;
require WebService::Shippo::Request;

sub update
{
    my ( $self, $id, $params ) = @_;
    my $response = Shippo::Request->put( $self->url( $id ), $params );
    return $self->construct_from( $response );
}

1;
