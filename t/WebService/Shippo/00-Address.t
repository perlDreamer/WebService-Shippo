use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Testing;
use Test::More;

use_ok( 'WebService::Shippo' );

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

my $tests = [
    testValidCreate => sub {
        my $address = get_default_address();
        is( $address->object_source, 'FULLY_ENTERED', __TEST__ );
        is( $address->object_state,  'VALID',         __TEST__ );
    },
    testValidateAddress => sub {
        my $address   = get_default_address();
        my $validated = Shippo::Address->validate( $address->object_id );
        is( $validated->object_source, 'VALIDATOR', __TEST__ );
        is( $validated->object_state,  'VALID',     __TEST__ );
    },
    testInvalidCreate => sub {
        my $address = Shippo::Address->create(
            { 'street1'   => 'Greene Rd.',
              'street_no' => '6512',
              'street2'   => '',
              'city'      => 'Woodridge',
              'state'     => 'IL',
              'zip'       => '60517',
              'country'   => 'US',
              'phone'     => '123 353 2345',
              'email'     => 'jmercouris@iit.com',
              'metadata'  => 'Customer ID 234;234'
            }
        );
        is( $address->object_state, 'INCOMPLETE', __TEST__ );
    },
    testRetrieve => sub {
        my $address          = get_default_address();
        my $retrieve_address = Shippo::Address->retrieve( $address->object_id );
        is( $retrieve_address->object_id, $address->object_id, __TEST__ );
    },
    testInvalidRetrieve => sub {
        my $address = get_default_address();
        my $retrieve_address
            = eval { Shippo::Address->retrieve( 'Invalid value is invalid' ) };
        like( $@, qr/404 NOT FOUND/i, __TEST__ );
    },
    testGet => sub {
        my $address          = get_default_address();
        my $retrieve_address = Shippo::Address->get( $address->object_id );
        is( $retrieve_address->object_id, $address->object_id, __TEST__ );
    },
    testListAll => sub {
        my $list = Shippo::Address->all(
            { 'results' => 3,
              'page'    => 1
            }
        );
        ok( $list->count,   __TEST__ );
        ok( $list->results, __TEST__ );
    },
    testListPageSize => sub {
        my $page_size = 1;
        my $list = Shippo::Address->all(
            { 'results' => $page_size,
              'page'    => 1
            }
        );
        my $next  = $list->next_page;
        my $first = $next->previous_page;
        is( $list->page_size,  $page_size, __TEST__ );
        is( $next->page_size,  $page_size, __TEST__ );
        is( $first->page_size, $page_size, __TEST__ );
    },
];

SKIP: {
    skip '(no Shippo API key defined)', 1 
        unless Shippo->api_key;
    Testing->run_tests( $tests );
}

done_testing();
