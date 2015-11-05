[![Build Status](https://travis-ci.org/cpanic/WebService-Shippo.svg?branch=master)](https://travis-ci.org/cpanic/WebService-Shippo) [![Coverage Status](https://coveralls.io/repos/cpanic/WebService-Shippo/badge.svg?branch=master&service=github)](https://coveralls.io/github/cpanic/WebService-Shippo?branch=master)

## Shippo API Perl Client

The Shippo API can be used to automate and customize shipping capabilities for your e-commerce store or marketplace, enabling you to retrieve shipping rates, create and purchase shipping labels, track packages, and much more.

Shippo connects you with multiple shipping providers (USPS, UPS and Fedex, for example) through one interface, offering you great discounts on a selection of shipping rates.

You can sign-up for an account at https://goshippo.com/.

While Shippo do offer official API clients for a bevy of major languages, the venerable Perl is not among them. This client is a community offering that attempts to fill that void.

###PRE-RELEASE SOFTWARE

**Though functional, this software is still very much in the process of being
documented and should therefore be considered a work in progress.** 

### Version

* 0.0.14 (2015-11-05) on CPAN

### Requirements

Perl 5.8.8 minimum. 

Build tests have been conducted successfully on all later versions of Perl.

### Dependencies

<table>
<thead>
<tr>
<th align="left">Implementation</th>
<th align="left">Testing</th>
</tr>
</thead>
<tbody>
<tr>
<td valign="top">
<tt>boolean</tt><br/>
<tt>Clone</tt><br/>
<tt>File::HomeDir</tt><br/>
<tt>JSON::XS</tt><br/>
<tt>LWP</tt><br/>
<tt>LWP::Protocol::https</tt><br/>
<tt>Locale::Codes</tt><br/>
<tt>MRO::Compat</tt><br/>
<tt>Params::Callbacks</tt><br/>
<tt>Path::Class</tt><br/>
<tt>Sub::Util</tt><br/>
<tt>Time::HiRes</tt><br/>
<tt>URI::Encode</tt><br/>
<tt>YAML::XS</tt><br/>
</td>
<td valign="top">
<tt>Data::Dumper::Concise</tt><br/>
<tt>Test::Deep</tt><br/>
</td>
</tr>
</tbody>
</table>

The Shippo API Perl Client depends on the non-core modules listed in the table above.

### Testing

Testing is standard operating procedure when installing Perl modules, since
test suites must normally complete successfully before a distribution can
be installed.

Be aware that, if you attempt to install this distribution without
first taking steps to configure Shippo API authentication, the testing
phase of installation will be _skipped_ rather than fail. It may still fail
if there are more fundamental problems with your Perl environment, but in
all likelihood the installation will complete without running all of its
tests.

You should probably run those tests.

Before installing the distribution, you should be in possession of a set
of Shippo API Authentication Tokens. You can get these by registering for
an account&mdash;go to https://goshippo.com/register. Once you have your
tokens, simply define the `SHIPPO_TOKEN` environment variable using the
**Private Auth Token** as the value. 

For example:

```shell
export SHIPPO_TOKEN="1a2b3c4d5e6ff7e8d9c0b1a21a2b3c4d5e6ff7e8"
```

Now, if you install the module, the tests should run.

### Installation

The Shippo API Perl Client is distributed on CPAN:

* http://search.cpan.org/dist/WebService-Shippo/lib/WebService/Shippo.pm

It is installed like the majority of Perl modules. If you have never installed a Perl module before then I recommend using `cpanminus` because it's super easy!

If you have never used `cpanminus` before then you can install this package
by running one of the following commands:

```shell
sudo -s 'curl -L cpanmin.us | perl - WebService::Shippo'

# If you're developing under PerlBrew then you probably don't want
# to use sudo...

curl -L cpanmin.us | perl - WebService::Shippo
```

If you **have** used `cpanminus` before then one of the following commands
will do the job:

```shell
sudo -s cpanm WebService::Shippo

# If you're developing under PerlBrew then you probably don't want
# to use sudo...

cpanm WebService::Shippo
```

### Installing from GitHub

Clone this repository only if you need to make changes. The distribution is 
managed using `Dist::Zilla`, which will have dependency requirements of
its own.

### Using the Shippo API Perl Client

```perl
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

print 'Success with Address 1 : ', $address
```

All being well, you should see something like the following output:

```
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
```
For additional integration notes, visit the [project wiki pages](https://github.com/cpanic/WebService-Shippo/wiki).
### Full API documentation

* For API documentation, go to https://goshippo.com/docs/ 
* For API support, contact support@goshippo.com with any questions.

### ACKNOWLEDGEMENTS

Thanks to Ali Saheli and the wonderful folks at Shippo for assistance
rendered.

### COPYRIGHT

This software is copyright &copy; 2015 by Iain Campbell.

You may distribute this software under the terms of either the GNU General
Public License or the Artistic License, as specified in the Perl README
file.

### SUPPORT / WARRANTY

The Shippo API Perl Client is free Open Source software; _it comes without
warranty of any kind._

