use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::CustomsDeclaration;
use base (
    'WebService::Shippo::Resource',
    'WebService::Shippo::Creator',
    'WebService::Shippo::Fetcher',
);

sub api_resource ()     { 'customs/declarations' }
sub collection_class () { 'WebService::Shippo::CustomsDeclarations' }
sub item_class ()       { __PACKAGE__ }

package    # Hide from PAUSE
    WebService::Shippo::CustomsDeclarations;
use base ( 'WebService::Shippo::Collection' );

sub item_class ()       { 'WebService::Shippo::CustomsDeclaration' }
sub collection_class () { __PACKAGE__ }

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::CustomsDeclaration::  = *WebService::Shippo::CustomsDeclaration::;
    *Shippo::CustomsDeclarations:: = *WebService::Shippo::CustomsDeclarations::;
}

1;

=pod

=encoding utf8

=head1 NAME

WebService::Shippo::CustomsDeclaration - Customs Declaration class

=head1 DESCRIPTION

Customs declarations are relevant information, including one or
multiple customs items, you need to provide for customs clearance
for your international shipments.

=head1 API DOCUMENTATION

For more information about Customs Declarations, consult the Shippo API
documentation:

=over 2

=item * L<https://goshippo.com/docs/#customsdeclarations>

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
