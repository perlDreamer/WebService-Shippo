use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Lister;
require WebService::Shippo::Request;
use Params::Callbacks ( 'callbacks' );

sub all
{
    my ( $callbacks, $invocant, @params ) = &callbacks;
    my $response = WebService::Shippo::Request->get( $invocant->url, @params );
    return $invocant->construct_from( $response, $callbacks );
}

sub all_pages
{
    my ( $callbacks, $invocant, @params ) = &callbacks;
    my $response = WebService::Shippo::Request->get( $invocant->url, @params );
    return $invocant->construct_from( $response, $callbacks )->plus_next_pages;
}

sub list_class
{
    my ( $invocant ) = @_;
    return ( ref( $invocant ) || $invocant ) . 'List';
}

1;
