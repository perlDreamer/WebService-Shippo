use strict;
use warnings;

package WebService::Shippo;
# ABSTRACT: Shippo Perl API wrapper
our $VERSION = '0.0.1';
require WebService::Shippo::Config;
require WebService::Shippo::Address;
require WebService::Shippo::CustomsItem;
require WebService::Shippo::CustomsDeclaration;
require WebService::Shippo::Manifest;
require WebService::Shippo::Parcel;
require WebService::Shippo::Refund;
require WebService::Shippo::Shipment;
require WebService::Shippo::Transaction;
require WebService::Shippo::Rate;
require WebService::Shippo::CarrierAccount;
use base ( 'Exporter' );

BEGIN {
    no warnings 'once';
    # There are some useful mutators defined elsewhere that I'd like to
    # make available (alias) via the WebService::Shippo namespace.
    *config            = *WebService::Shippo::Config::config;
    *api_private_token = *WebService::Shippo::Resource::api_private_token;
    *api_public_token  = *WebService::Shippo::Resource::api_public_token;
    *api_key           = *WebService::Shippo::Resource::api_key;
}

sub import
{
    my ( $class ) = @_;
    # Load authentication data from config file.
    my $config = __PACKAGE__->config;
    my $default_token = $config->{default_token} || 'private_token';
    __PACKAGE__->api_private_token( $config->{private_token} );
    __PACKAGE__->api_public_token( $config->{public_token} );
    __PACKAGE__->api_key( $config->{$default_token} );
    goto &Exporter::import;
}

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

1;
