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

package                                  # Hide from PAUSE
    WebService::Shippo::CarrierAccountList;
use base ( 'WebService::Shippo::ObjectList' );

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::CarrierAccount:: = *WebService::Shippo::CarrierAccount::;
    *Shippo::CarrierAccountList::
        = *WebService::Shippo::CarrierAccountList::;
}

1;
