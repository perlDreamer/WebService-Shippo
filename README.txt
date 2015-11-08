UNDER CONSTRUCTION
    Though functional, this software is still in the process of being
    documented and should, therefore, be considered a work in progress.

NAME
    WebService::Shippo - Shippo API Client

VERSION
    version 0.0.16

SYNOPIS
        use WebService::Shippo;
    
        # If you aren't using a config file or the environment (SHIPPO_TOKEN=...)
        # to supply your API key, you can do so here...
        Shippo->api_key('PASTE YOUR AUTH TOKEN HERE')
            unless Shippo->api_key;

DESCRIPTION
    Shippo connects you with multiple shipping providers (USPS, UPS and
    Fedex, for example) through one interface, offering you great discounts
    on a selection of shipping rates.

    You can sign-up for an account at <https://goshippo.com/>.

    Though Shippo *do* offer official API clients for a bevy of major
    languages, the venerable Perl 5 was not included in that list. This
    software is a community offering which attempts to correct that
    omission.

OVERVIEW
    The Shippo API can be used to automate and customize shipping
    capabilities for your e-commerce store or marketplace, enabling you to
    retrieve shipping rates, create and purchase shipping labels, track
    packages, and much more.

    The "WebService::Shippo" client complements Shippo's official open
    source client libraries by helping to make API integration easier in
    ecosystems built around Perl 5.

  API Resources
    Access to all Shippo API resources is via URLs relative to the same
    encrypted API endpoint (https://api.goshippo.com/v1/).

    There are classes to help with the nitty-gritty of interacting with the
    different API resource types:

    *   Addresses ("WebService::Shippo::Address")

    *   Parcels ("WebService::Shippo::Parcel")

    *   Shipments ("WebService::Shippo::Shipment")

    *   Rates ("WebService::Shippo::Rate")

    *   Transactions ("WebService::Shippo::Transaction")

    *   Customs Items ("WebService::Shippo::CustomsItem")

    *   Customs Declarations ("WebService::Shippo::CustomsDeclaration")

    *   Refunds ("WebService::Shippo::Refund")

    *   Manifests ("WebService::Shippo::Manifest")

    *   Carrier Accounts ("WebService::Shippo::CarrierAccount")

    Note: though scripts and modules must always "use WebService::Shippo;"
    to import the Shippo API Client, the "WebService::" portion of its
    namespace may be dropped when referring to the "WebService::Shippo"
    package and any of its resource helper classes. For example,
    "WebService::Shippo::Address" and "Shippo::Address" may both be used
    interchangeably. Forcing the developer to keep typing "WebService::"
    seemed like an unreasonable form of torture, besides which, it probably
    wouldn't leave much room for code formatting.

  Request & Response Data
    The "WebService::Shippo" client ensures that requests are properly
    encoded and passed to the correct API endpoint using an appropriate HTTP
    method. There is documentation for each API resource, containing more
    details on the values accepted by and returned for a given resource (see
    "FULL API DOCUMENTATION").

    All requests return responses encoded as JSON strings, which are then
    translated into blessed object references of the correct type. As a
    rule, any resource attribute documented in the API specification will
    respond to methods of the same name in client object instances.

  REST & Disposable Objects
    The Shippo API is built with simplicity and RESTful principles in mind.
    Use POST requests to create objects, GET requests to list and retrieve
    objects, and PUT requests to update objects. Addresses, Parcels,
    Shipments, Rates, Transactions, Refunds, Customs Items and Customs
    Declarations are disposable objects. This means that once you create an
    object, you cannot change it. Instead, create a new one with the desired
    values. Carrier Accounts are the exception and may be updated via PUT
    requests.

    The "WebService::Shippo" client provides "create", "all", "fetch", and
    "update" methods for use with resource objects that permit these
    operations.

FULL API DOCUMENTATION
    * For API documentation, go to <https://goshippo.com/docs/>

    * For API support, contact <mailto:support@goshippo.com> with any
      questions.

REPOSITORY
    * <https://github.com/cpanic/WebService-Shippo>

    * <https://github.com/cpanic/WebService-Shippo/wiki>

AUTHOR
    Iain Campbell <cpanic@cpan.org>

COPYRIGHT AND LICENSE
    This software is copyright © 2015 by Iain Campbell.

    You may distribute this software under the terms of either the GNU
    General Public License or the Artistic License, as specified in the Perl
    README file.

