use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Async;
use Carp              ( 'confess' );
use List::Util        ( 'any' );
use Params::Callbacks ( 'callbacks' );
use Time::HiRes       ( 'gettimeofday', 'tv_interval' );

{
    my $value = 60;

    sub timeout
    {
        my ( $invocant, $new_value ) = @_;
        return $value unless @_ > 1;
        $value = $new_value;
        return $invocant;
    }

    sub timeout_exceeded
    {
        my ( $invocant, $tv_start ) = @_;
        return tv_interval( $tv_start ) > $value;
    }
}

sub wait_if_status_in
{
    my ( $callbacks, $invocant, @states ) = &callbacks;
    my $start_time = [ gettimeofday() ];
    my $delay      = 0.5;
    my $backoff    = 0.25;
    while ( !$invocant->timeout_exceeded( $start_time ) ) {
        return $invocant
            unless any { /^$invocant->{object_status}$/ } @states;
        sleep( $delay );
        $delay += $backoff;
        $callbacks->transform( $invocant->refresh );
    }
    confess 'Asynchronus operation timed-out';
}

sub wait_unless_status_in
{
    my ( $callbacks, $invocant, @states ) = &callbacks;
    my $start_time = [ gettimeofday() ];
    my $delay      = 0.5;
    my $backoff    = 0.25;
    while ( !$invocant->timeout_exceeded( $start_time ) ) {
        return $invocant
            if any { /^$invocant->{object_status}$/ } @states;
        sleep( $delay );
        $delay += $backoff;
        $callbacks->transform( $invocant->refresh );
    }
    confess 'Asynchronus operation timed-out';
}

1;
