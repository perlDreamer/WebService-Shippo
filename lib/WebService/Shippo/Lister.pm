use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Lister;
require WebService::Shippo::Request;
use Params::Callbacks ( 'callbacks' );

sub first_page
{
    my ( $callbacks, $invocant, @params ) = &callbacks;
    my $response = WebService::Shippo::Request->get( $invocant->url, @params );
    return $invocant->construct_from( $response, $callbacks );
}

sub all
{
    my ( $callbacks, $invocant, %params ) = &callbacks;
    my $response;
    unless ( $params{results} ) {
        $response = WebService::Shippo::Request->get( $invocant->url, results => 1 );
        $params{results} = $invocant->construct_from( $response )->count;
        $params{results} = 3
            unless $params{results};
    }
    $response = WebService::Shippo::Request->get( $invocant->url, %params );
    return $invocant->construct_from( $response, $callbacks );
}

sub list_class
{
    my ( $invocant ) = @_;
    return ( ref( $invocant ) || $invocant ) . 'List';
}

1;
