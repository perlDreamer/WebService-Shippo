NAME
    WebService::Shippo - Shippo API Client

VERSION
    version 0.0.14

UNDER CONSTRUCTION
    Though functional, this software is still in the process of being
    documented and is, therefore, pre-release.

INTRODUCTION
    The Shippo API can be used to automate and customize shipping
    capabilities for your e-commerce store or marketplace, enabling you to
    retrieve shipping rates, create and purchase shipping labels, track
    packages, and much more.

    Shippo connects you with multiple shipping providers (USPS, UPS and
    Fedex, for example) through one interface, offering you great discounts
    on a selection of shipping rates.

    You can sign-up for an account at <https://goshippo.com/>.

    While Shippo offer official API clients for a bevy of *major* languages,
    the venerable Perl is not among them. This client is a community
    offering that attempts to fill that void.

SYNOPIS
        use strict;
        use WebService::Shippo;
    
        # If it hasn't already been done outside of the script, you
        # must set your API key...
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
    
        print 'Success with Address 1 : ', $address->to_json;

    All being well, you should see something like this:

        Success with Address 1 : {
           "city" : "Woodridge",
           "company" : "Initech",
           "country" : "US",
           "email" : "user@gmail.com",
           "ip" : null,
           "is_residential" : null,
           "messages" : [],
           "metadata" : "Customer ID 123456",
           "name" : "John Smith",
           "object_created" : "2015-10-16T16:14:16.296Z",
           "object_id" : "475bb05d72b74a08a1d44b40ac85d635",
           "object_owner" : "******@*********.***",
           "object_purpose" : "PURCHASE",
           "object_source" : "FULLY_ENTERED",
           "object_state" : "VALID",
           "object_updated" : "2015-10-16T16:14:16.296Z",
           "phone" : "0012343467333",
           "state" : "IL",
           "street1" : "6512 Greene Rd.",
           "street2" : "",
           "street_no" : "",
           "zip" : "60517"
        }

DESCRIPTION
FULL API DOCUMENTATION
    * For API documentation, go to <https://goshippo.com/docs/>

    * For API support, contact <mailto:support@goshippo.com> with any
      questions.

REPOSITORY
    * <http://search.cpan.org/dist/WebService-Shippo/lib/WebService/Shippo.p
      m>

    * <https://github.com/cpanic/WebService-Shippo>

    * <https://github.com/cpanic/WebService-Shippo/wiki>

AUTHOR
    Iain Campbell <cpanic@cpan.org>

COPYRIGHT AND LICENSE
    This software is copyright (c) 2015 by Iain Campbell.

    You may distribute this software under the terms of either the GNU
    General Public License or the Artistic License, as specified in the Perl
    README file.

