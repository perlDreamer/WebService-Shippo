use strict;
use WebService::Shippo;

Shippo->api_key( 'PASTE YOUR PRIVATE AUTH TOKEN HERE' )
    unless Shippo->api_key;

my $address = Shippo::Address->create(
    object_purpose => 'PURCHASE',
    name           => 'John Smith',
    street1        => '6512 Greene Rd.',
    street2        => '',
    company        => 'Initech',
    phone          => '+1 234 346 7333',
    city           => 'Woodridge',
    state          => 'IL',
    zip            => '60517',
    country        => 'US',
    email          => 'user@gmail.com',
    metadata       => 'Customer ID 123456'
);

print $address->validate->to_json;
