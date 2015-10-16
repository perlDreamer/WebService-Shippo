use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::CurrencyAware;
use Locale::Codes::Currency;

{
    my @codes = all_currency_codes();
    my %codes = map { $_ => code2currency( $_ ) || '' } @codes;

    sub validate_currency
    {
        my ( $invocant, $currency_code ) = @_;
        my $k = lc( $currency_code );
        return
            unless exists( $codes{$k} );
        return ( uc( $currency_code ), $codes{$k} )
            if wantarray;
        return uc( $currency_code );
    }
}

1;
