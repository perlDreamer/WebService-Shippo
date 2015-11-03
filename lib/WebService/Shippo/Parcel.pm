use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Parcel;
use base (
    'WebService::Shippo::Resource',
    'WebService::Shippo::Creator',
    'WebService::Shippo::Fetcher',
);

sub api_resource ()     { 'parcels' }
sub collection_class () { 'WebService::Shippo::Parcels' }
sub item_class ()       { __PACKAGE__ }

package    # Hide from PAUSE
    WebService::Shippo::Parcels;
use base ( 'WebService::Shippo::Collection' );
sub item_class ()       { 'WebService::Shippo::Parcel' }
sub collection_class () { __PACKAGE__ }

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Parcel::     = *WebService::Shippo::Parcel::;
    *Shippo::ParcelList:: = *WebService::Shippo::ParcelList::;
}

1;
