use strict;
use warnings;
use Test::More;
use Test::Deep;
use Data::Dumper::Concise;

use_ok( 'WebService::Shippo' );

diag WebService::Shippo->api_private_token;
diag WebService::Shippo->api_public_token;
diag WebService::Shippo->api_key;
diag WebService::Shippo::Address->api_url;
diag WebService::Shippo::CustomsItem->api_url;
diag WebService::Shippo::CustomsDeclaration->api_url;
diag WebService::Shippo::Manifest->api_url;
diag WebService::Shippo::Parcel->api_url;
diag WebService::Shippo::Refund->api_url;
diag WebService::Shippo::Shipment->api_url;
diag WebService::Shippo::Transaction->api_url;
diag WebService::Shippo::Rate->api_url;
diag WebService::Shippo::CarrierAccount->api_url;
my $obj1 = WebService::Shippo::Address->new('object_id');
my $obj2 = WebService::Shippo::Address->construct_from({foo => 1, bar => 2, id => 'object_id'});
diag Dumper({obj1 => $obj1, obj2 => $obj2});
diag $obj1->to_json;
diag $obj2->to_json;
done_testing;
