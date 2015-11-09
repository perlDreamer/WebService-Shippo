use strict;
use warnings;

package WebService::Shippo;
# ABSTRACT: A Shippo Perl API wrapper
our $VERSION = '0.0.17';
require WebService::Shippo::Entities;
use boolean ':all';
use Params::Callbacks ( 'callbacks', 'callback' );
use base ( 'Exporter' );

our @EXPORT = qw(
    true
    false
    boolean
    callback
);

sub import
{
    my ( $class ) = @_;
    # Configure Shippo client on import
    WebService::Shippo::Config->config;
    # The API key is overridden with the environment's value if defined.
    WebService::Shippo::Resource->api_username_password(
        @ENV{ 'SHIPPO_USER', 'SHIPPO_PASS' } )
        if $ENV{SHIPPO_USER} && !$ENV{SHIPPO_TOKEN};
    WebService::Shippo::Resource->api_key( $ENV{SHIPPO_TOKEN} )
        if $ENV{SHIPPO_TOKEN};
    # Pass call frame to Exporter's import for further processing
    goto &Exporter::import;
}

BEGIN {
    no warnings 'once';
    # There are some useful symbols defined elsewhere that I'd like to
    # make available (alias) via the root namespace.
    *api_key               = *WebService::Shippo::Resource::api_key;
    *api_username_password = *WebService::Shippo::Resource::api_username_password;
    *config                = *WebService::Shippo::Config::config;
    *pretty                = *WebService::Shippo::Object::pretty;
    *response              = *WebService::Shippo::Request::response;
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo:: = *WebService::Shippo::;
}

1;

=pod

=encoding utf8

=head1 UNDER CONSTRUCTION

B<Though functional, this software is still in the process of being
documented and should, therefore, be considered a work in progress.> 

=head1 NAME

WebService::Shippo - Shippo API Client

=head1 SYNOPIS

B<Note>: though scripts and modules must always C<use WebService::Shippo;>
to import the client software, the C<WebService::> portion of that package
namespace may be dropped when subsequently referring to the main package
or any of its resource classes. For example, C<WebService::Shippo::Address>
and C<Shippo::Address> refer to the same class. 

To compel the developer to continue using the C<WebService::> prefix does
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
C<LWP::UserAgent> package:

=for HTML <p style="padding-left:4em;"><img src="https://github.com/cpanic/WebService-Shippo/wiki/images/sample.png" height="432" width="288" /></p>

=head1 DESCRIPTION

Shippo connects you with multiple shipping providers (USPS, UPS and Fedex,
for example) through one interface, offering you great discounts on a
selection of shipping rates. You can sign-up for an account at 
L<https://goshippo.com/>.

Though Shippo I<do> offer official API clients for a bevy of major languages, 
the venerable Perl 5 was not included in that list. This community offering 
attempts to correct that omission ;-)

=head1 OVERVIEW

The Shippo API can be used to automate and customize shipping capabilities
for your e-commerce store or marketplace, enabling you to retrieve shipping 
rates, create and purchase shipping labels, track packages, and much more.

This client complements Shippo's official Open Source client libraries by
helping to make Shippo API integration easier in ecosystems built around
Perl.

=head2 API Resources

