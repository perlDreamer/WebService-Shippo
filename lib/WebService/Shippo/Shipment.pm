use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Shipment;
use Carp              ( 'croak' );
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
    my $response;
    if ( $id ) {
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
        $response = Shippo::Request->get( $url, @params );
    }
    else {
        # If no object id is presented, we need to treat the invocant as a
        # well-formed shipment with a valid rate_url or all bets are off!
        croak 'Expected an object id or a well-formed object with rate_url'
            unless exists( $invocant->{rate_url} ) && $invocant->{rate_url};
        $response = Shippo::Request->get( $invocant->{rates_url} );
    }
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
