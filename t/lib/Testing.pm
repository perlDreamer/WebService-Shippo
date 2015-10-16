use strict;
use warnings;

package Testing;
use base ( 'Exporter' );

our @EXPORT    = ( '__TEST__' );
our @EXPORT_OK = ();
our $__TEST__;

sub __TEST__ { $__TEST__ . ' ' . join( '', @_ ) }

sub run
{
    my ( undef, $tests ) = @_;
    return unless ref( $tests );
    my @tests = @{$tests};
    while ( @tests ) {
        local $__TEST__ = shift @tests;
        my $code = shift @tests;
        $code->();
    }
    return;
}

1;
