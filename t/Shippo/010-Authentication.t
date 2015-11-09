use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../lib";
use TestHarness;
use WebService::Shippo;

my $tests = [
    testInvalidCredentials => sub {
        Shippo->api_key( 'Invalid API key' );
        eval { Shippo::Address->create };
        like( $@, qr/401 UNAUTHORIZED/i, __TEST__ );
    },
];

SKIP: {
    skip '(no Shippo API key defined)', 1
        unless Shippo->api_key;
    TestHarness->run_tests( $tests );
}

done_testing();
