use strict;
use warnings;
use Test::More;
use Test::Deep;
use Data::Dumper::Concise;

use_ok( 'API::Shippo' );

diag API::Shippo->api_private_token;
diag API::Shippo->api_public_token;
diag API::Shippo->api_key;
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
my $obj1 = API::Shippo::Address->new('object_id');
my $obj2 = API::Shippo::Address->construct_from({foo => 1, bar => 2, id => 'object_id'});
diag Dumper({obj1 => $obj1, obj2 => $obj2});
diag $obj1->to_json;
diag $obj2->to_json;
done_testing;
