UNDER CONSTRUCTION
    Though functional, this software is still in the process of being
    documented and should, therefore, be considered a work in progress.

NAME
    WebService::Shippo - Shippo API Client

VERSION
    version 0.0.16

SYNOPIS
    Note: though scripts and modules must always "use WebService::Shippo;"
    to import the client software, the "WebService::" portion of that
    package namespace may be dropped when subsequently referring to the main
    package or any of its resource classes. For example,
    "WebService::Shippo::Address" and "Shippo::Address" refer to the same
    class.

    To compel the developer to continue using the "WebService::" prefix does
    seem like an unreasonable form of torture, besides which, it probably
    doesn't leave much scope for indenting code as some class names would be
    very long. Use it, or don't use it. It's entirely up to you.

        use strict;
        use LWP::UserAgent;
        use WebService::Shippo;
    
        # If you aren't using a config file or the environment (SHIPPO_TOKEN=...)
        # to supply your API key, you can do so here:
    
        Shippo->api_key('PASTE YOUR AUTH TOKEN HERE')
            unless Shippo->api_key;
    
        # Complete example illustrating the the process of Shipment creation
        # through to label generation.
        #
        # Create a Shipment object:
    
        my $shipment = Shippo::Shipment->create(
            object_purpose => 'PURCHASE',
            address_from   => {
                object_purpose => 'PURCHASE',
                name           => 'Shawn Ippotle',
                company        => 'Shippo',
                street1        => '215 Clayton St.',
                city           => 'San Francisco',
                state          => 'CA',
                zip            => '94117',
                country        => 'US',
                phone          => '+1 555 341 9393',
                email          => 'shippotle@goshippo.com'
            },
            address_to => {
                object_purpose => 'PURCHASE',
                name           => 'Mr Hippo',
                company        => '',
                street1        => 'Broadway 1',
                street2        => '',
                city           => 'New York',
                state          => 'NY',
                zip            => '10007',
                country        => 'US',
                phone          => '+1 555 341 9393',
                email          => 'mrhippo@goshippo.com'
            },
            parcel => {
                length        => '5',
                width         => '5',
                height        => '5',
                distance_unit => 'in',
                weight        => '2',
                mass_unit     => 'lb'
            }
        );
    
        # Retrieve shipping rates and select preferred rate:
    
        my $rates = Shippo::Shipment->get_shipping_rates( $shipment->object_id );
        my $preferred_rate = $rates->item(2);
    
        # Purchase label at the preferred rate:
    
        my $transaction = Shippo::Transaction->create(
            rate            => $preferred_rate->object_id,
            label_file_type => 'PNG',
        );
    
        # Get the shipping label:
    
        my $label_url = Shippo::Transaction->get_shipping_label( $transaction->object_id );
        my $browser   = LWP::UserAgent->new;
        $browser->get( $transaction->label_url, ':content_file' => './sample.png' );
    
        # Print the transaction object...
    
        print "Transaction:\n", $transaction->to_json(1); # '1' makes the JSON readable

        --[content dumped to console]--
        Transaction:
        {
           "commercial_invoice_url" : null,
           "customs_note" : "",
           "label_url" : "https://shippo-delivery-east.s3.amazonaws.com/da2e68fe85f94a9ebca458d9f9d
        2446b.PNG?Signature=BjD2JMQt0ATd5jUWAKm%2B6FHcBPM%3D&Expires=1477323662&AWSAccessKeyId=AKIA
        JGLCC5MYLLWIG42A",
           "messages" : [],
           "metadata" : "",
           "notification_email_from" : false,
           "notification_email_other" : "",
           "notification_email_to" : false,
           "object_created" : "2015-10-25T15:41:01.182Z",
           "object_id" : "da2e68fe85f94a9ebca458d9f9d2446b",
           "object_owner" : "******@*********.***",
           "object_state" : "VALID",
           "object_status" : "SUCCESS",
           "object_updated" : "2015-10-25T15:41:02.494Z",
           "order" : null,
           "pickup_date" : null,
           "rate" : "3c76e81733d7417b9a801ce957f4219d",
           "submission_note" : "",
           "tracking_history" : [],
           "tracking_number" : "9499907123456123456781",
           "tracking_status" : {
              "object_created" : "2015-10-25T15:41:02.451Z",
              "object_id" : "02ce6dbd6d5a48cfb764fdeb0cb6e404",
              "object_updated" : "2015-10-25T15:41:02.451Z",
              "status" : "UNKNOWN",
              "status_date" : null,
              "status_details" : ""
           },
           "tracking_url_provider" : "https://tools.usps.com/go/TrackConfirmAction_input?origTrackN
        um=9499907123456123456781",
           "was_test" : true
        }
        --[end of content]--

    The sample code in this synopsis produced the following label (at a much
    larger size, of course), which was then saved as a PNG file using the
    "LWP::UserAgent" package:

