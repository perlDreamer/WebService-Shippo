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
        my ( $invocant, $response ) = @_;
        my $ref_type = ref( $response );
        return $ref_type
            unless defined $ref_type;
        if ( $ref_type eq 'HASH' ) {
            my $invocant = $invocant->new( $response->{object_id} );
            $invocant->refresh_from( $response );
            if ( exists( $invocant->{count} ) && exists( $invocant->{results} ) ) {
                my $item_class = $invocant->class;
                for my $thing ( @{ $invocant->{results} } ) {
                    bless $thing, $item_class;
                }
                bless $invocant, $invocant->list_class;
            }
            return $invocant;
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

{
    my $value = 0;

    sub PRETTY
    {
        my ( $class, $new_value ) = @_;
        return $value unless @_ > 1;
        $value = $new_value;
        return $class;
    }
}

sub refresh_from
{
    my ( $invocant, $hash ) = @_;
    @{$invocant}{ keys %$hash } = values %$hash;
    return $invocant;
}

{
    my $json = JSON::XS->new->utf8->canonical->convert_blessed->allow_blessed;

    # Note to non-Perl hackers:
    # Not having to unpack "@_" array gives slight speed boost, since it
    # is possible that we might be creating many JSON strings in rapid
    # succession. That weird looking "$_[0]" in the "TO_JSON", "to_json",
    # and "to_string" methods is the first element of the "@_" array, i.e.
    # the first argument passed to the method (the object itself).
    #
    # Required by JSON::XS because we use the convert_blessed encoding
    # modifier to allow blessed references (aka Perl object instances)
    # to be serialized. Returns a scalar value that can be serialized
    # as JSON (essentially an unblessed shallow copy of the original
    # object).
    #
    sub TO_JSON
    {
        return { %{ $_[0] } };
    }

    # Serializes the object to a JSON string.
    sub to_json
    {
        $json->pretty
            if PRETTY;
        return $json->encode( $_[0] );
    }

    # Also, serializes the object to a JSON string. This method will be
    # called whenever the object is treated as a string, courtesy of the
    # overload at the top of this module.
    sub to_string
    {
        $json->pretty
            if PRETTY;
        return $json->encode( $_[0] );
    }
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

sub c_time
{
    my ( $invocant ) = @_;
    return undef unless exists $invocant->{object_created};
    return $invocant->{object_created};
}

sub u_time
{
    my ( $invocant ) = @_;
    return undef unless exists $invocant->{object_updated};
    return $invocant->{object_updated};
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

sub is_valid
{
    my ( $invocant ) = @_;
    return undef unless exists $invocant->{object_state};
    return $invocant->{object_state} && $invocant->{object_state} eq 'VALID';
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
            my ( $invocant, $new_value ) = @_;
            unless ( @_ > 1 ) {
                if ( wantarray && ref( $invocant->{$method} ) ) {
                    return %{ $invocant->{$method} }
                        if reftype( $invocant->{$method} ) eq 'HASH';
                    return @{ $invocant->{$method} }
                        if reftype( $invocant->{$method} ) eq 'ARRAY';
                }
                return $invocant->{$method};
            }
            $invocant->{$method} = $new_value;
            return $invocant;
        }
    );
    goto &$sym;
}

1;
