use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Shipment;
require WebService::Shippo::Rate;
use Carp              ( 'croak' );
use Params::Callbacks ( 'callbacks', 'callback' );
use Time::HiRes       ( 'gettimeofday', 'tv_interval', 'usleep' );
use Try::Tiny;
use base ( 'WebService::Shippo::Creator',
           'WebService::Shippo::Fetcher',
           'WebService::Shippo::Lister',
           'WebService::Shippo::CurrencyAware',
           'WebService::Shippo::Resource',
);

sub api_resource {'shipments'}

sub get_shipment_rates
{
    my ( $callbacks, $invocant, $id, $currency, @params ) = &callbacks;
    croak "Expected an object_id"
        unless $id;
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
    my $rates_object;
    my $time = [ gettimeofday() ];
    my $exception;
    while ( !$rates_object ) {
        try {
            my $response = Shippo::Request->get( $url, @params );
            $rates_object = $invocant->construct_from( $response, $callbacks );
        }
        catch {
            $exception = $_;
            usleep( 500 );
        };
        if ( $rates_object ) {
            undef $exception;
            last;
        }
        last if tv_interval( $time ) > WebService::Shippo::Rate->TIMEOUT;
    }
    croak $exception
        if $exception;
    return $rates_object;
}

sub rates
{
    my ( $callbacks, $invocant, @params ) = &callbacks;
    croak "Shipment has no rates_url"
        unless exists( $invocant->{rates_url} ) && $invocant->{rates_url};
    my $response = Shippo::Request->get( $invocant->{rates_url} );
    # Ok, prepend a callback to the callback queue ($callbacks), which will
    # rebless our WebService::Shippo::Shipment objects (yes, that's what
    # we got) as WebService::Shippo::Rate objects. This is much closer
    # to the truth. The newly introduced callback stage will safely return
    # an empty list or undef if either of those was passed.
    unshift @$callbacks, callback {
        return unless @_;
        return $_[0] unless defined $_[0];
        return bless( $_[0], 'WebService::Shippo::Rate' );
    };
    # And let's be sure to return whatever a collection of Rates is.
    my $list = $invocant->construct_from( $response, $callbacks );
    return bless( $list, WebService::Shippo::Rate->list_class );
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
