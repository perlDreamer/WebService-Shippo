use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use TestHarness;
use Test::More;

use_ok( 'WebService::Shippo' );

my $tests = [
    testValidCreate => sub {
        stash->{item} = get_default_manifest();
        my $item = stash->{item};
        ok( defined( $item ), __TEST__ );
        is( $item->status, 'NOTRANSACTIONS', __TEST__ );
    },
    testInvalidCreate => sub {
        my $e;
        try {
            Shippo::Manifest->create( invalid_data => 'invalid' );
        }
        catch {
            $e = $_;
        };
        like( $e, qr/400 BAD REQUEST/i, __TEST__ );
    },
    testListAll => sub {
        stash->{list} = Shippo::Manifest->all( results => 3, page => 1 );
        my $list = stash->{list};
        ok( defined( $list->count ),   __TEST__ );
        ok( defined( $list->results ), __TEST__ );
    },
    testFetch => sub {
        my $object = stash->{list}{results}[0];
        my $id     = $object->{object_id};
        ok( defined( $id ), __TEST__ );
        my $customs_item = Shippo::Manifest->fetch( $id );
        is_deeply( $object, $customs_item, __TEST__ );
    },
    testInvalidFetch => sub {
        my $id = 'Invalid Object Identifier';
        my $exception;
        try {
            Shippo::Manifest->fetch( $id );
        }
        catch {
            $exception = $_;
        };
        like( $exception, qr/404 NOT FOUND/i, __TEST__ );
    },
];

sub get_default_address
{
    return Shippo::Address->create(
        { 'object_purpose' => 'QUOTE',
          'name'           => 'John Smith',
          'company'        => 'Initech',
          'street1'        => 'Greene Rd.',
          'street_no'      => '6512',
          'street2'        => '',
          'city'           => 'Woodridge',
          'state'          => 'IL',
          'zip'            => '60517',
          'country'        => 'US',
          'phone'          => '123 353 2345',
          'email'          => 'jmercouris@iit.com',
          'metadata'       => 'Customer ID 234;234'
        }
    );
}

sub get_default_manifest
{
    my $address = get_default_address();
    return Shippo::Manifest->create( provider        => 'USPS',
                                     submission_date => '2014-05-16T23:59:59Z',
                                     address_from    => $address->object_id
    );
}

SKIP: {
    skip '(no Shippo API key defined)', 1
        unless Shippo->api_key;
    TestHarness->run_tests( $tests );
}

done_testing();
