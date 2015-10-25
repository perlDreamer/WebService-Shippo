use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Currency;
use Carp ( 'confess' );
use Locale::Codes ();

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

1;
