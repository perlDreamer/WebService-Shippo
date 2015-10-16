use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Object;
use Carp         ( 'croak' );
use JSON::XS     ();
use Scalar::Util ( 'blessed', 'reftype' );
use Sub::Util    ( 'set_subname' );
use overload     ( fallback => 1, '""' => 'to_string' );

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

sub rebless
{
    my ( $self, $new_class ) = @_;
    return $self unless ref( $self );
    my $class = $self->class;
    $new_class = ref( $new_class ) || $new_class;
    no strict 'refs';
    push @{"$new_class\::ISA"}, $class
        unless $new_class->isa( $class );
    bless $self, $new_class;
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
        if ( $ref_type eq 'HASH' ) {
            my $self = $invocant->new( $response->{object_id} );
            $self->refresh_from( $response );
            # Rebless as WebService::Shippo::<Thing>List if the response is
            # a list of things. Ensure that WebService::Shippo::<Thing>List
            # is a WebService::Shippo::Object.
            if ( exists( $self->{count} ) && exists( $self->{results} ) ) {
                my $class = $self->class;
                for my $thing ( @{ $self->{results} } ) {
                    # Correctly bless the members of the list
                    bless $thing, $class;
                }
                # Make $self a WebService::Shippo::ListObject
                bless $self, 'WebService::Shippo::ListObject';
                # Now make $self a WebService::Shippo::<Type>List, making
                # that class a subclass of WebService::Shippo::ListObject.
                $self->rebless( $class . 'List' );
            }
            return $self;
        }
        elsif ( $ref_type eq 'ARRAY' ) {
            return [ map { $invocant->construct_from( $_ ) } @$response ];
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
    my $json = JSON::XS->new->utf8->pretty->canonical->convert_blessed;

    # Serializes the object to a JSON string
    sub to_json
    {
        my ( $self ) = @_;
        return $json->encode( $self );
    }

    # Required by JSON::XS because we use the convert_blessed encoding
    # modifier to allow blessed references (aka Perl object instances)
    # to be serialized. Returns a scalar value that can be serialized
    # as JSON (essentially an unblessed shallow copy of the original
    # object).
    sub TO_JSON
    {
        my ( $self ) = @_;
        return { %{$self} };
    }

    sub to_string
    {
        my ( $self ) = @_;
        return $json->encode( $self );
    }
}

sub AUTOLOAD
{
    my ( $invocant, @args ) = @_;
    my $class = ref( $invocant ) || $invocant;
    ( my $method = $AUTOLOAD ) =~ s{^.*\::}{};
    return if $method eq 'DESTROY';
    no strict 'refs';
    my $sym = "$class\::$method";
    *$sym = set_subname(
        $sym => sub {
            my ( $self, $new_value ) = @_;
            return $self->{$method} unless @_ > 1;
            $self->{$method} = $new_value;
            return $self;
        }
    );
    goto &$sym;
}

1;
