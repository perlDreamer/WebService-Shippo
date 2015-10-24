use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../lib";
use TestHarness;
use WebService::Shippo ':all';

my @tests = (
    testSetRateTimeout => sub {
        Shippo::Async->timeout( 30 );
        is( Shippo::Async->timeout, 30, __TEST__ );
        Shippo::Async->timeout( 20 );
        is( Shippo::Async->timeout, 20, __TEST__ );
    },
    testPretty => sub {
        Shippo->PRETTY( 1 );
        is( Shippo->PRETTY, 1, __TEST__ );
        Shippo->PRETTY( 0 );
        is( Shippo->PRETTY, 0, __TEST__ );
    },
    testCurrency => [
        eur => sub {
            my $val = Shippo::Currency->validate_currency( 'EUR' );
            my @val = Shippo::Currency->validate_currency( 'EUR' );
            is( $val, 'EUR', __TEST__ );
            is_deeply( \@val, [ 'EUR', 'Euro' ], __TEST__ );
        },
        gbp => sub {
            my $val = Shippo::Currency->validate_currency( 'GBP' );
            my @val = Shippo::Currency->validate_currency( 'GBP' );
            is( $val, 'GBP', __TEST__ );
            is_deeply( \@val, [ 'GBP', 'Pound Sterling' ], __TEST__ );
        },
        usd => sub {
            my $val = Shippo::Currency->validate_currency( 'USD' );
            my @val = Shippo::Currency->validate_currency( 'USD' );
            is( $val, 'USD', __TEST__ );
            is_deeply( \@val, [ 'USD', 'US Dollar' ], __TEST__ );
        },
    ]
);

SKIP: {
    skip '(no Shippo API key defined)', 1
        unless Shippo->api_key;
    TestHarness->run_tests( \@tests );
}

done_testing();
