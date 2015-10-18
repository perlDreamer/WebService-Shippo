use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use TestHarness;
use Test::More;

use_ok( 'WebService::Shippo' );

my $tests = [
    testBadResource => sub {
        eval { Shippo::Request->get( 'https://api.goshippo.com/v1/hello/' ) };
        ok( !$@,              __TEST__ );
        ok( Shippo->response, __TEST__ );
        like( Shippo->response->status_line, qr/404 NOT FOUND/i, __TEST__ );
    },
];

SKIP: {
    skip '(no Shippo API key defined)', 1
        unless Shippo->api_key;
    run_tests( $tests );
}

done_testing();
