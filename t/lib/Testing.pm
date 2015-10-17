use strict;
use warnings;

package Testing;
use base ( 'Exporter' );

our @EXPORT    = ( '__TEST__' );
our @EXPORT_OK = ();
our $__TEST__;

sub __TEST__
{
    return $__TEST__ unless @_;
    return $__TEST__ . ': ' . join( '', @_ );
}

sub run_tests
{
    my ( undef, @tests ) = @_;
    return unless ref( $tests[0] ) || ( @tests % 2 == 0 );
    @tests = @{ $tests[0] } if ref( $tests[0] );
    while ( @tests ) {
        local $__TEST__ = shift @tests;
        my $code = shift @tests;
        $code->();
    }
    return;
}

1;
