use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Object;
use Carp              ( 'croak' );
use JSON::XS          ();
use Params::Callbacks ( 'callbacks' );
use Scalar::Util      ( 'blessed', 'reftype' );
use Sub::Util         ( 'set_subname' );
use overload          ( fallback => 1, '""' => 'to_string' );

our $AUTOLOAD;

sub class
{
    my ( $invocant ) = @_;
    return ref( $invocant ) || $invocant;
}

sub new
{
    my ( $invocant, $id ) = @_;
    my $self = bless {}, $invocant->class;
    $id = $id->{object_id}
        if ref( $id ) && reftype( $id ) eq 'HASH';
    $self->{object_id} = $id
        if $id;
    return $self;
}

{
    my $json = JSON::XS->new->utf8->convert_blessed->allow_blessed;

    sub construct_from
    {
        my ( $callbacks, $invocant, $response ) = &callbacks;
        my $ref_type = ref( $response );
        return $ref_type
            unless defined $ref_type;
        if ( $ref_type eq 'HASH' ) {
            my $invocant = $invocant->new( $response->{object_id} );
            $invocant->refresh_from( $response );
            if (   exists( $invocant->{count} )
                && exists( $invocant->{results} ) )
            {
                my $item_class = $invocant->item_class;
                $invocant->{results}
                    = [ map { $callbacks->smart_transform( bless( $_, $item_class ) ) }
                        @{ $invocant->{results} } ];
                return bless( $invocant, $invocant->collection_class );
            }
            else {
                return $callbacks->smart_transform( $invocant );
            }
        }
        else {
            croak $response->status_line
                unless $response->is_success;
            my $content = $response->decoded_content;
            my $hash    = $json->decode( $content );
            return $invocant->construct_from( $hash, $callbacks );
        }
    }
}

sub refresh_from
{
    my ( $invocant, $hash ) = @_;
    @{$invocant}{ keys %$hash } = values %$hash;
    return $invocant;
}

sub refresh
{
    my ( $invocant ) = @_;
    my $url          = $invocant->url( $invocant->{object_id} );
    my $response     = Shippo::Request->get( $url );
    my $update       = $invocant->construct_from( $response );
    return $invocant->refresh_from( $update );
}

sub is_same_object
{
    my ( $invocant, $object_id ) = @_;
    return
        unless defined $object_id;
    return
        unless blessed( $invocant );
    return
        unless reftype( $invocant ) eq 'HASH';
    return
        unless exists $invocant->{object_id};
    return $invocant->{object_id} eq $object_id;
}

{
    my $json = JSON::XS->new->utf8->canonical->convert_blessed->allow_blessed;

    $json->pretty( 0 );

    sub to_json
    {
        my ( $data ) = @_;
        return $json->encode( $data );
    }
}

{
    my $json = JSON::XS->new->utf8->canonical->convert_blessed->allow_blessed;

    $json->pretty( 1 );

    sub to_string
    {
        my ( $data ) = @_;
        return $json->encode( $data );
    }
}

sub TO_JSON
{
    return { %{ $_[0] } };
}

# Just in time creation of mutators for orphaned method calls, to facilitate
# access to object attributes of the same name.
sub AUTOLOAD
{
    my ( $invocant, @args ) = @_;
    my $class = ref( $invocant ) || $invocant;
    ( my $method = $AUTOLOAD ) =~ s{^.*\::}{};
    return
        if $method eq 'DESTROY';
    no strict 'refs';
    my $sym = "$class\::$method";
    *$sym = set_subname(
        $sym => sub {
            my ( $invocant ) = @_;
            return ''
                unless defined $invocant->{$method};
            if ( wantarray && ref( $invocant->{$method} ) ) {
                return %{ $invocant->{$method} }
                    if reftype( $invocant->{$method} ) eq 'HASH';
                return @{ $invocant->{$method} }
                    if reftype( $invocant->{$method} ) eq 'ARRAY';
            }
            return $invocant->{$method};
        }
    );
    goto &$sym;
}

BEGIN {
    no warnings 'once';
    *Shippo::Object:: = *WebService::Shippo::Object::;
}

1;
