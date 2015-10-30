use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Address;
require WebService::Shippo::Request;
use Carp              ( 'confess' );
use Params::Callbacks ( 'callbacks' );
use Scalar::Util      ( 'blessed' );
use base (
    'WebService::Shippo::Resource',
    'WebService::Shippo::Creator',
    'WebService::Shippo::Fetcher',
    'WebService::Shippo::Lister',

);

sub api_resource { 'addresses' }

sub validate
{
    my ( $callbacks, $invocant, $object_id, @params ) = &callbacks;
    $object_id = $invocant->{object_id}
        if blessed( $invocant ) && !$object_id;
    confess 'Expected an object id'
        unless $object_id;
    my $url = $invocant->url( "$object_id/validate" );
    my $response = WebService::Shippo::Request->get( $url, @params );
    my $upd = $invocant->construct_from( $response, $callbacks );
    return $upd
        unless blessed( $invocant ) && $invocant->id eq $object_id;
    $invocant->refresh_from( $upd );
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
