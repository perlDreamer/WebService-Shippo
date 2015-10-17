use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Object;
require WebService::Shippo::ObjectList;
use Carp         ( 'croak' );
use JSON::XS     ();
use Scalar::Util ( 'blessed', 'reftype' );
use Sub::Util    ( 'set_subname' );
use overload     ( fallback => 1, '""' => 'to_string' );

our $AUTOLOAD;
our $PRETTY;

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
            if ( exists( $self->{count} ) && exists( $self->{results} ) ) {
                my $item_class = $self->class;
                my $list_class = $self->list_class;
                for my $thing ( @{ $self->{results} } ) {
                    bless $thing, $item_class;
                }
                bless $self, $list_class;
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
    my $json = JSON::XS->new->utf8->canonical->convert_blessed;

    # Required by JSON::XS because we use the convert_blessed encoding
    # modifier to allow blessed references (aka Perl object instances)
    # to be serialized. Returns a scalar value that can be serialized
    # as JSON (essentially an unblessed shallow copy of the original
    # object).
    sub TO_JSON { return { %{ $_[0] } } }

    # Serializes the object to a JSON string
    sub to_json
    {
        my ( $self ) = @_;
        $json->pretty
            if $PRETTY;
        return $json->encode( $self );
    }

    # Also, serializes the object to a JSON string. This method will be
    # called whenever the object is treated as a string, courtesy of the
    # overload at the top of this module.
    sub to_string
    {
        my ( $self ) = @_;
        $json->pretty
            if $PRETTY;
        return $json->encode( $self );
    }
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
            my ( $self, $new_value ) = @_;
            unless ( @_ > 1 ) {
                if ( wantarray && ref( $self->{$method} ) ) {
                    return %{ $self->{$method} }
                        if reftype( $self->{$method} ) eq 'HASH';
                    return @{ $self->{$method} }
                        if reftype( $self->{$method} ) eq 'ARRAY';
                }
                return $self->{$method};
            }
            $self->{$method} = $new_value;
            return $self;
        }
    );
    goto &$sym;
}

1;
