use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Lister;
require WebService::Shippo::Request;
use Params::Callbacks ( 'callbacks' );

sub list
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
    my $list     = $invocant->list( $params );
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

BEGIN {
    no warnings 'once';
    *all = *list;
}

1;
