use strict;
use warnings;

package WebService::Shippo;
# ABSTRACT: A Shippo Perl API wrapper
our $VERSION = '0.0.14';
require WebService::Shippo::Entities;
use boolean ':all';
use Params::Callbacks ( 'callbacks', 'callback' );
use base ( 'Exporter' );

our @EXPORT = qw(
    true
    false
    boolean
    callback
);

our @EXPORT_OK = qw(
    isTrue
    isFalse
    isBoolean
    callbacks
);
our %EXPORT_TAGS = ( all => [ @EXPORT, @EXPORT_OK ], bool => $boolean::EXPORT_TAGS{all} );

sub import
{
    my ( $class ) = @_;
    # Configure Shippo client on import
    WebService::Shippo::Config->config;
    # The API key is overridden with the envornment's value if defined.
    WebService::Shippo::Resource->api_username_password(
        @ENV{ 'SHIPPO_USER', 'SHIPPO_PASS' } )
        if $ENV{SHIPPO_USER} && !$ENV{SHIPPO_TOKEN};
    WebService::Shippo::Resource->api_key( $ENV{SHIPPO_TOKEN} )
        if $ENV{SHIPPO_TOKEN};
    # Pass call frame to Exporter's import for further processing
    goto &Exporter::import;
}

BEGIN {
    no warnings 'once';
    # There are some useful symbols defined elsewhere that I'd like to
    # make available (alias) via the root namespace.
    *api_key               = *WebService::Shippo::Resource::api_key;
    *api_username_password = *WebService::Shippo::Resource::api_username_password;
    *config                = *WebService::Shippo::Config::config;
    *pretty                = *WebService::Shippo::Object::pretty;
    *response              = *WebService::Shippo::Request::response;
    *Response              = *WebService::Shippo::Request::response;
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo:: = *WebService::Shippo::;
}

1;

=pod

=encoding utf8

=head1 NAME

WebService::Shippo - A Shippo API Perl Wrapper (pre-release)

=head1 SYNOPIS

Shippo is a shipping API that connects you with multiple shipping providers
(such as USPS, UPS, and Fedex) through one interface, and offers you great
discounts on shipping rates.

Don't have an account? Sign up at L<https://goshippo.com/>

    use strict;
    use WebService::Shippo;
    
    # If it hasn't already done outside of the script, you
    # must set your API key...
    Shippo->api_key( 'PASTE YOUR PRIVATE AUTH TOKEN HERE' )
        unless Shippo->api_key;
    
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
    
    print 'Success with Address 1 : ', $address->to_json;

All being well, you should see something like this:

    Success with Address 1 : {
       "city" : "Woodridge",
       "company" : "Initech",
       "country" : "US",
       "email" : "user@gmail.com",
       "ip" : null,
       "is_residential" : null,
       "messages" : [],
       "metadata" : "Customer ID 123456",
       "name" : "John Smith",
       "object_created" : "2015-10-16T16:14:16.296Z",
       "object_id" : "475bb05d72b74a08a1d44b40ac85d635",
       "object_owner" : "******@*********.***",
       "object_purpose" : "PURCHASE",
       "object_source" : "FULLY_ENTERED",
       "object_state" : "VALID",
       "object_updated" : "2015-10-16T16:14:16.296Z",
       "phone" : "0012343467333",
       "state" : "IL",
       "street1" : "6512 Greene Rd.",
       "street2" : "",
       "street_no" : "",
       "zip" : "60517"
    }
    
=head1 DESCRIPTION

=head1 FULL API DOCUMENTATION

=over 2

=item * For API documentation, go to L<https://goshippo.com/docs/>

=item * For API support, contact L<mailto:support@goshippo.com> with any 
questions.

=back

=head1 REPOSITORY

=over 2

=item * L<http://search.cpan.org/dist/WebService-Shippo/lib/WebService/Shippo.pm>

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
