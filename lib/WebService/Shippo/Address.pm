use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Address;
require WebService::Shippo::Request;
use base ( 'WebService::Shippo::Creator',
           'WebService::Shippo::Fetcher',
           'WebService::Shippo::Lister',
           'WebService::Shippo::Resource',
);

sub api_resource {'addresses'}

sub validate
{
    my ( $self, $id, $params ) = @_;
    my $response
        = Shippo::Request->get( $self->url( "$id/validate" ), $params );
    return $self->construct_from( $response );
}

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Address:: = *WebService::Shippo::Address::;
}

1;
