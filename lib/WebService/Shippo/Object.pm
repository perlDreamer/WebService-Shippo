use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Object;
use Carp         ( 'croak' );
use JSON::XS     ();
use Scalar::Util ( 'blessed', 'reftype' );
use namespace::clean;

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

{
    my $json = JSON::XS->new->utf8;

    sub construct_from
    {
        my ( $invocant, $response ) = @_;
        my $ref_type = ref( $response );
        return $ref_type
            unless defined $ref_type;
        if ( $ref_type eq 'ARRAY' ) {
            return [ map { $invocant->construct_from( $_ ) } @$response ];
        }
        elsif ( $ref_type eq 'HASH' ) {
            my $self = $invocant->new( $response->{object_id} );
            return $self->refresh_from( $response );
        }
        elsif ( $response->isa( 'HTTP::Response' ) ) {
            croak $response->status_line
                unless $response->is_success;
            my $content = $response->decoded_content;
            my $hash    = $json->decode( $content );
            return $invocant->construct_from( $hash );
        }
        else {
            return $response;
        }
    }
}

sub refresh_from
{
    my ( $self, $hash ) = @_;
    @{$self}{ keys %$hash } = values %$hash;
    return $self;
}

{
    my $json = JSON::XS->new->utf8->indent->pretty->canonical;

    sub to_json
    {
        my ( $self ) = @_;
        return $json->encode( {%$self} );
    }
}

1;
