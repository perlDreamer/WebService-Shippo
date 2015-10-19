use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use TestHarness;
use Test::More;

use_ok( 'WebService::Shippo' );

my @objects_under_test = (
    'CustomsItem' => {
        create_default_item => \&default_customs_item,
        class               => 'Shippo::CustomsItem',
        object_is_valid     => sub {
            my ( $object ) = @_;
            return $object->is_valid;
        },
    },
    'Manifest' => {
        create_default_item => \&default_manifest,
        class               => 'Shippo::Manifest',
        object_is_valid     => sub {
            my ( $object ) = @_;
            return $object->status eq 'NOTRANSACTIONS';
        },
    },
    'Parcel' => {
        create_default_item => \&default_parcel,
        class               => 'Shippo::Parcel',
        object_is_valid     => sub {
            my ( $object ) = @_;
            return $object->is_valid;
        },
    },
);

my @tests;

while ( @objects_under_test ) {
    my $test_group      = shift @objects_under_test;
    my $config          = shift @objects_under_test;
    my $class           = $config->{class};
    my $object_is_valid = $config->{object_is_valid};
    push @tests, $test_group => [
        testValidCreate => sub {
            stash->{item} = $config->{create_default_item}->();
            my $item = stash->{item};
            ok( defined( $item ), __TEST__ );
            ok( $object_is_valid->($item),  __TEST__ );
        },
        testInvalidCreate => sub {
            my $e;
            try {
                $class->create( invalid_data => 'invalid' );
            }
            catch {
                $e = $_;
            };
            like( $e, qr/400 BAD REQUEST/i, __TEST__ );
        },
        testListAll => sub {
            stash->{list} = $class->all( results => 3, page => 1 );
            my $list = stash->{list};
            ok( defined( $list->count ),   __TEST__ );
            ok( defined( $list->results ), __TEST__ );
        },
        testFetch => sub {
            my $object = stash->{list}{results}[0];
            my $id     = $object->{object_id};
            ok( defined( $id ), __TEST__ );
            my $item = $class->fetch( $id );
            is_deeply( $object, $item, __TEST__ );
        },
        testInvalidFetch => sub {
            my $id = 'Invalid Object Identifier';
            my $exception;
            try {
                $class->fetch( $id );
            }
            catch {
                $exception = $_;
            };
            like( $exception, qr/404 NOT FOUND/i, __TEST__ );
        },
    ];
} ## end while ( @objects_under_test)

sub default_address
{
    Shippo::Address->create( object_purpose => 'QUOTE',
                             name           => 'John Smith',
                             company        => 'Initech',
                             street1        => 'Greene Rd.',
                             street_no      => '6512',
                             street2        => '',
                             city           => 'Woodridge',
                             state          => 'IL',
                             zip            => '60517',
                             country        => 'US',
                             phone          => '123 353 2345',
                             email          => 'jmercouris@iit.com',
                             metadata       => 'Customer ID 234;234'
    );
}

sub default_parcel
{
    Shippo::Parcel->create( length        => '5',
                            width         => '5',
                            height        => '5',
                            distance_unit => 'cm',
                            weight        => '2',
                            mass_unit     => 'lb',
                            template      => '',
                            metadata      => 'Customer ID 123456'
    );
}

sub default_customs_item
{
    Shippo::CustomsItem->create( description    => 'T-Shirt',
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

sub default_manifest
{
    my $address = default_address();
    Shippo::Manifest->create( provider        => 'USPS',
                              submission_date => '2014-05-16T23:59:59Z',
                              address_from    => $address->object_id
    );
}

SKIP: {
    skip '(no Shippo API key defined)', 1
        unless Shippo->api_key;
    TestHarness->run_tests( \@tests );
}

done_testing();
