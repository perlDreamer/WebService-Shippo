use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::ObjectList;
use base ( 'WebService::Shippo::Object' );

sub item_count
{
    my ( $self ) = @_;
    return $self->{count};
}

sub page_size
{
    my ( $self ) = @_;
    return scalar( @{ $self->{results} } );
}

sub next_page
{
    my ( $self ) = @_;
    return unless defined( $self->{next} );
    my $response = WebService::Shippo::Request->get( $self->{next} );
    return $self->construct_from( $response );
}

sub plus_next_pages
{
    my ( $self ) = @_;
    return $self unless defined( $self->{next} );
    my $current = $self;
    while ( defined( $current->{next} ) ) {
        my $r = WebService::Shippo::Request->get( $current->{next} );
        $current = $self->construct_from( $r );
        push @{ $self->{results} }, @{ $current->{results} };
    }
    undef $self->{next};
    return $self;
}

sub previous_page
{
    my ( $self ) = @_;
    return unless defined( $self->{previous} );
    my $response = WebService::Shippo::Request->get( $self->{previous} );
    return $self->construct_from( $response );
}

sub plus_previous_pages
{
    my ( $self ) = @_;
    return $self unless defined( $self->{previous} );
    my $current = $self;
    while ( defined( $current->{previous} ) ) {
        my $r = WebService::Shippo::Request->get( $current->{previous} );
        $current = $self->construct_from( $r );
        unshift @{ $self->{results} }, @{ $current->{results} };
    }
    undef $self->{previous};
    return $self;
}

sub items
{
    my ( $self ) = @_;
    return @{ $self->{results} }
        if wantarray;
    return $self->{results};
}

sub item
{
    my ( $self, $number ) = @_;
    return
        unless $number > 0 && $number <= $self->{count};
    return $self->{results}[ $number - 1 ];
}

sub item_at_index
{
    my ( $self, $index ) = @_;
    return $self->{results}[$index];
}

sub item_class
{
    my ( $invocant ) = @_;
    ( my $class_name = ( ref( $invocant ) || $invocant ) ) =~ s/List$//;
    return $class_name;
}

sub list_class
{
   my ( $invocant ) = @_;
   return ref( $invocant ) || $invocant;
}

1;
