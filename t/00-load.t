use strict;
use warnings;
use Test::More;
use Test::Deep;
use Data::Dumper::Concise;

use_ok( 'WebService::Shippo' );

diag Shippo->api_private_token;
diag Shippo->api_public_token;
diag Shippo->api_key;
diag Shippo::Address->url;
diag Shippo::CustomsItem->url;
diag Shippo::CustomsDeclaration->url;
diag Shippo::Manifest->url;
diag Shippo::Parcel->url;
diag Shippo::Refund->url;
diag Shippo::Shipment->url;
diag Shippo::Transaction->url;
diag Shippo::Rate->url;
diag Shippo::CarrierAccount->url;
my $obj1 = Shippo::Address->new( 'object_id' );
my $obj2 = Shippo::Address->construct_from(
                                      { foo => 1, bar => 2, id => 'object_id' } );
diag Dumper( { obj1 => $obj1, obj2 => $obj2 } );
diag $obj1->to_json;
diag $obj2->to_json;

#diag Shippo::Address->create(
#    { name           => 'Shawn Ippotle',
#      object_purpose => 'QUOTE',
#      company        => 'Shippo',
#      street1        => '215 Clayton St.',
#      street2        => '',
#      city           => 'San Francisco',
#      state          => 'CA',
#      zip            => 94117,
#      country        => 'US',
#      phone          => '+1 555 341 9393',
#      email          => 'shippotle@goshippo.com',
#      is_residential => 1,
#      metadata       => 'Customer ID 123456',
#    }
#)->to_json;
diag Dumper(Shippo::Address->all());
diag Shippo::CarrierAccount->all()->to_json;
diag Shippo::CarrierAccount->get( '25e8c3acf42b46c5833a53d4378db320' )
    ->to_json;
diag Shippo::CarrierAccount->update(
    '25e8c3acf42b46c5833a53d4378db320',
    { test => 1 }
)->to_json;

done_testing;
