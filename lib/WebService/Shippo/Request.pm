use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Request;
use JSON::XS    ();
use LWP         ();
use URI::Encode ( 'uri_encode' );
use namespace::clean;

{
    my $value = LWP::UserAgent->new;

    sub user_agent
    {
        my ( $class, $new_value ) = @_;
        return $value unless @_ > 1;
        $value = $new_value;
        return $class;
    }
}

{
    my $value = { 'Content-Type' => 'application/json',
                  'Accept'       => 'application/json',
    };

    sub headers { wantarray ? %$value : $value }
}

sub query_string
{
    my ( $invocant, $params ) = @_;
    return ''
        unless ref( $params );
    my @pairs;
    while ( my ( $k, $v ) = each( %$params ) ) {
        $k = uri_encode( $k );
        $v = uri_encode( $v );
        push @pairs, join( '=', $k, $v );
    }
    return ''
        unless @pairs;
    return '?' . join( ';', @pairs );
}

sub get
{
    my ( $invocant, $url, $params ) = @_;
    $url .= $invocant->query_string( $params );
    my $response = user_agent->get( $url, headers );
    return $response;
}

{
    my $json = JSON::XS->new->utf8;

    sub put
    {
        my ( $invocant, $url, $params ) = @_;
        my $payload = $json->encode( {%$params} );
        my $response = user_agent->put( $url, headers, Content => $payload );
        return $response;
    }
}

{
    my $json = JSON::XS->new->utf8;

    sub post
    {
        my ( $invocant, $url, $params ) = @_;
        my $payload = $json->encode( {%$params} );
        my $response = user_agent->post( $url, headers, Content => $payload );
        return $response;
    }
}
1;
