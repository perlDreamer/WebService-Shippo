use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Testing;
use Test::More;

use_ok( 'WebService::Shippo' );

my $tests = [
    testInvalidCredentials => sub {
        Shippo->api_key( 'Invalid API key' );
        eval { Shippo::Address->create() };
        like( $@, qr/401 UNAUTHORIZED/i, __TEST__ );
    },
];

SKIP: {
    skip '(no Shippo API key defined)', 1
        unless Shippo->api_key;
    Testing->run_tests( $tests );
}

done_testing();
