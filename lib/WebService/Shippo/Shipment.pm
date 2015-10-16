use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Shipment;
use Carp ( 'croak' );
use Locale::Codes::Currency;
use namespace::clean;
use base ( 'WebService::Shippo::Creator',
           'WebService::Shippo::Fetcher',
           'WebService::Shippo::Lister',
           'WebService::Shippo::CurrencyAware',
           'WebService::Shippo::Resource',
);

sub api_resource {'shipments'}

sub rates
{
    my ( $invocant, $id, $currency, $params ) = @_;
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
    my $response = Shippo::Request->get( $url, $params );
    return $invocant->construct_from( $response );
}

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Shipment:: = *WebService::Shippo::Shipment::;
}

1;
