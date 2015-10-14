use strict;
use warnings;

package API::Shippo;
our $VERSION = '0.0.1';
# ABSTRACT: Shippo Perl API wrapper
use API::Shippo::Address;
use API::Shippo::CustomsItem;
use API::Shippo::CustomsDeclaration;
use API::Shippo::Manifest;
use API::Shippo::Parcel;
use API::Shippo::Refund;
use API::Shippo::Shipment;
use API::Shippo::Transaction;
use API::Shippo::Rate;
use API::Shippo::CarrierAccount;

our $API_KEY                 = undef;
our $API_VERSION             = undef;
our $VERIFY_SSL_CERTS        = 0;
our $RATES_REQ_TIMEOUT       = 20;      # Seconds
our $TRANSACTION_REQ_TIMEOUT = 20;      # Seconds

1;
