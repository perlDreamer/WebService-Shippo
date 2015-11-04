use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Manifest;
use base (
    'WebService::Shippo::Resource',
    'WebService::Shippo::Creator',
    'WebService::Shippo::Fetcher',
);

sub api_resource ()     { 'manifests' }
sub collection_class () { 'WebService::Shippo::Manifests' }
sub item_class ()       { __PACKAGE__ }

package    # Hide from PAUSE
    WebService::Shippo::Manifests;
use base ( 'WebService::Shippo::Collection' );

sub item_class ()       { 'WebService::Shippo::Manifest' }
sub collection_class () { __PACKAGE__ }

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Manifest::  = *WebService::Shippo::Manifest::;
    *Shippo::Manifests:: = *WebService::Shippo::Manifests::;
}

1;

=pod

=encoding utf8

=head1 NAME

WebService::Shippo::CarrierAccount - Manifest class

=head1 DESCRIPTION

Carrier accounts are used as credentials to retrieve shipping rates
and purchase labels from a shipping provider.

=head1 API DOCUMENTATION

For more information about Manifests, consult the Shippo API documentation:

=over 2

=item * L<https://goshippo.com/docs/#manifests>

=back

=head1 REPOSITORY

=over 2

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
