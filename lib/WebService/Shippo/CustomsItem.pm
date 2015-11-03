use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::CustomsItem;
use base (
    'WebService::Shippo::Resource',
    'WebService::Shippo::Creator',
    'WebService::Shippo::Fetcher',
);

sub api_resource ()     { 'customs/items' }
sub collection_class () { 'WebService::Shippo::CustomsItems' }
sub item_class ()       { __PACKAGE__ }

package    # Hide from PAUSE
    WebService::Shippo::CustomsItems;
use base ( 'WebService::Shippo::Collection' );
sub item_class ()       { 'WebService::Shippo::CustomsItem' }
sub collection_class () { __PACKAGE__ }

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::CustomsItem::     = *WebService::Shippo::CustomsItem::;
    *Shippo::CustomsItemList:: = *WebService::Shippo::CustomsItemList::;
}

1;
