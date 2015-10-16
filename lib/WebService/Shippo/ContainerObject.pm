use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::ContainerObject;
use base ( 'WebService::Shippo::Object' );

sub count
{
    my ( $self ) = @_;
    return $self->{count};
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

1;
