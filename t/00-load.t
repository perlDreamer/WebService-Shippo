use strict;
use warnings;
use Test::More;
use Test::Deep;
use Data::Dumper::Concise;

use_ok( 'WebService::Shippo' );

##diag Shippo::Address->create(
##    { name           => 'Shawn Ippotle',
##      object_purpose => 'QUOTE',
##      company        => 'Shippo',
##      street1        => '215 Clayton St.',
##      street2        => '',
##      city           => 'San Francisco',
##      state          => 'CA',
##      zip            => 94117,
##      country        => 'US',
##      phone          => '+1 555 341 9393',
##      email          => 'shippotle@goshippo.com',
##      is_residential => 1,
##      metadata       => 'Customer ID 123456',
##    }
##)->to_json;
#diag( Dumper( Shippo::Address->all ) );
#diag( Dumper( Shippo::Address->validate('4237fe09eba4493db8b31ff495d75a20') ) );
#diag Shippo::CarrierAccount->all()->to_json;
#diag Shippo::CarrierAccount->get( '25e8c3acf42b46c5833a53d4378db320' )
#    ->to_json;
#
#my $addresses = WebService::Shippo::Address->all;
#diag(Dumper($addresses->results));
done_testing;
