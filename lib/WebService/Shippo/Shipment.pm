use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Shipment;
require WebService::Shippo::Rate;
use Carp              ( 'croak' );
use Params::Callbacks ( 'callbacks', 'callback' );
use Scalar::Util      ( 'blessed' );
use base (
    'WebService::Shippo::Resource',
    'WebService::Shippo::Creator',
    'WebService::Shippo::Fetcher',
    'WebService::Shippo::Lister',
    'WebService::Shippo::Currency',
    'WebService::Shippo::Async',
);

sub api_resource { 'shipments' }

sub request_get_shipping_rates
{
    my ( $callbacks, $invocant, $shipment_id, @params ) = &callbacks;
    croak "Expected a shipment id"
        unless $shipment_id;
    my $currency;
    if ( @params && @params % 2 ) {
        ( $currency, @params ) = @params;
        $currency = $invocant->validate_currency( $currency );
    }
    my $rates_url = "$shipment_id/rates";
    $rates_url .= "/$currency"
        if $currency;
    $rates_url = $invocant->url( $rates_url );
    my $response = WebService::Shippo::Request->get( $rates_url, @params );
    unshift @$callbacks, callback {
        return unless @_;
        return $_[0] unless defined $_[0];
        return bless( $_[0], 'WebService::Shippo::Rate' );
    };
    my $rates = $invocant->construct_from( $response, $callbacks );
    bless $rates, WebService::Shippo::Rate->list_class;
    return $rates;
}

sub get_shipping_rates
{
    my ( $callbacks, $invocant, $shipment_id, @params ) = &callbacks;
    my $shipment;
    if (   blessed( $invocant )
        && $invocant->id
        && $invocant->id eq $shipment_id )
    {
        $shipment = $invocant;
    }
    else {
        $shipment = WebService::Shippo::Shipment->fetch( $shipment_id );
    }
    &request_get_shipping_rates;
    $shipment->wait_while_status_in( 'QUEUED', 'WAITING' );
    return &request_get_shipping_rates;
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
    *rates                  = *get_shipping_rates;
}

1;
