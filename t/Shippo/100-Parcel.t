use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use TestHarness;
use Test::More;

use_ok( 'WebService::Shippo' );

my $tests = [
    testValidCreate => sub {
        stash->{item} = get_default_parcel();
        my $item = stash->{item};
        ok( defined( $item ), __TEST__ );
        ok( $item->is_valid,  __TEST__ );
    },
    testInvalidCreate => sub {
        my $e;
        try {
            Shippo::Parcel->create( invalid_data => 'invalid' );
        }
        catch {
            $e = $_;
        };
        like( $e, qr/400 BAD REQUEST/i, __TEST__ );
    },
    testListAll => sub {
        stash->{list} = Shippo::Parcel->all( results => 3, page => 1 );
        my $list = stash->{list};
        ok( defined( $list->count ),   __TEST__ );
        ok( defined( $list->results ), __TEST__ );
    },
    testFetch => sub {
        my $object = stash->{list}{results}[0];
        my $id     = $object->{object_id};
        ok( defined( $id ), __TEST__ );
        my $customs_item = Shippo::Parcel->fetch( $id );
        is_deeply( $object, $customs_item, __TEST__ );
    },
    testInvalidFetch => sub {
        my $id = 'Invalid Object Identifier';
        my $exception;
        try {
            Shippo::Parcel->fetch( $id );
        }
        catch {
            $exception = $_;
        };
        like( $exception, qr/404 NOT FOUND/i, __TEST__ );
    },
];

sub get_default_parcel
{
    return Shippo::Parcel->create( length        => '5',
                                   width         => '5',
                                   height        => '5',
                                   distance_unit => 'cm',
                                   weight        => '2',
                                   mass_unit     => 'lb',
                                   template      => '',
                                   metadata      => 'Customer ID 123456'
    );
}

SKIP: {
    skip '(no Shippo API key defined)', 1
        unless Shippo->api_key;
    TestHarness->run_tests( $tests );
}

done_testing();
