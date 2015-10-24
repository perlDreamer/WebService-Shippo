use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../lib";
use TestHarness;
use WebService::Shippo ':all';

my @tests = (
    testSetRateTimeout => sub {
        Shippo::Async->timeout( 0 );
        is( Shippo::Async->timeout, 0, __TEST__ );
        my $exception;
        my $shipment = Shippo::Shipment->create(
            object_purpose => 'PURCHASE',
            address_from   => Shippo::Address->create(
                'object_purpose' => 'PURCHASE',
                'name'           => 'Shawn Ippotle',
                'company'        => 'Shippo',
                'street1'        => '215 Clayton St.',
                'city'           => 'San Francisco',
                'state'          => 'CA',
                'zip'            => '94117',
                'country'        => 'US',
                'phone'          => '+1 555 341 9393',
                'email'          => 'shippotle@goshippo.com'
            ),
            address_to => Shippo::Address->create(
                'object_purpose' => 'PURCHASE',
                'name'           => 'Mr Hippo"',
                'company'        => '',
                'street1'        => 'Broadway 1',
                'street2'        => '',
                'city'           => 'New York',
                'state'          => 'NY',
                'zip'            => '10007',
                'country'        => 'US',
                'phone'          => '+1 555 341 9393',
                'email'          => 'mrhippo@goshippo.com'
            ),
            parcel => Shippo::Parcel->create(
                'length'        => '5',
                'width'         => '5',
                'height'        => '5',
                'distance_unit' => 'in',
                'weight'        => '2',
                'mass_unit'     => 'lb',
            ),
        );
        try {
            my $rates = $shipment->get_shipping_rates( $shipment->id, 'GBP' );
        }
        catch {
            $exception = $_;
        };
        like( $exception, qr/timed-out/i, __TEST__ );
        Shippo::Async->timeout( 20 );
        is( Shippo::Async->timeout, 20, __TEST__ );
    },
    testpretty => sub {
        Shippo->pretty( 1 );
        is( Shippo->pretty, 1, __TEST__ );
        Shippo->pretty( 0 );
        is( Shippo->pretty, 0, __TEST__ );
    },
    testCurrency => [
        eur => sub {
            my $val = Shippo::Currency->validate_currency( 'EUR' );
            my @val = Shippo::Currency->validate_currency( 'EUR' );
            is( $val, 'EUR', __TEST__ );
            is_deeply( \@val, [ 'EUR', 'Euro' ], __TEST__ );
        },
        gbp => sub {
            my $val = Shippo::Currency->validate_currency( 'GBP' );
            my @val = Shippo::Currency->validate_currency( 'GBP' );
            is( $val, 'GBP', __TEST__ );
            is_deeply( \@val, [ 'GBP', 'Pound Sterling' ], __TEST__ );
        },
        usd => sub {
            my $val = Shippo::Currency->validate_currency( 'USD' );
            my @val = Shippo::Currency->validate_currency( 'USD' );
            is( $val, 'USD', __TEST__ );
            is_deeply( \@val, [ 'USD', 'US Dollar' ], __TEST__ );
        },
    ],
    testConfig => sub {
        my $config_file_before = WebService::Shippo::Config->config_file;
        WebService::Shippo::Config->config_file( '/etc/foo' );
        my $config_file_after = WebService::Shippo::Config->config_file;
        is( $config_file_after, '/etc/foo', __TEST__ );
        WebService::Shippo::Config->config_file( $config_file_before );
        my $config_before = WebService::Shippo::Config->config;
        WebService::Shippo::Config->config( { foo => 'bar', bar => 'baz' } );
        my $config_after = WebService::Shippo::Config->config;
        not_deeply( $config_before, $config_after, __TEST__ );
        WebService::Shippo::Config->reload_config;
        my $config_now = WebService::Shippo::Config->config;
        is_deeply( $config_now, $config_before, __TEST__ );
    },
);

SKIP: {
    skip '(no Shippo API key defined)', 1
        unless Shippo->api_key;
    TestHarness->run_tests( \@tests );
}

done_testing();
