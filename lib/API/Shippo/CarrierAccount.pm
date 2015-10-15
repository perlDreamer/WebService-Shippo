use strict;
use warnings;
use MRO::Compat 'c3';

package API::Shippo::CarrierAccount;
use base ( 'API::Shippo::CreatableResource',
           'API::Shippo::FetchableResource',
           'API::Shippo::ListableResource',
           'API::Shippo::UpdatableResource'
);

sub api_resource {'carrier_accounts'}    # why not "carrier/accounts", which
                                         # would be consistent with Customs
                                         # Declaration resource?

1;
