[![Language](https://img.shields.io/badge/perl-v5.8%20to%205.22-blue.svg)](https://img.shields.io/badge/perl-v5.8%20to%205.22-blue.svg) [![Build Status](https://travis-ci.org/cpanic/WebService-Shippo.svg?branch=master)](https://travis-ci.org/cpanic/WebService-Shippo) [![Coverage Status](https://coveralls.io/repos/cpanic/WebService-Shippo/badge.svg?branch=master&service=github)](https://coveralls.io/github/cpanic/WebService-Shippo?branch=master)

## Shippo Perl API Client, v0.0.3

Shippo is a shipping API that connects you with multiple shipping 
providers (such as USPS, UPS, and Fedex) through one interface, and offers 
you great discounts on shipping rates.

Don't have an account? Sign up at https://goshippo.com/

### Requirements

Perl 5.8.8 minimum. 

Build tests have been conducted successfully on all later versions of Perl.

_**The Shippo Perl API Client is functional but is in a pre-release stage of its development. There are still tests and documentation to be written, and those tasks are currently under way.**_

### Dependencies

* `File::HomeDir`
* `JSON::XS`
* `LWP`
* `MRO::Compat`
* `Path::Class`
* `URI::Encode`
* `YAML::XS`

The Shippo Perl client depends on the seven modules listed above.

### Installation

The Shippo Perl API Client is distributed using CPAN and may be installed just like any other Perl module. If you have never installed a Perl module before then I recommend using `cpanminus` because it's super easy!

If you have never used `cpanminus` before then you can install this package by running one of the following commands:

```shell
sudo -s 'curl -L cpanmin.us | perl - WebService::Shippo'

# If you're developing under PerlBrew then you probably don't want
# to use sudo...

curl -L cpanmin.us | perl - WebService::Shippo
```

If you **have** used `cpanminus` before then one of the following commands will do the job:

```shell
sudo -s cpanm WebService::Shippo

# If you're developing under PerlBrew then you probably don't want
# to use sudo...

cpanm WebService::Shippo
```
### Testing

Testing is standard operating procedure when installing Perl modules as test suites must normally complete successfully before a distribution is installed.

Just be aware that if you attempt to install this distribution, without first taking steps to configure authentication for the Shippo API, then the testing phase of installation will be skipped and will only fail if there are more fundamental problems with your Perl environment. In all likelihood, the distribution will install without running its tests.

You probably ought to run the tests.

Before installing the distribution, you should be in possession of a set of Shippo Auth Tokens. You can get these by registering (https://goshippo.com/register). Once you have a pair of tokens,
simply define the SHIPPO_TOKEN environment variable using the _Private Auth Token_ as the value. For example:

```shell
export SHIPPO_TOKEN="1a2b3c4d5e6ff7e8d9c0b1a21a2b3c4d5e6ff7e8"
```

Now install the module and the tests should run.

### Using the Shippo Perl API Client

```perl
use strict;
use WebService::Shippo;

# Following statement is not necessary if SHIPPO_TOKEN is set in
# your process environment.
Shippo->api_key(PRIVATE-AUTH-TOKEN);

my $address1 = Shippo::Address->create({
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
});

print 'Success with Address 1 : ', $address

# All being well, you should see something like the following output:

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
### Full API documentation

* For API documentation, go to https://goshippo.com/docs/ 
* For API support, contact support@goshippo.com with any questions.

### ACKNOWLEDGEMENTS

Thanks to Ali Saheli and the wonderful folks at Shippo for assistance rendered.

### COPYRIGHT

The Shippo Perl API Client module.<br/>
Copyright &copy; 2015 Iain Campbell. All rights reserved.

You may distribute this software under the terms of either the GNU General Public License or the Artistic License, as specified in the Perl README file.

### SUPPORT / WARRANTY

The Shippo Perl API Client is free Open Source software; _it comes without warranty of any kind._

