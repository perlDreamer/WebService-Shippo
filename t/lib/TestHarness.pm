use strict;
use warnings;

package TestHarness;
use Carp ( 'croak' );
use Data::Dumper::Concise;
use Test::More;
use Try::Tiny;
use boolean ':all';
use base ( 'Exporter' );

#<<<
our @EXPORT = ( qw/
    __TEST__ 
    __STASH__ 
    stash 
    Dumper 
    dump 
    try 
    catch
    finally
    true
    false
    boolean
/ );
#>>>

our $__TEST__  = undef;
our $__STASH__ = undef;

sub dump
{
    Test::More::diag( Dumper( @_ ) );
}

# __TEST__ (LIST_OF_COMMENTS)
# Arguments:
#   LIST_OF_COMMENTS - optional comments, passed as an array.
# Returns:
#   SCALAR - the name of the test being executed, along with any comments.
#
# The run_tests method localises a copy of $__TEST__ and it is in that
# context that the value of $__TEST__ is obtained by the currently running
# test.
#
sub __TEST__
{
    # Return the name of the test if no comments were passed
    return $__TEST__ unless @_;
    # Return the name of the test plus comments
    return $__TEST__ . ': ' . join( '', @_ );
}

sub __STASH__
{
    return $__STASH__ unless @_;
    return $__STASH__->{ $_[0] } unless @_ > 1;
    while ( @_ ) {
        my $key   = shift;
        my $value = shift;
        $__STASH__->{$key} = $value;
    }
    return $__STASH__;
}

# run_tests (LIST_OF_TESTS)
# Arguments:
#   LIST_OF_TESTS - optional tests, passed as an array (or array ref) of
#       key/value pairs. The key being the test's name; the value being
#       a code reference (the test's definition).
# Returns:
#   Nothing.
#
# Carries out the ordered execution of a test sequence.
#
sub run_tests
{
    my ( $invocant, $tests, $root_name, $stash ) = @_;
    my @tests = @{ $tests };
    croak 'Odd number of elements in test array'
        if @tests % 2;
    local $__STASH__ = $stash ? {%$stash} : {};
    local $__TEST__;
    while ( @tests ) {
        my $test_name = shift @tests;
        my $test      = shift @tests;
        $__TEST__ = $root_name ? "$root_name.$test_name" : $test_name;
        if ( ref( $test ) eq 'HASH' ) {
            $test->{setup}->()
                if $test->{setup};
            $invocant->run_tests( $test->{tests}, $__TEST__, $__STASH__ )
                if $test->{tests};
            $test->{teardown}->()
                if $test->{teardown};
        }
        elsif ( ref( $test ) eq 'ARRAY' ) {
            $invocant->run_tests( $test, $__TEST__, $__STASH__ );
        }
        else {
            $test->();
        }
    }
    return $invocant;
}

BEGIN {
    no warnings 'once';
    *stash = *__STASH__;
}
1;
