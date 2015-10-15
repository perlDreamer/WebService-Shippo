use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Lister;
require WebService::Shippo::Request;

sub all
{
    my ( $self, $params ) = @_;
    my $response = Shippo::Request->get( $self->url, $params );
    return $self->construct_from( $response );
}

1;
