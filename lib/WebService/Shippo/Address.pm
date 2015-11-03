use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Address;
require WebService::Shippo::Request;
use Carp              ( 'confess' );
use Params::Callbacks ( 'callbacks' );
use Scalar::Util      ( 'blessed' );
use base (
    'WebService::Shippo::Resource',
    'WebService::Shippo::Creator',
    'WebService::Shippo::Fetcher',
);

sub api_resource ()     { 'addresses' }
sub collection_class () { 'WebService::Shippo::Addresses' }
sub item_class ()       { __PACKAGE__ }

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

package    # Hide from PAUSE
    WebService::Shippo::Addresses;
use base ( 'WebService::Shippo::Collection' );
sub item_class ()       { 'WebService::Shippo::Address' }
sub collection_class () { __PACKAGE__ }

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Address::     = *WebService::Shippo::Address::;
    *Shippo::AddressList:: = *WebService::Shippo::AddressList::;
}

1;

=pod

=encoding utf8

=head1 NAME

WebService::Shippo::Address - Work with Shippo Address objects.

=head1 SYNOPIS

B<Note>: Though you must C<use WebService::Shippo> when importing the
Shippo API wrapper, you may freely discard the leading C<WebService::>
portion of the namespace when subsequently referring to classes that
make up this distribution. You will see this practice being employed
consistently in example code.

    use strict;
    use WebService::Shippo;
    
    # Put your Shippo Auth Token here, if it isn't defined elsewhere
    Shippo->api_key( 'PASTE YOUR PRIVATE AUTH TOKEN HERE' )
        unless Shippo->api_key;
    
    # Create an address object
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
    
    # Validate an address (one way)
    my $validated_address = Shippo::Address->validate($address->object_id);
    
    # Validate an address (another way)
    $validated_address = $address->validate;
    
    # Fetch an address
    my $object_id = $validated_address->object_id;
    $address = Shippo::Address->fetch($object_id);
    
    # List all my addresses (only two requests but result could be huge!!)
    my $address_list = Shippo::Address->list;
    for my $address ( $address_list->items ) {
        print $address->object_id, "\n";
    }
    
    # List all my addresses (throttle the results window size)
    my $address_list = Shippo::Address->list( results => 5 );
    while ( 1 ) {
        for my $address ( $address_list->items ) {
            print $address->object_id, "\n";
        }
        $address_list = $address_list->next_page;
        last unless $address_list;
    }
    
    # A bit complicated all that! You could just use an iterator and dispense
    # with all that pagination nonsense; the default results window size is 5
    # but you can increase that to reduce the number of API requests.
    my $it = Shippo::Address->iterator( results => 25 );
    while ( my $address = $it->() ) {
        print $address->object_id, "\n";
    }
    
=head1 DESCRIPTION

Address objects are used for creating Shipments, obtaining Rates and printing
Labels, and thus are one of the fundamental building blocks of the Shippo
API.

=head1 METHODS

=head2 all

    $collection = Shippo::Address->all(\%params)
        or die 'Empty result set';
    $collection = Shippo::Address->all(@params)
        or die 'Empty result set';
    $collection = Shippo::Address->all
        or die 'Empty result set';

The C<all> method is used to fetch multiple address objects as a collection.

=head2 create

    $object = Shippo::Address->create(\%params);
    $object = Shippo::Address->create(@params);

This C<create> method is used to create new address objects.

=head2 fetch

    $object = Shippo::Address->fetch($object_id);

This C<create> method is used to create new address objects.

=head2 validate

    $validated_address = Shippo::Address->validate($object_id);
    $validated_address = $address->validate($object_id);
    $validated_address = $address->validate;

This method has the Shippo API validate an address object. 

By checking if an address exists in the USPS database, this method provides
a means to verify that an address is valid. If the address provided contains
some fields that are inaccurate, the API will attempt to correct these
fields.

The address to be validated may be identified by its C<object_id> attribute,
passed in as C<$object_id>. When no C<$object_id> argument is passed, the
dereferenced address object is validated.

This method will return a B<new validated address object> with an C<object_source>
attribute set to B<VALIDATOR>. It does not enrich the original input address
object, which may be discarded after successful validation.

If the operation is successful then the returned address object will also
have its C<object_state> set to B<VALID>. Otherwise, if the address is too
ambiguous and cannot be corrected, it will be set to B<INVALID>.

I<Note: Address validation is currently only possible for US addresses.>

B<Examples>

=over 2

=item 1. Let's validate a newly created address using C<validate> as a static
method:

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
    
    $address = Shippo::Address->validate( $address->object_id );
    print $address->to_json(1);

This call returns a new version of the address with some of the detail
cleaned-up a little. In the example above we passed in the C<object_id>
attribute of the address object we created and we got back a brand new
object that has been successfully validated.

    {
       "city" : "WOODRIDGE",
       "company" : "Initech",
       "country" : "US",
       "email" : "user@gmail.com",
       "ip" : "",
       "is_residential" : true,
       "messages" : [],
       "metadata" : "Customer ID 123456",
       "name" : "John Smith",
       "object_created" : "2015-11-03T10:15:24.173Z",
       "object_id" : "dceba591d4ad4c95bb0935876ffc065f",
       "object_owner" : "******@********.***",
       "object_purpose" : "PURCHASE",
       "object_source" : "VALIDATOR",
       "object_state" : "VALID",
       "object_updated" : "2015-11-03T10:15:24.186Z",
       "phone" : "0012343467333",
       "state" : "IL",
       "street1" : "6512 GREENE RD",
       "street2" : "",
       "street_no" : "",
       "zip" : "60517-5402"
    }

=item 2. Now we'll repeat the operation again, this time using C<validate>
as an instance method:

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

    $address = $address->validate;
    print $address->to_json(1);

Exactly the same behaviour, but a different object is returned.

    {
       "city" : "WOODRIDGE",
       "company" : "Initech",
       "country" : "US",
       "email" : "user@gmail.com",
       "ip" : "",
       "is_residential" : true,
       "messages" : [],
       "metadata" : "Customer ID 123456",
       "name" : "John Smith",
       "object_created" : "2015-11-03T10:33:20.677Z",
       "object_id" : "53084234429e413fa8d74d4d840600f8",
       "object_owner" : "******@********.***",
       "object_purpose" : "PURCHASE",
       "object_source" : "VALIDATOR",
       "object_state" : "VALID",
       "object_updated" : "2015-11-03T10:33:20.689Z",
       "phone" : "0012343467333",
       "state" : "IL",
       "street1" : "6512 GREENE RD",
       "street2" : "",
       "street_no" : "",
       "zip" : "60517-5402"
    }

In this and in the previous example, we can see that the address 
object was successfully validated by inspecting the C<object_source>
and C<object_state> attributes.
    
=back

=head1 API DOCUMENTATION

For more information about Address objects, consult the Shippo API
documentation:

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
