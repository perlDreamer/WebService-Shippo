use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::CustomsItem;
use base (
    'WebService::Shippo::Resource',
    'WebService::Shippo::Creator',
    'WebService::Shippo::Fetcher',
);

sub api_resource ()     { 'customs/items' }
sub collection_class () { 'WebService::Shippo::CustomsItems' }
sub item_class ()       { __PACKAGE__ }

package    # Hide from PAUSE
    WebService::Shippo::CustomsItems;
use base ( 'WebService::Shippo::Collection' );
sub item_class ()       { 'WebService::Shippo::CustomsItem' }
sub collection_class () { __PACKAGE__ }

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::CustomsItem::  = *WebService::Shippo::CustomsItem::;
    *Shippo::CustomsItems:: = *WebService::Shippo::CustomsItems::;
}

1;

=pod

=encoding utf8

=head1 NAME

WebService::Shippo::CustomsItem - Shippo Customs Item

=head1 DESCRIPTION

Customs items are distinct items in your international shipment parcel.

=head1 API DOCUMENTATION

For more information about CustomsItem objects, consult the Shippo API
documentation:

=over 2

=item * L<https://goshippo.com/docs/#customsitems>

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
