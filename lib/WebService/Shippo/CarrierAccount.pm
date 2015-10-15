use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::CarrierAccount;
use base ( 'WebService::Shippo::Creator',
           'WebService::Shippo::Fetcher',
           'WebService::Shippo::Lister',
           'WebService::Shippo::Updater',
           'WebService::Shippo::Resource',
);

sub api_resource {'carrier_accounts'}    # why not "carrier/accounts", which
                                         # would be consistent with Customs
                                         # Declaration resource?

1;
