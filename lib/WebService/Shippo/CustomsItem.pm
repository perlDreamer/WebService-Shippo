use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::CustomsItem;
use base (
    'WebService::Shippo::Resource',
    'WebService::Shippo::Creator',
    'WebService::Shippo::Fetcher',
    'WebService::Shippo::Lister',

);

sub api_resource { 'customs/items' }

package                               # Hide from PAUSE
    WebService::Shippo::CustomsItemList;
use base ( 'WebService::Shippo::ObjectList' );

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::CustomsItem::     = *WebService::Shippo::CustomsItem::;
    *Shippo::CustomsItemList:: = *WebService::Shippo::CustomsItemList::;
}

1;
