use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Lister;
require WebService::Shippo::Request;

sub all
{
    my ( $invocant, $params ) = @_;
    my $response = WebService::Shippo::Request->get( $invocant->url, $params );
    return $invocant->construct_from( $response );
}

sub all_pages
{
    my ( $invocant, $params ) = @_;
    my $response = WebService::Shippo::Request->get( $invocant->url, $params );
    return $invocant->construct_from( $response )->plus_next_pages;
}

1;
