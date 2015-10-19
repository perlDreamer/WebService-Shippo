use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use TestHarness;
use Test::More;

use_ok( 'WebService::Shippo' );

my $tests = [
    setup => sub {
        Shippo->PRETTY( 1 );
        stash->{list} = Shippo::CarrierAccount->all;
    },
    testListAll => sub {
        my $list = stash->{list};
        ok( defined( $list->count ),   __TEST__ );
        ok( defined( $list->results ), __TEST__ );
    },
    testFetch => sub {
        my $object = stash->{list}{results}[0];
        my $id     = $object->{object_id};
        ok( defined( $id ), __TEST__ );
        my $carrier_account = Shippo::CarrierAccount->fetch( $id );
        is_deeply( $object, $carrier_account, __TEST__ );
    },
    testInvalidFetch => sub {
        my $id = 'Invalid Object Identifier';
        my $exception;
        try { Shippo::CarrierAccount->fetch( $id ) } catch { $exception = $_ };
        like( $exception, qr/404 NOT FOUND/i, __TEST__ );
    },
    testCreate => sub {
        stash->{test_account} = create_test_account();
        my $carrier_account = stash->{test_account};
        is( $carrier_account->active,  true,    __TEST__ );
        is( $carrier_account->test,    true,    __TEST__ );
        is( $carrier_account->carrier, 'fedex', __TEST__ );
    },
    testUpdate => sub {
        my $carrier_account = stash->{test_account};
        my $updated_account = Shippo::CarrierAccount->update(
            $carrier_account->object_id,
            active => false );
        is( $updated_account->active, false, __TEST__ );
        $updated_account->active( true );
        is( $updated_account->active, true, __TEST__ );
        $updated_account->active( false );
        is( $updated_account->active, false, __TEST__ );
        $updated_account->production( true );
        is( $updated_account->production, true, __TEST__ );
        $updated_account->production( false );
        is( $updated_account->production, false, __TEST__ );
    },
];

sub create_test_account
{
    my ( $account_id ) = @_;
    $account_id = rand() unless $account_id;
    return Shippo::CarrierAccount->create(
        {  carrier    => 'fedex',
           account_id => $account_id,
           active     => true,
           test       => true,
           parameters => { meter => '1234',
           },
        }
    );
}

SKIP: {
    skip '(no Shippo API key defined)', 1
        unless Shippo->api_key;
    TestHarness->run_tests( $tests );
}

done_testing();
