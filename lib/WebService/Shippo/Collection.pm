use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Collection;
use Params::Callbacks ( 'callbacks' );
use base              ( 'WebService::Shippo::Object' );

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
    my ( $callbacks, $self ) = &callbacks;
    return unless defined $self->{next};
    my $response = WebService::Shippo::Request->get( $self->{next} );
    return $self->item_class->construct_from( $response, $callbacks );
}

sub plus_next_pages
{
    my ( $callbacks, $self ) = &callbacks;
    return $self unless defined $self->{next};
    my $current = $self;
    while ( defined( $current->{next} ) ) {
        my $r = WebService::Shippo::Request->get( $current->{next} );
        $current = $self->item_class->construct_from( $r, $callbacks );
        push @{ $self->{results} }, @{ $current->{results} };
    }
    undef $self->{next};
    return $self;
}

sub previous_page
{
    my ( $callbacks, $self ) = &callbacks;
    return unless defined $self->{previous};
    my $response = WebService::Shippo::Request->get( $self->{previous} );
    return $self->item_class->construct_from( $response, $callbacks );
}

sub plus_previous_pages
{
    my ( $callbacks, $self ) = &callbacks;
    return $self unless defined $self->{previous};
    my $current = $self;
    while ( defined( $current->{previous} ) ) {
        my $r = WebService::Shippo::Request->get( $current->{previous} );
        $current = $self->item_class->construct_from( $r, $callbacks );
        unshift @{ $self->{results} }, @{ $current->{results} };
    }
    undef $self->{previous};
    return $self;
}

sub items
{
    my ( $callbacks, $self ) = &callbacks;
    return $callbacks->transform( @{ $self->{results} } )
        if wantarray;
    return [ $callbacks->transform( @{ $self->{results} } ) ];
}

sub item
{
    my ( $callbacks, $self, $position ) = &callbacks;
    return
        unless $position > 0 && $position <= $self->{count};
    return $callbacks->smart_transform( $self->{results}[ $position - 1 ] );
}

sub item_at_index
{
    my ( $callbacks, $self, $index ) = &callbacks;
    return $callbacks->smart_transform( $self->{results}[$index] );
}

BEGIN {
    no warnings 'once';
    *to_array = *items;
}

1;
