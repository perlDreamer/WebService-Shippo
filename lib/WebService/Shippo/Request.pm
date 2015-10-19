use strict;
use warnings;

package WebService::Shippo::Request;
use Carp        ( 'confess' );
use JSON::XS    ();
use LWP         ();
use Clone       ( 'clone' );
use URI::Encode ( 'uri_encode' );

{
    my $value = { 'Content-Type' => 'application/json',
                  'Accept'       => 'application/json',
    };

    sub headers { wantarray ? %$value : $value }
}

{
    my $value = undef;

    sub user_agent
    {
        my ( $class, $new_value ) = @_;
        return $value unless @_ > 1;
        $value = $new_value;
        if ( $value->can( 'agent' ) ) {
            my $prod = 'Shippo/';
            $prod .= WebService::Shippo::Resource->DEFAULT_API_VERSION;
            $prod .= " WebService\::Shippo/$WebService::Shippo::VERSION";
            $prod .= ' ' . $value->_agent
                if $value->can( '_agent' );
            $value->agent( $prod );
            headers->{'X-Shippo-Client-User-Agent'} = $value->agent;
        }
        return $class;
    }
}

sub query_string
{
    my ( $invocant, $params ) = @_;
    return ''
        unless ref( $params );
    my @pairs;
    while ( my ( $k, $v ) = each %$params ) {
        $k = uri_encode( $k );
        $v = uri_encode( $v );
        push @pairs, join( '=', $k, $v );
    }
    return ''
        unless @pairs;
    return '?' . join( ';', @pairs );
}

{
    my $json          = JSON::XS->new->utf8;
    my $last_response = undef;

    sub get
    {
        my ( $invocant, $url, $params ) = @_;
        $params = {}
            unless defined $params;
        $url .= $invocant->query_string( $params );
        my $response = user_agent->get( $url, headers );
        $_ = $last_response = clone( $response );
        confess $response->status_line
            unless $response->is_success;
        return $response;
    }

    sub put
    {
        my ( $invocant, $url, $params ) = @_;
        $params = {}
            unless defined $params;
        my $payload = $json->encode( {%$params} );
        my $response = user_agent->put( $url, headers, Content => $payload );
        $_ = $last_response = clone( $response );
        confess $response->status_line
            unless $response->is_success;
        return $response;
    }

    sub post
    {
        my ( $invocant, $url, $params ) = @_;
        $params = {}
            unless defined $params;
        my $payload = $json->encode( {%$params} );
        my $response = user_agent->post( $url, headers, Content => $payload );
        $_ = $last_response = clone( $response );
        confess $response->status_line
            unless $response->is_success;
        return $response;
    }

    sub response
    {
        return $last_response;
    }
}

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Request:: = *WebService::Shippo::Request::;
}

# Init the user_agent attribute, and all that entails...
__PACKAGE__->user_agent( LWP::UserAgent->new );

1;
