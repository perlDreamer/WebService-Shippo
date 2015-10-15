use strict;
use warnings;

package API::Shippo;
# ABSTRACT: Shippo Perl API wrapper
our $VERSION = '0.0.1';
use Carp ( 'croak' );
use API::Shippo::Config;
use API::Shippo::Address;
use API::Shippo::CustomsItem;
use API::Shippo::CustomsDeclaration;
use API::Shippo::Manifest;
use API::Shippo::Parcel;
use API::Shippo::Refund;
use API::Shippo::Shipment;
use API::Shippo::Transaction;
use API::Shippo::Rate;
use API::Shippo::CarrierAccount;

sub import
{
    my ( $class )     = @_;
    my $c             = API::Shippo::Config->config;
    my $private_token = $c->{private_token};
    my $public_token  = $c->{public_token};
    my $default_token = $c->{default_token} || 'public_token';
    # Setup some resource defaults
    API::Shippo::Resource->api_private_token( $private_token );
    API::Shippo::Resource->api_public_token( $public_token );
    API::Shippo::Resource->api_token( $c->{$default_token} );
    goto &Exporter::import;
}

=pod

=encoding utf8

=head1 NAME

API::Shippo - A Shippo API Perl Wrapper (coming soon)

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
