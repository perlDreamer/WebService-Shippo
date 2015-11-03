use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Fetcher;
require WebService::Shippo::Request;
use Params::Callbacks ( 'callbacks' );

sub fetch
{
    my ( $callbacks, $invocant, $id, @params ) = &callbacks;
    my $response = Shippo::Request->get( $invocant->url( $id ), @params );
    return $invocant->construct_from( $response, $callbacks );
}

sub all
{
    my ( $callbacks, $invocant, @params ) = &callbacks;
    @params = ( {} )
        unless @params;
    my $params = ref( $params[0] ) ? $params[0] : {@params};
    my $response;
    unless ( $params->{results} ) {
        $response = WebService::Shippo::Request->get( $invocant->url, results => 1 );
        $params->{results} = $invocant->construct_from( $response )->count;
        $params->{results} = 3
            unless $params->{results};
    }
    $response = WebService::Shippo::Request->get( $invocant->url, $params );
    return $invocant->construct_from( $response, $callbacks );
}

sub iterator
{
    my ( $callbacks, $invocant, @params ) = &callbacks;
    @params = ( {} )
        unless @params;
    my $params = ref( $params[0] ) ? $params[0] : {@params};
    $params->{results} = 5
        unless $params->{results};
    my $list     = $invocant->all( $params );
    my $index    = 0;
    my $iterator = sub {
        if ( $index == @{ $list->{results} } ) {
            $list = $list->next_page
                or return;
            $index = 0;
        }
        return $callbacks->smart_transform( $list->{results}[ $index++ ] );
    };
    return bless( $iterator, $invocant->list_class . '::Iterator' );
}

sub list_class
{
    my ( $invocant ) = @_;
    return ( ref( $invocant ) || $invocant ) . 'List';
}

1;
