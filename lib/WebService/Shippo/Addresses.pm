use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Addresses;
require WebService::Shippo::Address;
use base qw(
    WebService::Shippo::Collection
    WebService::Shippo::Creator
    WebService::Shippo::Fetcher
);

sub item_class () { 'WebService::Shippo::Address' }

sub collection_class () { __PACKAGE__ }

BEGIN {
    no warnings 'once';
    *Shippo::Addresses:: = *WebService::Shippo::Addresses::;
}

1;

=pod

=encoding utf8

=head1 NAME

WebService::Shippo::Addresses - A Shippo Address Collection

=head1 DESCRIPTION

Address objects are used for creating Shipments, obtaining Rates and printing
Labels, and thus are one of the fundamental building blocks of the Shippo
API.

=back

=head1 API DOCUMENTATION

For more information about Addresses, consult the Shippo API documentation:

=over 2

=item * L<https://goshippo.com/docs/#addresses>

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
