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
    unless ( $params->{results} ) {
        $response = WebService::Shippo::Request->get( $class->url, results => 1 );
        $params->{results} = $class->construct_from( $response )->count;
        $params->{results} = 3
            unless $params->{results};
    }
    $response = WebService::Shippo::Request->get( $class->url, $params );
    return $class->construct_from( $response, $callbacks );
}

sub iterate
{
    my ( $callbacks, $invocant, @params ) = &callbacks;
    @params = ( {} )
        unless @params;
    my $params = ref( $params[0] ) ? $params[0] : {@params};
    $params->{results} = 5
        unless $params->{results};
    my $collection = $invocant->all( $params );
    my $index      = 0;
    my $iterator   = sub {
        if ( $index == @{ $collection->results } ) {
            $collection = $collection->next_page;
            return unless $collection;
            $index = 0;
        }
        return $callbacks->smart_transform( $collection->{results}[ $index++ ] );
    };
    return bless( $iterator, $invocant->collection_class . '::Iterator' );
}

BEGIN {
    no warnings 'once';
    *retrieve = *fetch;
    *Shippo::Fetcher:: = *WebService::Shippo::Fetcher::;
}

1;