Access to all Shippo API resources is via URLs relative to the same encrypted
API endpoint (https://api.goshippo.com/v1/).

There are resource item classes to help with the nitty-gritty of interacting
each type of resource:

=over

=item * Addresses (C<L<WebService::Shippo::Address>>)

=item * Parcels (C<L<WebService::Shippo::Parcel>>)

=item * Shipments (C<L<WebService::Shippo::Shipment>>)

=item * Rates (C<L<WebService::Shippo::Rate>>)

=item * Transactions (C<L<WebService::Shippo::Transaction>>)

=item * Customs Items (C<L<WebService::Shippo::CustomsItem>>)

=item * Customs Declarations (C<L<WebService::Shippo::CustomsDeclaration>>)

=item * Refunds (C<L<WebService::Shippo::Refund>>)

=item * Manifests (C<L<WebService::Shippo::Manifest>>)

=item * Carrier Accounts (C<L<WebService::Shippo::CarrierAccount>>)

=back

Each item class has a related collection class with a similar name I<in the
plural form>. The rationale behind this is that the Shippo API can be used
to retrieve single objects with the C<fetch> method, and collections of
objects with the C<all> method, and different behaviours may be applied
to collections, which is why both forms exist.

=head2 Request & Response Data

The Perl client ensures that requests are properly encoded and passed to the
correct API endpoints using appropriate HTTP methods. There is documentation
for each API resource, containing more details on the values accepted by and
returned for a given resource (see L<FULL API DOCUMENTATION>).

All API requests return responses encoded as JSON strings, which the client
converts into Perl blessed object references of the correct type. As a rule,
any resource attribute documented in the API specification will have an
accessor of the same same in a Perl instance of that object.

=head2 REST & Disposable Objects

The Shippo API is built with simplicity and RESTful principles in mind:
B<POST> requests are used to create objects, B<GET> requests to fetch and
list objects, and B<PUT> requests to update objects. The Perl client provides
C<create>, C<fetch>, C<all> and C<update> methods for use with resource
objects that permit such operations.


Addresses, Parcels, Shipments, Rates, Transactions, Refunds, Customs Items and
Customs Declarations are disposable objects. This means that once you create
an object, you cannot change it. Instead, create a new one with the desired
values. Carrier Accounts are the exception and may be updated via B<PUT>
requests.

=head1 METHODS

=head2 api_key

    Shippo->api_key($auth_token);
    my $api_key = Shippo->api_key;

A suitably constructed configuration file should mean this method never needs
to be called explicitly. As soon as the Shippo client is imported it will
attempt to search for and load a YAML configuration from the following sequence
of locations:

=over 2

=item 1. C<./.shipporc>

=item 2. C</path/to/home/.shipporc>

=item 3. C</etc/shipporc>

=item 4. C</path/to/lib/WebService/Shippo/Config.yml>

=back

This method is used to set the token used for Shippo's Token-based
authentication. It ensures that a properly encoded C<Authorizatio: ShippoToken ...>
header accompanies all API requests. Used as a setter, this method is chainable.

Used as a getter, the method returns the token currently being used for
authentication.

=head2 api_username_password

    Shippo->api_username_password($username, $password);
    my ($username, $password) = Shippo->api_username_password;

A suitably constructed configuration file should mean this method never needs
to be called explicitly. As soon as the Shippo client is imported it will
attempt to search for and load a YAML configuration from the following sequence
of locations:

=over 2

=item 1. C<./.shipporc>

=item 2. C</path/to/home/.shipporc>

=item 3. C</etc/shipporc>

=item 4. C</path/to/lib/WebService/Shippo/Config.yml>

=back

Shippo's preferred authentication mechanism is based upon a Token or API key.

The Perl client supports Shippo's legacy mechanism, which is based upon
HTTP basic authentication. Use this method to force the client to use the
legacy mechanism. It will ensure that a correctly encoded C<Authorization: Basic ...>
header accompanies all API requests. Used as a setter, this method is chainable.

Used as a getter, the method can be used to retrieve the current values of 
the username and password.

=head2 config

    Shippo->config(\%configuration);
    my $config_hash = Shippo->config;

A suitably constructed configuration file should mean this method never needs
to be called explicitly. As soon as the Shippo client is imported it will
attempt to search for and load a YAML configuration from the following sequence
of locations:

=over 2

=item 1. C<./.shipporc>

=item 2. C</path/to/home/.shipporc>

=item 3. C</etc/shipporc>

=item 4. C</path/to/lib/WebService/Shippo/Config.yml>

=back

If no configuration could be found then it's up to the developer to define
one using the C<config> method, or provide authentication details using the
C<api_key> or C<api_username_password> methods.
 
This method can be used to define a configuration for a Shippo client
session. The configuration is presented as a hash reference and immediately
defines session authentication parameters. Used this way, the method is
chainable.

When used as a getter, the method returns the current config.

=over

=item B<Example>

    Shippo->config({
        username      => 'martymcfly@pinheads.org',
        password      => 'yadayada',
        private_token => 'f0e1d2c3b4a5968778695a4b3c2d1e0f96877869',
        public_token  => '96877869f0e1d2c3b4a5968778695a4b3c2d1e0f',
        default_token => 'private_token'
    });

They are not absolutely necessary, but C<username> and C<password> will be
required for Basic Authentication you don't intend to use Shippo's preferred
Token-based authentication. The C<private_token> and C<public_token> fields
are the Shippo Private and Publishable Auth Tokens, which can be found on the
L<Shippo API page|https://goshippo.com/user/apikeys/>. The C<default_token>
determines which of these will be used as the API key and defaults to the
Private Auth Token if undefined.

=back

=head2 pretty

    Shippo->pretty($boolean);
    my $boolean = Shippo->pretty;

Can be used to control whether or not JSON output is readable when calling
the C<to_json> method on Shippo objects, or when those objects are subject
to string overloading. Used this way, the method is chainable.

When used as a getter, the method returns the current setting.

=head2 response

    my $last_response = Shippo->response;

Returns a copy of the C<L<HTTP::Response>> resulting from the most recent request.

=head1 EXPORTS

The C<WebService::Shippo> package exports a number of helpful subroutines by
default:

=head2 true

    my $fedex_account = Shippo::CarrierAccount->create(
        carrier    => 'fedex',
        account_id => '<YOUR-FEDEX-ACCOUNT-NUMBER>',
        parameters => { meter => '<YOUR-FEDEX-METER-NUMBER>' },
        test       => true,
        active     => true
    );

Returns a scalar value which will evaluate to true. 

Since the I<lingua franca> connecting Shippo's API and the Perl client is
JSON, it can feel more natural to think in those terms. Thus, C<true> may be
used in place of C<1>. Now, when creating a new object from a JSON example,
any literal and accidental use of C<true> or C<false> is much less likely
to result in misery.

See Ingy's L<boolean> package for more guidance.

=head2 false

    my $fedex_account = Shippo::CarrierAccount->create(
        carrier    => 'fedex',
        account_id => '<YOUR-FEDEX-ACCOUNT-NUMBER>',
        parameters => { meter => '<YOUR-FEDEX-METER-NUMBER>' },
        test       => false,
        active     => false
    );

Returns a scalar value which will evaluate to false. 

Since the I<lingua franca> connecting Shippo's API and the Perl client is
JSON, it can feel more natural to think in those terms. Thus, C<false> may be
used in place of C<0>. Now, when creating a new object from a JSON example,
any literal and accidental use of C<true> or C<false> is much less likely
to result in misery.

See Ingy's L<boolean> package for more guidance.

=head2 boolean

    my $bool = boolean($value);

Casts a scalar value to a boolean value (C<true> or C<false>).

See Ingy's L<boolean> package for more guidance.

=head2 callback

    Shippo::CarrierAccounts->all(callback {
        $_->enable_test_mode;
    });
    
Returns a blessed C<sub> suitable for use as a callback. Some methods accept
optional blocking callbacks in order to facilitate list transformations, so
this package makes C<&Params::Callbacks::callback> available for use.

See L<Params::Callbacks> for more guidance.

=head1 FULL API DOCUMENTATION

=over 2

=item * For API documentation, go to L<https://goshippo.com/docs/>

=item * For API support, contact L<mailto:support@goshippo.com> with any 
questions.

=back

=head1 REPOSITORY

=over 2

=item * L<https://github.com/cpanic/WebService-Shippo>

=item * L<https://github.com/cpanic/WebService-Shippo/wiki>

=back

=head1 AUTHOR

Iain Campbell <cpanic@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright E<copy> 2015 by Iain Campbell.

You may distribute this software under the terms of either the GNU General
Public License or the Artistic License, as specified in the Perl README
file.


=cut
