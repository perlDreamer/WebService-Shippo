use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Refund;
use base (
    'WebService::Shippo::Resource', 
    'WebService::Shippo::Creator',
    'WebService::Shippo::Fetcher',
    'WebService::Shippo::Lister',
    'WebService::Shippo::Async',

);

sub api_resource {'refunds'}

package    # Hide from PAUSE
    WebService::Shippo::RefundList;
use base ('WebService::Shippo::ObjectList');

BEGIN {
    no warnings 'once';

    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Refund::     = *WebService::Shippo::Refund::;
    *Shippo::RefundList:: = *WebService::Shippo::RefundList::;
}

1;
