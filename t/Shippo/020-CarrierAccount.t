use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use TestHarness;
use Test::More;

use_ok( 'WebService::Shippo' );

my $tests = [
    testListAll => {
        setup => sub {
            my $list = Shippo::CarrierAccount->all;
            diag( $list->to_string );
            ok( defined( $list->{count} ),   __TEST__ );
            ok( defined( $list->{results} ), __TEST__ );
        },
    },
];

SKIP: {
    skip '(no Shippo API key defined)', 1
        unless Shippo->api_key;
    run_tests( $tests );
}

done_testing();
