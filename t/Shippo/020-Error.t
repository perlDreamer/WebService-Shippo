use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../lib";
use TestHarness;
use WebService::Shippo;

my $tests = [
    testBadResource => sub {
        eval { Shippo::Request->get( 'https://api.goshippo.com/v1/hello/' ) };
        my $exception = $@;
        ok( $exception, __TEST__ );
        like( $exception, qr/404 NOT FOUND/i, __TEST__ );
    },
];

SKIP: {
    skip '(no Shippo API key defined)', 1
        unless Shippo->api_key;
    TestHarness->run_tests( $tests );
}

done_testing();
