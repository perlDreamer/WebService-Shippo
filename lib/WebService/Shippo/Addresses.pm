use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Addresses;
require WebService::Shippo::Address;
use base qw(
    WebService::Shippo::Collection
    WebService::Shippo::Create
    WebService::Shippo::Fetch
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

WebService::Shippo::Addresses - Address collection class

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

    use WebService::Shippo;
    
    # If your client doesn't use a configuration file and you haven't set the
    # SHIPPO_TOKEN environment variable, you should provide authentication
    # details below:
    #
    Shippo->api_key( 'PASTE YOUR PRIVATE AUTH TOKEN HERE' )
        unless Shippo->api_key;
    
    $collection = Shippo::Addresses->all;
    while ( $collection ) {
        for $address ( $collection->results ) {
            print "$address->{object_id}\n";
        }
        $collection = $collection->next_page;
    }

=head1 DESCRIPTION

Address objects are used for creating Shipments, obtaining Rates and printing
Labels, and thus are one of the fundamental building blocks of the Shippo
API.

=head1 SEE ALSO

=over 2

=item * L<WebService::Shippo::Address>

=item * L<WebService::Shippo::Collection>

=back

=head1 API DOCUMENTATION

For more information about Addresses, consult the Shippo API documentation:

=over 2

=item * L<https://goshippo.com/docs/#addresses>

=back

=head1 REPOSITORY

=over 2

=item * L<https://github.com/cpanic/WebService-Shippo>

=back

=head1 AUTHOR

Iain Campbell <cpanic@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Iain Campbell.

You may distribute this software under the terms of either the GNU General
Public License or the Artistic License, as specified in the Perl README
file.


=cut
