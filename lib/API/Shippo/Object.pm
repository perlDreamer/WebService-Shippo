use strict;
use warnings;
use MRO::Compat 'c3';

package API::Shippo::Object;
use Scalar::Util ( 'blessed' );
use Clone        ( 'clone' );
use namespace::clean;

sub new
{
    my ( $class, $id, $api_key, %params ) = @_;
    $class = ref( $class ) || $class;
    my $self = { api_key => $api_key };
    $self->{object_id} = $id
        if $id;
    delete $params{api_key}
        if exists $params{api_key};
    delete $params{object_id}
        if exists $params{object_id};
    @$self{ keys( %params ) } = values( %params );
    bless $self, $class;
}

sub new_from_hash
{
    my ( $class, $hash, $api_key ) = @_;
    return $class->new( $hash->{object_id}, $api_key || $hash->{api_key},
                        %$hash );
}

sub request
{
    my ( $self, $method, $url, %params ) = @_;
    my $requestor = API::Shippo::Requestor->new($self->api_key);
    my ( $response, $api_key ) = $requestor->request( $method, $url, %params );
    return $self->_convert_to_shippo_object( $response, $api_key );
}

sub _convert_to_shippo_object
{
    my ( $class, $response, $api_key ) = @_;
    $class = ref( $class ) || $class;
    return [ map { $class->_convert_to_shippo_object( $_, $api_key ) }
             @$response ]
        if ref( $response ) && ref( $response ) eq 'ARRAY';
    return $class->new_from_hash( $response, $api_key )
        if ref( $response ) && ref( $response ) eq 'HASH';
    return $response;
}

1;
