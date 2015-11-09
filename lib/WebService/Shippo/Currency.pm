use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Currency;
use Carp ( 'confess' );
use Locale::Currency (); # I cannot get these modules to play nicely on ALL versions of Perl
use Locale::Codes ();    # and even now Perl 5.14 is a problem so I intend to stop using them
                         # very shortly because they're not nice to use.

{
    my @codes = Locale::Codes::_all_codes('currency');
    my %codes = map { $_ => Locale::Codes::_code2name( 'currency', $_ ) || '' } @codes;

    sub validate_currency
    {
        my ( $invocant, $currency_code ) = @_;
        my $k = uc( $currency_code );
        confess "Invalid currency code ($currency_code)"
            unless exists( $codes{$k} );
        return ( uc( $currency_code ), $codes{$k} )
            if wantarray;
        return uc( $currency_code );
    }
}

BEGIN {
    no warnings 'once';
    *Shippo::Currency:: = *WebService::Shippo::Currency::;
}

1;
