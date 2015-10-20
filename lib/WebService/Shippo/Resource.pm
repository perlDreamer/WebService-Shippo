use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Resource;
require WebService::Shippo::Request;
use Carp        ( 'croak' );
use URI::Encode ( 'uri_encode' );
use base        ( 'WebService::Shippo::Object' );
use constant DEFAULT_API_SCHEME  => 'https';
use constant DEFAULT_API_HOST    => 'api.goshippo.com';
use constant DEFAULT_API_PORT    => '443';
use constant DEFAULT_API_VERSION => 'v1';

{
    my $value = undef;

    sub api_private_token
    {
        my ( $class, $new_value ) = @_;
        return $value unless @_ > 1;
        $value = $new_value;
        return $class;
    }
}

{
    my $value = undef;

    sub api_public_token
    {
        my ( $class, $new_value ) = @_;
        return $value unless @_ > 1;
        $value = $new_value;
        return $class;
    }
}

{
    my $value = undef;

    sub api_key
    {
        my ( $class, $new_value ) = @_;
        return $value unless @_ > 1;
        $value = $new_value;
        Shippo::Request->headers->{Authorization} = "ShippoToken $value"
            if $value;
        return $class;
    }
}

{
    my $value = DEFAULT_API_SCHEME;

    sub api_scheme
    {
        my ( $class, $new_value ) = @_;
        return $value unless @_ > 1;
        $value = ( $new_value || DEFAULT_API_SCHEME );
        return $class;
    }
}

{
    my $value = DEFAULT_API_HOST;

    sub api_host
    {
        my ( $class, $new_value ) = @_;
        return $value unless @_ > 1;
        $value = ( $new_value || DEFAULT_API_HOST );
        return $class;
    }
}

{
    my $value = DEFAULT_API_PORT;

    sub api_port
    {
        my ( $class, $new_value ) = @_;
        return $value unless @_ > 1;
        $value = ( $new_value || DEFAULT_API_PORT );
        return $class;
    }
}

{
    my $value = DEFAULT_API_VERSION;

    sub api_base_path
    {
        my ( $class, $new_value ) = @_;
        return $value unless @_ > 1;
        ( $value = $new_value || DEFAULT_API_VERSION ) =~ s{(^\/*|\/*$)}{};
        return $class;
    }
}

{
    my $value = undef;

    sub api_endpoint
    {
        my ( $class, $new_value ) = @_;
        unless ( @_ > 1 ) {
            unless ( $value ) {
                my $scheme = api_scheme();
                my $port   = api_port();
                my $path   = api_base_path;
                $value = $scheme . '://' . api_host();
                $value .= ':' . $port
                    unless $port && $port eq '443' && $scheme eq 'https';
                $value .= '/';
                $value .= $path . '/'
                    if $path;
            }
            return $value;
        }
        ( $value = $new_value || DEFAULT_API_VERSION ) =~ s{(^\/*|\/*$)}{};
        return $class;
    }
}

sub url
{
    my ( $class, $id ) = @_;
    my $resource = $class->api_resource;
    my $url      = $class->api_endpoint;
    $url .= $resource . '/'
        if $resource;
    $url .= uri_encode( $id ) . '/'
        if @_ > 1 && $id;
    return $url;
}

sub api_resource
{
    croak 'Method not implemented in abstract base class';
}

sub id
{
    my ( $invocant ) = @_;
    return undef unless exists $invocant->{object_id};
    return $invocant->{object_id};
}

sub owner
{
    my ( $invocant ) = @_;
    return undef unless exists $invocant->{object_owner};
    return $invocant->{object_owner};
}

sub created
{
    my ( $invocant ) = @_;
    return undef unless exists $invocant->{object_created};
    return $invocant->{object_created};
}

sub is_valid
{
    my ( $invocant ) = @_;
    return undef unless exists $invocant->{object_state};
    return $invocant->{object_state} && $invocant->{object_state} eq 'VALID';
}

sub purpose
{
    my ( $invocant ) = @_;
    return undef unless exists $invocant->{object_purpose};
    return $invocant->{object_purpose};
}

sub status
{
    my ( $invocant ) = @_;
    return undef unless exists $invocant->{object_status};
    return $invocant->{object_status};
}

sub state
{
    my ( $invocant ) = @_;
    return undef unless exists $invocant->{object_state};
    return $invocant->{object_state};
}

sub updated
{
    my ( $invocant ) = @_;
    return undef unless exists $invocant->{object_updated};
    return $invocant->{object_updated};
}

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Resource:: = *WebService::Shippo::Resource::;
    # Other aliases
    *class_url    = *url;
    *api_protocol = *api_scheme;
}

1;
