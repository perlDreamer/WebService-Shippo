use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use TestHarness;
use Test::More;

use_ok( 'WebService::Shippo' );

my $tests = [
    testListAll => sub {
        ok( 1, __TEST__ );
    },
];

SKIP: {
    skip '(no Shippo API key defined)', 1
        unless Shippo->api_key;
    run_tests( $tests );
}

done_testing();