DESCRIPTION
    Shippo connects you with multiple shipping providers (USPS, UPS and
    Fedex, for example) through one interface, offering you great discounts
    on a selection of shipping rates. You can sign-up for an account at
    <https://goshippo.com/>.

    Though Shippo *do* offer official API clients for a bevy of major
    languages, the venerable Perl 5 was not included in that list. This
    community offering attempts to correct that omission ;-)

OVERVIEW
    The Shippo API can be used to automate and customize shipping
    capabilities for your e-commerce store or marketplace, enabling you to
    retrieve shipping rates, create and purchase shipping labels, track
    packages, and much more.

    This client complements Shippo's official Open Source client libraries
    by helping to make Shippo API integration easier in ecosystems built
    around Perl.

  API Resources
    Access to all Shippo API resources is via URLs relative to the same
    encrypted API endpoint (https://api.goshippo.com/v1/).

    There are resource item classes to help with the nitty-gritty of
    interacting each type of resource:

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

    Each item class has a related collection class with a similar name *in
    the plural form*. The rationale behind this is that the Shippo API can
    be used to retrieve single objects with the "fetch" method, and
    collections of objects with the "all" method, and different behaviours
    may be applied to collections, which is why both forms exist.

  Request & Response Data
    The Perl client ensures that requests are properly encoded and passed to
    the correct API endpoints using appropriate HTTP methods. There is
    documentation for each API resource, containing more details on the
    values accepted by and returned for a given resource (see "FULL API
    DOCUMENTATION").

    All API requests return responses encoded as JSON strings, which the
    client converts into Perl blessed object references of the correct type.
    As a rule, any resource attribute documented in the API specification
    will have an accessor of the same same in a Perl instance of that
    object.

  REST & Disposable Objects
    The Shippo API is built with simplicity and RESTful principles in mind:
    POST requests are used to create objects, GET requests to fetch and list
    objects, and PUT requests to update objects. The Perl client provides
    "create", "fetch", "all" and "update" methods for use with resource
    objects that permit such operations.

    Addresses, Parcels, Shipments, Rates, Transactions, Refunds, Customs
    Items and Customs Declarations are disposable objects. This means that
    once you create an object, you cannot change it. Instead, create a new
    one with the desired values. Carrier Accounts are the exception and may
    be updated via PUT requests.

METHODS
  api_key
        Shippo->api_key($auth_token);
        my $api_key = Shippo->api_key;

    A suitably constructed configuration file should mean this method never
    needs to be called explicitly. As soon as the Shippo client is imported
    it will attempt to search for and load a YAML configuration from the
    following sequence of locations:

    1. "./.shipporc"
    2. "/path/to/home/.shipporc"
    3. "/etc/shipporc"
    4. "/path/to/lib/WebService/Shippo/Config.yml"

    This method is used to set the token used for Shippo's Token-based
    authentication. It ensures that a properly encoded "Authorizatio:
    ShippoToken ..." header accompanies all API requests. Used as a setter,
    this method is chainable.

    Used as a getter, the method returns the token currently being used for
    authentication.

  api_username_password
        Shippo->api_username_password($username, $password);
        my ($username, $password) = Shippo->api_username_password;

    A suitably constructed configuration file should mean this method never
    needs to be called explicitly. As soon as the Shippo client is imported
    it will attempt to search for and load a YAML configuration from the
    following sequence of locations:

    1. "./.shipporc"
    2. "/path/to/home/.shipporc"
    3. "/etc/shipporc"
    4. "/path/to/lib/WebService/Shippo/Config.yml"

    Shippo's preferred authentication mechanism is based upon a Token or API
    key.

    The Perl client supports Shippo's legacy mechanism, which is based upon
    HTTP basic authentication. Use this method to force the client to use
    the legacy mechanism. It will ensure that a correctly encoded
    "Authorization: Basic ..." header accompanies all API requests. Used as
    a setter, this method is chainable.

    Used as a getter, the method can be used to retrieve the current values
    of the username and password.

  config
        Shippo->config(\%configuration);
        my $config_hash = Shippo->config;

    A suitably constructed configuration file should mean this method never
    needs to be called explicitly. As soon as the Shippo client is imported
    it will attempt to search for and load a YAML configuration from the
    following sequence of locations:

    1. "./.shipporc"
    2. "/path/to/home/.shipporc"
    3. "/etc/shipporc"
    4. "/path/to/lib/WebService/Shippo/Config.yml"

    If no configuration could be found then it's up to the developer to
    define one using the "config" method, or provide authentication details
    using the "api_key" or "api_username_password" methods.

    This method can be used to define a configuration for a Shippo client
    session. The configuration is presented as a hash reference and
    immediately defines session authentication parameters. Used this way,
    the method is chainable.

    When used as a getter, the method returns the current config.

    Example
            Shippo->config({
                username      => 'martymcfly@pinheads.org',
                password      => 'yadayada',
                private_token => 'f0e1d2c3b4a5968778695a4b3c2d1e0f96877869',
                public_token  => '96877869f0e1d2c3b4a5968778695a4b3c2d1e0f',
                default_token => 'private_token'
            });

        They are not absolutely necessary, but "username" and "password"
        will be required for Basic Authentication you don't intend to use
        Shippo's preferred Token-based authentication. The "private_token"
        and "public_token" fields are the Shippo Private and Publishable
        Auth Tokens, which can be found on the Shippo API page
        <https://goshippo.com/user/apikeys/>. The "default_token" determines
        which of these will be used as the API key and defaults to the
        Private Auth Token if undefined.

  pretty
        Shippo->pretty($boolean);
        my $boolean = Shippo->pretty;

    Can be used to control whether or not JSON output is readable when
    calling the "to_json" method on Shippo objects, or when those objects
    are subject to string overloading. Used this way, the method is
    chainable.

    When used as a getter, the method returns the current setting.

  response
        my $last_response = Shippo->response;

    Returns a copy of the "HTTP::Response" resulting from the most recent
    request.

EXPORTS
    The "WebService::Shippo" package exports a number of helpful subroutines
    by default:

  true
        my $fedex_account = Shippo::CarrierAccount->create(
            carrier    => 'fedex',
            account_id => '<YOUR-FEDEX-ACCOUNT-NUMBER>',
            parameters => { meter => '<YOUR-FEDEX-METER-NUMBER>' },
            test       => true,
            active     => true
        );

    Returns a scalar value which will evaluate to true.

    Since the *lingua franca* connecting Shippo's API and the Perl client is
    JSON, it can feel more natural to think in those terms. Thus, "true" may
    be used in place of 1. Now, when creating a new object from a JSON
    example, any literal and accidental use of "true" or "false" is much
    less likely to result in misery.

    See Ingy's boolean package for more guidance.

  false
        my $fedex_account = Shippo::CarrierAccount->create(
            carrier    => 'fedex',
            account_id => '<YOUR-FEDEX-ACCOUNT-NUMBER>',
            parameters => { meter => '<YOUR-FEDEX-METER-NUMBER>' },
            test       => false,
            active     => false
        );

    Returns a scalar value which will evaluate to false.

    Since the *lingua franca* connecting Shippo's API and the Perl client is
    JSON, it can feel more natural to think in those terms. Thus, "false"
    may be used in place of 0. Now, when creating a new object from a JSON
    example, any literal and accidental use of "true" or "false" is much
    less likely to result in misery.

    See Ingy's boolean package for more guidance.

  boolean
        my $bool = boolean($value);

    Casts a scalar value to a boolean value ("true" or "false").

    See Ingy's boolean package for more guidance.

  callback
        Shippo::CarrierAccounts->all(callback {
            $_->enable_test_mode;
        });

    Returns a blessed "sub" suitable for use as a callback. Some methods
    accept optional blocking callbacks in order to facilitate list
    transformations, so this package makes &Params::Callbacks::callback
    available for use.

    See Params::Callbacks for more guidance.

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

