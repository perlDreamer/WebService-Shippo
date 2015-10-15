use strict;
use warnings;
use MRO::Compat 'c3';

package # Hide from PAUSE
    API::Shippo::Object;
use Scalar::Util ( 'blessed', 'reftype' );
use namespace::clean;

sub new
{
    my ( $class, $id ) = @_;
    my $self = bless( {}, ref( $class ) || $class );
    $id = $id->{id}
        if ref( $id ) && reftype( $id ) eq 'HASH';
    $self->{id} = $id
        if $id;
    return $self;
}

sub construct_from
{
    my ( $invocant, $ref ) = @_;
    my $ref_type = ref( $ref );
    return $ref_type
        unless defined $ref_type;
    if ( $ref_type eq 'ARRAY' ) {
        return [ map { $invocant->construct_from( $_ ) } @$ref ];
    }
    elsif ( $ref_type eq 'HASH' ) {
        my $self = $invocant->new( $ref->{id} );
        return $self->refresh_from( $ref );
    }
    else {
        return $ref;
    }
}

sub refresh_from
{
    my ( $self, $hash ) = @_;
    @{$self}{ keys( %$hash ) } = values( %$hash );
    return $self;
}

sub request
{
    my ( $self, $method, $url, %params ) = @_;
    my $requestor = API::Shippo::Requestor->new( $self->api_key );
    my ( $response, $api_key ) = $requestor->request( $method, $url, %params );
    return $self->_convert_to_shippo_object( $response, $api_key );
}

1;
