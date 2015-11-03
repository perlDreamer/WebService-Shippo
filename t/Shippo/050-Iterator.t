use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../lib";
use TestHarness;
use WebService::Shippo ':all';

my @tests = (
    testIterator => sub {
        my $it = Shippo::Address->iterator( results => 3 );
        for ( my $i = 0; $i < 6; $i++ ) {
            my $address = $it->();
            ok( $address->object_id, __TEST__ );
        }
    },
);

SKIP: {
    skip '(no Shippo API key defined)', 1
        unless Shippo->api_key;
    TestHarness->run_tests( \@tests );
}

done_testing();
