use strict;
use warnings;

package WebService::Shippo;
# ABSTRACT: A Shippo Perl API wrapper
our $VERSION = '0.0.16';
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

our @EXPORT_OK = qw(
    isTrue
    isFalse
    isBoolean
    callbacks
);
our %EXPORT_TAGS = ( all => [ @EXPORT, @EXPORT_OK ], bool => $boolean::EXPORT_TAGS{all} );

sub import
{
    my ( $class ) = @_;
    # Configure Shippo client on import
    WebService::Shippo::Config->config;
    # The API key is overridden with the envornment's value if defined.
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
    *Response              = *WebService::Shippo::Request::response;
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

    use WebService::Shippo;
    
    # If you aren't using a config file or the environment (SHIPPO_TOKEN=...)
    # to supply your API key, you can do so here...
    Shippo->api_key('PASTE YOUR AUTH TOKEN HERE')
        unless Shippo->api_key;
        
=head1 DESCRIPTION

Shippo connects you with multiple shipping providers (USPS, UPS and Fedex,
for example) through one interface, offering you great discounts on a
selection of shipping rates.

You can sign-up for an account at L<https://goshippo.com/>.

Though Shippo I<do> offer official API clients for a bevy of major languages, 
the venerable Perl 5 was not included in that list. This software is a community
offering which attempts to correct that omission.

=head1 OVERVIEW

The Shippo API can be used to automate and customize shipping capabilities
for your e-commerce store or marketplace, enabling you to retrieve shipping 
rates, create and purchase shipping labels, track packages, and much more.

The C<WebService::Shippo> client complements Shippo's official open source
client libraries by helping to make API integration easier in ecosystems
built around Perl 5.

=head2 API Resources

Access to all Shippo API resources is via URLs relative to the same encrypted
API endpoint (https://api.goshippo.com/v1/).

There are classes to help with the nitty-gritty  of interacting with the 
different API resource types:

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

B<Note>: though scripts and modules must always C<B<use WebService::Shippo;>>
to import the Shippo API Client, the C<B<WebService::>> portion of its
namespace may be dropped when referring to the C<WebService::Shippo>
package and any of its resource helper classes. For example, 
C<WebService::Shippo::Address> and C<Shippo::Address> may both be
used interchangeably. Forcing the developer to keep typing C<WebService::>
seemed like an unreasonable form of torture, besides which, it probably
wouldn't leave much room for code formatting.

=head2 Request & Response Data

The C<WebService::Shippo> client ensures that requests are properly encoded and
passed to the correct API endpoint using an appropriate HTTP method. There is
documentation for each API resource, containing more details on the values 
accepted by and returned for a given resource (see L<FULL API DOCUMENTATION>).

All requests return responses encoded as JSON strings, which are then translated
into blessed object references of the correct type. As a rule, any resource
attribute documented in the API specification will respond to methods of the
same name in client object instances.

=head2 REST & Disposable Objects

The Shippo API is built with simplicity and RESTful principles in mind. Use
B<POST> requests to create objects, B<GET> requests to list and retrieve
objects, and B<PUT> requests to update objects. Addresses, Parcels, Shipments,
Rates, Transactions, Refunds, Customs Items and Customs Declarations are
disposable objects. This means that once you create an object, you cannot
change it. Instead, create a new one with the desired values. Carrier Accounts
are the exception and may be updated via B<PUT> requests.

The C<WebService::Shippo> client provides C<create>, C<all>, C<fetch>, and
C<update> methods for use with resource objects that permit these operations.

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
