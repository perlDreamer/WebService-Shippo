use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../lib";
use TestHarness;
use WebService::Shippo ':all';

my @tests = (
    setup => sub {
        Shippo::Rate->TIMEOUT( 30 );
        is( Shippo::Rate->TIMEOUT, 30, __TEST__ );
        Shippo::Rate->TIMEOUT( 20 );
        is( Shippo::Rate->TIMEOUT, 20, __TEST__ );
    },
);

SKIP: {
    skip '(no Shippo API key defined)', 1
        unless Shippo->api_key;
    TestHarness->run_tests( \@tests );
}

done_testing();
