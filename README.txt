NAME
    WebService::Shippo - A Shippo API Perl Wrapper (coming soon)

VERSION
    0.0.9 (2015-10-24)

UNDER CONSTRUCTION
    This is a work in progress.

    The project was minted on 2015-10-14 and is undergoing change on an
    almost daily basis. A minimal set of tests, with 96.1% statement
    coverage, was completed on 2015-10-24; the balance of that coverage is
    lost to the one-line non-OO interface defined in WebService/Shippo.pm,
    all of which simply call out the OO interface. The Coveralls coverage is
    showing 93% on Github because WebService/Shippo/Config.pm isn't
    exercised as heavily on Travis CI builds, and that's because I don't
    distribute a config file containing my API keys.

    Aside for a nip and a tuck here and there, this code can be considered
    stable and I can now beging documenting it.

SYNOPIS
        use strict;
        use WebService::Shippo;
    
        Shippo->api_key(PRIVATE-AUTH-TOKEN);
    
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
    
        print 'Success with Address 1 : ', $address
    
        # All being well, you should see something like the following output:
    
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
    Shippo is a shipping API that connects you with multiple shipping
    providers (such as USPS, UPS, and Fedex) through one interface, and
    offers you great discounts on shipping rates.

    Don't have an account? Sign up at <https://goshippo.com/>

  Full API Documentation
    * For API documentation, go to <https://goshippo.com/docs/>

    * For API support, contact <mailto:support@goshippo.com> with any
      questions.

REPOSITORY
    * <https://github.com/cpanic/WebService-Shippo>

    * <http://search.cpan.org/dist/WebService-Shippo/lib/WebService/Shippo.p
      m>

AUTHOR
    Iain Campbell <cpanic@cpan.org>

COPYRIGHT AND LICENSE
    This software is copyright (c) 2015 by Iain Campbell.

    You may distribute this software under the terms of either the GNU
    General Public License or the Artistic License, as specified in the Perl
    README file.

