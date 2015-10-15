use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Updater;
require WebService::Shippo::Request;

sub update
{
    my ( $self, $object_id, $params ) = @_;
    my $url = $self->url($object_id);
    my $response = WebService::Shippo::Request->put( $url, $params );
    return $self->construct_from( $response );
}

1;
