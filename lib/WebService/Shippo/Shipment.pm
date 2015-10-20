use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Shipment;
use Carp ( 'croak' );
use Params::Callbacks ( 'callbacks' );
use base ( 'WebService::Shippo::Creator',
           'WebService::Shippo::Fetcher',
           'WebService::Shippo::Lister',
           'WebService::Shippo::CurrencyAware',
           'WebService::Shippo::Resource',
);

sub api_resource {'shipments'}

sub rates
{
    my ( $callbacks, $invocant, $id, $currency, @params ) = &callbacks;
    if ( $currency ) {
        my $validated = $invocant->validate_currency( $currency );
        croak "Invalid currency code ($currency)"
            unless $validated;
        $currency = $validated;
    }
    else {
        $currency ||= 'USD';
    }
    my $url = $invocant->url( "$id/rates/$currency" );
    my $response = Shippo::Request->get( $url, @params );
    return $invocant->construct_from( $response, $callbacks );
}

package    # Hide from PAUSE
    WebService::Shippo::ShipmentList;
use base ( 'WebService::Shippo::ObjectList' );

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Shipment::     = *WebService::Shippo::Shipment::;
    *Shippo::ShipmentList:: = *WebService::Shippo::ShipmentList::;
}

1;
