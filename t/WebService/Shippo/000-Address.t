use strict;
use warnings;
use Test::More;
use Test::Deep;
use Data::Dumper::Concise;

use_ok( 'WebService::Shippo' );

sub test_valid_create
{
    my $address = get_default_address();
    is( $address->object_state, 'VALID' );
}

sub test_invalid_create
{
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
    is( $address->object_state, 'INCOMPLETE' );
}

sub test_get
{
    my $address          = get_default_address();
    my $retrieve_address = Shippo::Address->get( $address->object_id );
    is( $retrieve_address->object_id, $address->object_id );
}

sub test_retrieve
{
    my $address          = get_default_address();
    my $retrieve_address = Shippo::Address->retrieve( $address->object_id );
    is( $retrieve_address->object_id, $address->object_id );
}

sub test_invalid_get
{
    my $address = get_default_address();
    my $retrieve_address
        = eval { Shippo::Address->get( 'Invalid value is invalid' ) };
    like( $@, qr/404 NOT FOUND/i );
}

sub test_list_all
{
    my $list = Shippo::Address->all(
        { 'results' => 3,
          'page'    => 1
        }
    );
    diag $list;
}

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

test_valid_create();
test_invalid_create();
test_get();
test_retrieve();
test_invalid_get();
test_list_all();

done_testing();
