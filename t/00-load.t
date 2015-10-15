use strict;
use warnings;
use Test::More;
use Test::Deep;
use Data::Dumper::Concise;

use_ok( 'API::Shippo' );

diag API::Shippo::Address->api_url;
diag API::Shippo::CustomsItem->api_url;
diag API::Shippo::CustomsDeclaration->api_url;
diag API::Shippo::Manifest->api_url;
diag API::Shippo::Parcel->api_url;
diag API::Shippo::Refund->api_url;
diag API::Shippo::Shipment->api_url;
diag API::Shippo::Transaction->api_url;
diag API::Shippo::Rate->api_url;
diag API::Shippo::CarrierAccount->api_url;
diag Dumper(API::Shippo::Address->new('object_id', 'my_key', foo => 1, bar => 2));
diag API::Shippo::Resource->api_private_token;
diag API::Shippo::Resource->api_public_token;
diag API::Shippo::Resource->api_token;

done_testing;
