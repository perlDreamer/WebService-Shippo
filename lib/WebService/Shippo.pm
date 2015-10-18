use strict;
use warnings;

package WebService::Shippo;
# ABSTRACT: A Shippo Perl API wrapper
our $VERSION = '0.0.4';
require WebService::Shippo::Entities;
require WebService::Shippo::Request;
require WebService::Shippo::Config;
use base ( 'Exporter' );

our @EXPORT_OK = qw(
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
    shippo_return_shipment_create
    shippo_transaction
    shippo_transaction_list
    shippo_transaction_create
);
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

#<<< Don't Perl Tidy this
sub shippo_address                    { Shippo::Address->get( @_ ) }
sub shippo_address_list               { Shippo::Address->all( @_ ) }
sub shippo_address_validate           { Shippo::Address->validate( @_ ) }
sub shippo_address_create             { Shippo::Address->create( @_ ) }
sub shippo_carrier_account            { Shippo::CarrierAccount->get( @_ ) }
sub shippo_carrier_account_list       { Shippo::CarrierAccount->all( @_ ) }
sub shippo_carrier_account_create     { Shippo::CarrierAccount->create( @_ ) }
sub shippo_carrier_account_update     { Shippo::CarrierAccount->update( @_ ) }
sub shippo_customs_declaration        { Shippo::CustomsDeclaration->get( @_ ) }
sub shippo_customs_declaration_list   { Shippo::CustomsDeclaration->all( @_ ) }
sub shippo_customs_declaration_create { Shippo::CustomsDeclaration->create( @_ ) }
sub shippo_customs_item               { Shippo::CustomsItem->get( @_ ) }
sub shippo_customs_item_list          { Shippo::CustomsItem->all( @_ ) }
sub shippo_customs_item_create        { Shippo::CustomsItem->create( @_ ) }
sub shippo_manifest                   { Shippo::Manifest->get( @_ ) }
sub shippo_manifest_list              { Shippo::Manifest->all( @_ ) }
sub shippo_manifest_create            { Shippo::Manifest->create( @_ ) }
sub shippo_parcel                     { Shippo::Parcel->get( @_ ) }
sub shippo_parcel_list                { Shippo::Parcel->all( @_ ) }
sub shippo_parcel_create              { Shippo::Parcel->create( @_ ) }
sub shippo_rate                       { Shippo::Rate->get( @_ ) }
sub shippo_rate_list                  { Shippo::Rate->all( @_ ) }
sub shippo_refund                     { Shippo::Refund->get( @_ ) }
sub shippo_refund_list                { Shippo::Refund->all( @_ ) }
sub shippo_refund_create              { Shippo::Refund->create( @_ ) }
sub shippo_shipment                   { Shippo::Shipment->get( @_ ) }
sub shippo_shipment_list              { Shippo::Shipment->all( @_ ) }
sub shippo_shipment_create            { Shippo::Shipment->create( @_ ) }
sub shippo_shipment_rates             { Shippo::Shipment->rates( @_ ) }
sub shippo_return_shipment_create     { Shippo::ReturnShipment->create( @_ ) }
sub shippo_transaction                { Shippo::Transaction->get( @_ ) }
sub shippo_transaction_list           { Shippo::Transaction->all( @_ ) }
sub shippo_transaction_create         { Shippo::Transaction->create( @_ ) }
#>>>

BEGIN {
    no warnings 'once';
    # There are some useful mutators defined elsewhere that I'd like to
    # make available (alias) via the root namespace.
    *api_key  = *WebService::Shippo::Resource::api_key;
    *PRETTY   = *WebService::Shippo::Object::PRETTY;
    *response = *WebService::Shippo::Request::response;
         # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
         # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo:: = *WebService::Shippo::;
}

sub import
{
    my ( $class ) = @_;
    # Configure Shippo client on import
    Shippo::Config->config;
    # The API key is overridden with the envornment's value if defined.
    Shippo::Resource->api_key( $ENV{SHIPPO_TOKEN} )
        if $ENV{SHIPPO_TOKEN};
    # Pass call frame to Exporter's import for it's processing
    goto &Exporter::import;
}

1;

=pod

=encoding utf8

=head1 NAME

WebService::Shippo - A Shippo API Perl Wrapper (coming soon)

=head1 SYNOPIS

    # TO FOLLOW
    
=head1 DESCRIPTION

Will provide a Shippo API client implementation for Perl.

This is a work in progress and is being actively developed with regular 
updates as work progresses.

=head1 AUTHOR

Iain Campbell <cpanic@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012-2015 by Iain Campbell.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
