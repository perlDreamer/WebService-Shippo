use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Object;
use JSON::XS ();
use Scalar::Util ( 'blessed', 'reftype' );
use namespace::clean;
use constant JSON => JSON::XS->new->utf8->indent->pretty->canonical;

sub new
{
    my ( $class, $id ) = @_;
    my $self = bless( {}, ref( $class ) || $class );
    $id = $id->{object_id}
        if ref( $id ) && reftype( $id ) eq 'HASH';
    $self->{object_id} = $id
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
        my $self = $invocant->new( $ref->{object_id} );
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

sub to_json
{
    my ( $self ) = @_;
    return JSON->encode( {%$self} );
}

1;
