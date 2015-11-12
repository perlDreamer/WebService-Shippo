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

B<Note>: Though you must C<use WebService::Shippo> when importing the
Shippo API wrapper, you may freely discard the leading C<WebService::>
portion of the namespace when subsequently referring to classes that
make up this distribution. You will see this practice being employed
consistently in example code.

    # This file can be found in the distribution:
    # bin/synopses/addresses.pl
    #
    use strict;
    use WebService::Shippo;
    use Test::More;
    
    # If your client doesn't use a configuration file and you haven't set the
    # SHIPPO_TOKEN environment variable, you should provide authentication
    # details below:
    #
    Shippo->api_key( 'PASTE YOUR PRIVATE AUTH TOKEN HERE' )
        unless Shippo->api_key;
    
    diag 'Create an address';
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
    diag $address->to_string;
    
    my $id = $address->object_id;
    diag "Fetch an address object identified by its object_id ($id)";
    $address = Shippo::Address->fetch( $id );
    diag $address->to_string;
    
    diag 'Validate the address object';
    my $val_1 = $address->validate;
    diag $val_1->to_string;
    
    diag "Validate an address object identified by its object_id ($id)";
    my $val_2 = Shippo::Address->validate( $id );
    diag $val_2->to_string;
    
    diag "Get 'all' (but really the first 200 or less) address objects";
    {
        my $collection = Shippo::Addresses->all;
        for my $address ( $collection->results ) {
            print "$address->{object_id}\n";
        }
    }
    
    diag "Really get all address objects";
    {
        my $collection = Shippo::Addresses->all;
        while ( $collection ) {
            for my $address ( $collection->results ) {
                print "$address->{object_id}\n";
            }
            $collection = $collection->next_page;
        }
    }
    
    diag "Simple iteration through entire object collection";
    {
        my $it = Shippo::Address->iterator();
        while ( my ( $address ) = $it->() ) {
            print "$address->{object_id}\n";
        }
    }
    
    diag "Specialised iterator using a sequence of lambda functions as a filter";
    {
        my $next_validated_purchase_address = Shippo::Address->iterator(
            callback {
                my ( $address ) = @_;
                # Discard address unless validated and valid
                return
                    unless $address->object_source eq 'VALIDATOR'
                    && $address->object_state eq 'VALID';
                # Else, keep address
                return $address;
            }
            callback {
                my ( $address ) = @_;
                # Discard address unless created for transaction
                return
                    unless $address->object_purpose eq 'PURCHASE';
                # Else, keep address
                return $address;
            }
        );
    
        while ( my ( $address ) = $next_validated_purchase_address->() ) {
            print $address;    # Automatically stringified using "to_string";
        }
    }
    
    diag "Collector using a sequence of lambda functions as a filter";
    {
        my $all_validated_purchase_addresses = Shippo::Address->collector(
            callback {
                my ( $address ) = @_;
                # Discard address unless validated and valid
                return
                    unless $address->object_source eq 'VALIDATOR'
                    && $address->object_state eq 'VALID';
                # Else, keep address
                return $address;
            }
            callback {
                my ( $address ) = @_;
                # Discard address unless created for transaction
                return
                    unless $address->object_purpose eq 'PURCHASE';
                # Else, keep address
                return $address;
            }
        );
    
        for my $address ( $all_validated_purchase_addresses->() ) {
            print $address;
        }
    }
    
=head1 DESCRIPTION

Address objects are used for creating Shipments, obtaining Rates and printing
Labels, and thus are one of the fundamental building blocks of the Shippo
API.

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
