use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Currency;
use Carp ( 'confess' );
use Locale::Currency;

{
    my @codes = all_currency_codes();
    my %codes = map { $_ => code2currency( $_ ) || '' } @codes;

    sub currency_codes
    {
        return \@codes;
    }

    sub currencies
    {
        return \%codes;
    }

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
