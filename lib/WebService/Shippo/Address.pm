use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Address;
require WebService::Shippo::Request;
use Carp              ( 'confess' );
use Params::Callbacks ( 'callbacks' );
use Scalar::Util      ( 'blessed' );
use base qw(
    WebService::Shippo::Resource
    WebService::Shippo::Create
    WebService::Shippo::Fetch
);

sub api_resource () { 'addresses' }

sub collection_class () { 'WebService::Shippo::Addresses' }

sub item_class () { __PACKAGE__ }

sub validate
{
    my ( $callbacks, $invocant, $object_id, @params ) = &callbacks;
    if ( blessed( $invocant ) ) {
        $object_id = $invocant->id
            unless $object_id;
        # Don't make unnecessary call to API if address was already validated
        return $invocant
            if $invocant->id eq $object_id
            && $invocant->source eq 'VALIDATOR'
            && $invocant->state eq 'VALID';
    }
    confess 'Expected an object id'
        unless $object_id;
    my $url = $invocant->url( "$object_id/validate" );
    my $response = WebService::Shippo::Request->get( $url, @params );
    return $invocant->construct_from( $response, $callbacks );
}

BEGIN {
    no warnings 'once';
    *Shippo::Address:: = *WebService::Shippo::Address::;
}

1;

=pod

=encoding utf8

=head1 NAME

WebService::Shippo::Address - Address class

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
    # details below.

    Shippo->api_key( 'PASTE YOUR PRIVATE AUTH TOKEN HERE' )
        unless Shippo->api_key;
    
    # Create a new address object.
    
    $address = Shippo::Address->create(
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
    
    # Serialize the address object as JSON.
    
    print $address->to_json;        # Not Pretty
    print $address->to_string;      # Pretty
    print $address;                 # Pretty and automatically stringified

    # Fetch an address object using its object_id.
    
    $object_id = $address->object_id;
    $address   = Shippo::Address->fetch($object_id);

    # Validate an address object (returns a new validated address object).
       
    $address = $address->validate;

    # Validate an address object using its object_id.
    
    $address = Shippo::Address->validate($object_id);
    
    # Get all my address objects. Particularly with a collection as
    # potentially large as for addresses, "all" is actually a bit of a
    # fib. The maximum size for any cursor is 200 items, so the "all"
    # method will return a collection containing 200 or fewer objects.
    
    $collection = Shippo::Addresses->all;
    for $address ( $collection->results ) {
        print $address;
    }
    
    # To cover the entire collection, you could use two loops and combine
    # the "all" with the "next_page" methods. This example lists only the
    # addresses that were validated and used for a transaction.
    
    $collection = Shippo::Addresses->all;
    while ( $collection ) {
        for $address ( $collection->results ) {
            next unless $address->object_source  eq 'VALIDATOR'
                     && $address->object_state   eq 'VALID';
            next unless $address->object_purpose eq 'PURCHASE';
            print $address;
        }
        $collection = $collection->next_page;
    }
    
    # Or, you can dispense with the potentially ugly pagination and
    # use a single loop and a simple iterator. Again, we place the
    # filter code inside the loop, which does the job well enough.
    
    $next_address = Shippo::Addresses->iterate();
    while ( my ( $address ) = $next_address->() ) {
        next unless $address->object_source  eq 'VALIDATOR'
                 && $address->object_state   eq 'VALID';
        next unless $address->object_purpose eq 'PURCHASE';
        print $address;
    }
    
    # Or, single loop again with a named and specialised iterator. The filter
    # code is a sequence of lambda functions called by the iterator. Suitable
    # objects pass through the filter sequence while others are discarded. In
    # this case the lambda sequence could be expressed as a single callback,
    # but has been presented as a sequence for illustrative purposes.
    
    my $next_validated_purchase_address = Shippo::Addresses->iterate(
        callback {
            return unless $_[0]->object_source  eq 'VALIDATOR'
                       && $_[0]->object_state   eq 'VALID';
            return $_[0];
        } 
        callback {
            return unless $_[0]->object_purpose eq 'PURCHASE';
            return $_[0];
        }
    );
    
    while ( my ( $address ) = $next_validated_purchase_address->() ) {
        print $address;
    }

    # Or, single loop again with a named and specialised collector. The
    # collector uses an iterator to gather the result set, returning the
    # entire set once it is complete. The filter code is a sequence of
    # lambda functions called by the collector. Suitable objects pass
    # through the filter while others are discarded.
    
    my $all_validated_purchase_addresses = Shippo::Addresses->collect(
        callback {
            return unless $_[0]->object_source  eq 'VALIDATOR'
                       && $_[0]->object_state   eq 'VALID'
                       && $_[0]->object_purpose eq 'PURCHASE';
            return $_[0];
        } 
    );

    for my $address ( $all_validated_purchase_addresses->() ) {
        print $address;
    }
    
=head1 DESCRIPTION

Address objects are used for creating Shipments, obtaining Rates and printing
Labels, and thus are one of the fundamental building blocks of the Shippo
API.

=head1 SEE ALSO

=over 2

=item * L<WebService::Shippo::Addresses>

=item * L<WebService::Shippo::Object>

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
