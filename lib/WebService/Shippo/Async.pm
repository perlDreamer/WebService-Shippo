use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Async;
use Carp        ( 'confess' );
use List::Util  ( 'any' );
use Time::HiRes ( 'gettimeofday', 'tv_interval', 'usleep' );

{
    my $value = 20;

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

sub wait_while_status_in
{
    my ( $invocant, @states ) = @_;
    my $start_time = [ gettimeofday() ];
    while ( !$invocant->timeout_exceeded( $start_time ) ) {
        return $invocant
            unless any { /^$invocant->{object_status}$/ } @states;
        usleep( 500 );
        $invocant->refresh;
    }
    confess 'Asynchronus operation timed-out';
}

1;
