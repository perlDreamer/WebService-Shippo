use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use TestHarness;
use Test::More;

use_ok( 'WebService::Shippo' );

my $tests = [
    testValidCreate => sub {
        stash->{item} = get_default_customs_item();
        my $customs_item = stash->{item};
        ok( defined( $customs_item ), __TEST__ );
        ok( $customs_item->is_valid,  __TEST__ );
    },
    testInvalidCreate => sub {
        my $e;
        try {
            Shippo::CustomsItem->create( invalid_data => 'invalid' );
        }
        catch {
            $e = $_;
        };
        like( $e, qr/400 BAD REQUEST/i, __TEST__ );
    },
    testListAll => sub {
        stash->{list} = Shippo::CustomsItem->all( results => 3, page => 1 );
        my $list = stash->{list};
        ok( defined( $list->count ),   __TEST__ );
        ok( defined( $list->results ), __TEST__ );
    },
    testFetch => sub {
        my $object = stash->{list}{results}[0];
        my $id     = $object->{object_id};
        ok( defined( $id ), __TEST__ );
        my $customs_item = Shippo::CustomsItem->fetch( $id );
        is_deeply( $object, $customs_item, __TEST__ );
    },
    testInvalidFetch => sub {
        my $id = 'Invalid Object Identifier';
        my $exception;
        try {
            Shippo::CustomsItem->fetch( $id );
        }
        catch {
            $exception = $_;
        };
        like( $exception, qr/404 NOT FOUND/i, __TEST__ );
    },
];

sub get_default_customs_item
{
    return Shippo::CustomsItem->create( description    => 'T-Shirt',
                                        quantity       => '2',
                                        net_weight     => '400',
                                        mass_unit      => 'g',
                                        value_amount   => '20',
                                        value_currency => 'USD',
                                        tariff_number  => '',
                                        origin_country => 'US',
                                        metadata       => 'Order ID #123123'
    );
}

SKIP: {
    skip '(no Shippo API key defined)', 1
        unless Shippo->api_key;
    TestHarness->run_tests( $tests );
}

done_testing();
