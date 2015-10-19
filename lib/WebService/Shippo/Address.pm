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
    my ( $invocant, $id, @params ) = @_;
    my $url = $invocant->url( "$id/validate" );
    my $response = WebService::Shippo::Request->get( $url, @params );
    return $invocant->construct_from( $response );
}

package    # Hide from PAUSE
    WebService::Shippo::AddressList;
use base ( 'WebService::Shippo::ObjectList' );

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Address::     = *WebService::Shippo::Address::;
    *Shippo::AddressList:: = *WebService::Shippo::AddressList::;
}

1;
