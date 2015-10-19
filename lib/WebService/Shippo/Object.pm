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
            my $self = $invocant->new( $response->{object_id} );
            $self->refresh_from( $response );
            if ( exists( $self->{count} ) && exists( $self->{results} ) ) {
                my $item_class = $self->class;
                for my $thing ( @{ $self->{results} } ) {
                    bless $thing, $item_class;
                }
                bless $self, $self->list_class;
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
    my ( $self, $hash ) = @_;
    @{$self}{ keys %$hash } = values %$hash;
    return $self;
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
    my ( $self ) = @_;
    return exists( $self->{object_id} ) ? $self->{object_id} : undef;
}

sub owner
{
    my ( $self ) = @_;
    return exists( $self->{object_owner} ) ? $self->{object_owner} : undef;
}

sub c_time
{
    my ( $self ) = @_;
    return exists( $self->{object_created} ) ? $self->{object_created} : undef;
}

sub u_time
{
    my ( $self ) = @_;
    return exists( $self->{object_updated} ) ? $self->{object_updated} : undef;
}

sub status
{
    my ( $self ) = @_;
    return exists( $self->{object_status} ) ? $self->{object_status} : undef;
}

sub is_valid
{
    my ( $self ) = @_;
    return undef
        unless exists $self->{object_state};
    return $self->{object_state} && $self->{object_state} eq 'VALID';
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
