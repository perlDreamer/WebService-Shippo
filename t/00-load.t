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

diag Dumper( Shippo::Address->all() );
diag Dumper( Shippo::CarrierAccount->all() );
diag Dumper( Shippo::CarrierAccount->get('25e8c3acf42b46c5833a53d4378db320') );

done_testing;
