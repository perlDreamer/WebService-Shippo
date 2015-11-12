use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Fetch;
require WebService::Shippo::Request;
use Params::Callbacks ( 'callbacks' );

sub fetch
{
    my ( $callbacks, $invocant, $id, @params ) = &callbacks;
    my $class = $invocant->item_class;
    my $response = Shippo::Request->get( $class->url( $id ), @params );
    return $class->construct_from( $response, $callbacks );
}

sub all
{
    my ( $callbacks, $invocant, @params ) = &callbacks;
    @params = ( {} )
        unless @params;
    my $params = ref( $params[0] ) ? $params[0] : {@params};
    my $class = $invocant->item_class;
    my $response;
    $params->{results} = 200
        unless $params->{results};
    $response = WebService::Shippo::Request->get( $class->url, $params );
    return $class->construct_from( $response, $callbacks );
}

sub iterator
{
    my ( $callbacks, $invocant, @params ) = &callbacks;
    @params = ( {} )
        unless @params;
    my $params = ref( $params[0] ) ? $params[0] : {@params};
    $params->{results} = 200
        unless $params->{results};
    my $collection = $invocant->all( $params );
    my $index      = 0;
    my $iterator   = sub {
        my @results;
        while ( $collection && !@results ) {
            if ( $index == @{ $collection->results } ) {
                $collection = $collection->next_page;
                last unless $collection;
                $index = 0;
            }
            @results = $callbacks->transform( $collection->{results}[ $index++ ] );
        }
        return @results if wantarray;
        return \@results;
    };
    return bless( $iterator, $invocant->collection_class . '::Iterator' );
}

sub collector
{
    my ( $callbacks, $invocant, @params ) = &callbacks;
    @params = ( {} )
        unless @params;
    my $params = ref( $params[0] ) ? $params[0] : {@params};
    $params->{results} = 200
        unless $params->{results};
    my $collection = $invocant->all( $params );
    my $index      = 0;
    my $collector  = sub {
        my @results;
        while ( $collection ) {
            if ( $index == @{ $collection->results } ) {
                $collection = $collection->next_page;
                last unless $collection;
                $index = 0;
            }
            push @results, $callbacks->transform( $collection->{results}[ $index++ ] );
        }
        return @results if wantarray;
        return \@results;
    };
    return bless( $collector, $invocant->collection_class . '::Collector' );
}

BEGIN {
    no warnings 'once';
    *retrieve          = *fetch;
    *Shippo::Fetcher:: = *WebService::Shippo::Fetcher::;
}

1;
