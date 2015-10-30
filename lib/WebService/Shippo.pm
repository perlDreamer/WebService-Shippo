use strict;
use warnings;

package WebService::Shippo;
# ABSTRACT: A Shippo Perl API wrapper
our $VERSION = '0.0.11';
use boolean ':all';
require WebService::Shippo::Entities;
require WebService::Shippo::Request;
require WebService::Shippo::Config;
use Params::Callbacks ( 'callbacks', 'callback' );
use base ( 'Exporter' );

our @EXPORT = qw(true false boolean callback);

our @EXPORT_OK = qw(
    isTrue
    isFalse
    isBoolean
    shippo_address
    shippo_address_list
    shippo_address_validate
    shippo_address_create
    shippo_carrier_account
    shippo_carrier_account_list
    shippo_carrier_account_create
    shippo_carrier_account_update
    shippo_customs_declaration
    shippo_customs_declaration_list
    shippo_customs_declaration_create
    shippo_customs_item
    shippo_customs_item_list
    shippo_customs_item_create
    shippo_manifest
    shippo_manifest_list
    shippo_manifest_create
    shippo_parcel
    shippo_parcel_list
    shippo_parcel_create
    shippo_rate
    shippo_rate_list
    shippo_refund
    shippo_refund_list
    shippo_refund_create
    shippo_shipment
    shippo_shipment_list
    shippo_shipment_create
    shippo_shipment_rates
    shippo_transaction
    shippo_transaction_list
    shippo_transaction_create
);
our %EXPORT_TAGS = ( all => \@EXPORT_OK, bool => $boolean::EXPORT_TAGS{all} );

#<<< Don't Perl Tidy this
sub shippo_address                    { WebService::Shippo::Address->get( @_ ) }
sub shippo_address_list               { WebService::Shippo::Address->all( @_ ) }
sub shippo_address_validate           { WebService::Shippo::Address->validate( @_ ) }
sub shippo_address_create             { WebService::Shippo::Address->create( @_ ) }
sub shippo_carrier_account            { WebService::Shippo::CarrierAccount->get( @_ ) }
sub shippo_carrier_account_list       { WebService::Shippo::CarrierAccount->all( @_ ) }
sub shippo_carrier_account_create     { WebService::Shippo::CarrierAccount->create( @_ ) }
sub shippo_carrier_account_update     { WebService::Shippo::CarrierAccount->update( @_ ) }
sub shippo_customs_declaration        { WebService::Shippo::CustomsDeclaration->get( @_ ) }
sub shippo_customs_declaration_list   { WebService::Shippo::CustomsDeclaration->all( @_ ) }
sub shippo_customs_declaration_create { WebService::Shippo::CustomsDeclaration->create( @_ ) }
sub shippo_customs_item               { WebService::Shippo::CustomsItem->get( @_ ) }
sub shippo_customs_item_list          { WebService::Shippo::CustomsItem->all( @_ ) }
sub shippo_customs_item_create        { WebService::Shippo::CustomsItem->create( @_ ) }
sub shippo_manifest                   { WebService::Shippo::Manifest->get( @_ ) }
sub shippo_manifest_list              { WebService::Shippo::Manifest->all( @_ ) }
sub shippo_manifest_create            { WebService::Shippo::Manifest->create( @_ ) }
sub shippo_parcel                     { WebService::Shippo::Parcel->get( @_ ) }
sub shippo_parcel_list                { WebService::Shippo::Parcel->all( @_ ) }
sub shippo_parcel_create              { WebService::Shippo::Parcel->create( @_ ) }
sub shippo_rate                       { WebService::Shippo::Rate->get( @_ ) }
sub shippo_rate_list                  { WebService::Shippo::Rate->all( @_ ) }
sub shippo_refund                     { WebService::Shippo::Refund->get( @_ ) }
sub shippo_refund_list                { WebService::Shippo::Refund->all( @_ ) }
sub shippo_refund_create              { WebService::Shippo::Refund->create( @_ ) }
sub shippo_shipment                   { WebService::Shippo::Shipment->get( @_ ) }
sub shippo_shipment_list              { WebService::Shippo::Shipment->all( @_ ) }
sub shippo_shipment_create            { WebService::Shippo::Shipment->create( @_ ) }
sub shippo_shipment_rates             { WebService::Shippo::Shipment->rates( @_ ) }
sub shippo_transaction                { WebService::Shippo::Transaction->get( @_ ) }
sub shippo_transaction_list           { WebService::Shippo::Transaction->all( @_ ) }
sub shippo_transaction_create         { WebService::Shippo::Transaction->create( @_ ) }
#>>>

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

=head1 NAME

WebService::Shippo - A Shippo API Perl Wrapper (coming soon)

=head1 VERSION

0.0.11 (2015-10-29)

=head1 SYNOPIS

Shippo is a shipping API that connects you with multiple shipping providers
(such as USPS, UPS, and Fedex) through one interface, and offers you great
discounts on shipping rates.

Don't have an account? Sign up at L<https://goshippo.com/>

    use strict;
    use WebService::Shippo;
    
    # If it hasn't already done outside of the script, you
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
    
    print 'Success with Address 1 : ', $address

All being well, you should see something like the following output:

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
    
=head1 DESCRIPTION

=head1 FULL API DOCUMENTATION

=over 2

=item * For API documentation, go to L<https://goshippo.com/docs/>

=item * For API support, contact L<mailto:support@goshippo.com> with any 
questions.

=back

=head1 REPOSITORY

=over 2

=item * L<http://search.cpan.org/dist/WebService-Shippo/lib/WebService/Shippo.pm>

=item * L<https://github.com/cpanic/WebService-Shippo>

=item * L<https://github.com/cpanic/WebService-Shippo/wiki>

=back

=head1 AUTHOR

Iain Campbell <cpanic@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Iain Campbell.

You may distribute this software under the terms of either the GNU General
Public License or the Artistic License, as specified in the Perl README
file.


=cut
