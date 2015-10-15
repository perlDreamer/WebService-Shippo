use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::CarrierAccount;
use base ( 'WebService::Shippo::CreatableResource',
           'WebService::Shippo::FetchableResource',
           'WebService::Shippo::ListableResource',
           'WebService::Shippo::UpdatableResource'
);

sub api_resource {'carrier_accounts'}    # why not "carrier/accounts", which
                                         # would be consistent with Customs
                                         # Declaration resource?

1;
