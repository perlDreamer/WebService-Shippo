use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Parcel;
use base (
    'WebService::Shippo::Resource',
    'WebService::Shippo::Creator',
    'WebService::Shippo::Fetcher',
    'WebService::Shippo::Lister',
);

sub api_resource { 'parcels' }

package                               # Hide from PAUSE
    WebService::Shippo::ParcelList;
use base ( 'WebService::Shippo::ObjectList' );

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Parcel::     = *WebService::Shippo::Parcel::;
    *Shippo::ParcelList:: = *WebService::Shippo::ParcelList::;
}

1;
