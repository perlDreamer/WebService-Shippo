use strict;
use warnings;

package TestHarness;
use Carp ( 'croak' );
use Data::Dumper::Concise;
use base ( 'Exporter' );

our @EXPORT = ( '__TEST__', 'run_tests', 'Dumper' );
our $__TEST__ = undef;

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
    my ( @tests ) = @_;
    @tests = @{ $tests[0] }
        if ref( $tests[0] ) && ref( $tests[0] ) =~ /^ARRAY$/;
    croak 'Unexpected ' . ref( $tests[0] ) . ' reference'
        if ref( $tests[0] );
    croak 'Odd number of elements in test array'
        if @tests % 2;
    local $__TEST__;
    while ( @tests ) {
        $__TEST__ = shift @tests;
        my $code = shift @tests;
        $code->();
    }
    return;
}

1;
