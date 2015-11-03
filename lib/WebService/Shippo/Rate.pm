use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Rate;
use base (
    'WebService::Shippo::Resource',
    'WebService::Shippo::Fetcher',
);

sub api_resource { 'rates' }

package    # Hide from PAUSE
    WebService::Shippo::RateList;
use base ( 'WebService::Shippo::ObjectList' );

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Rate::     = *WebService::Shippo::Rate::;
    *Shippo::RateList:: = *WebService::Shippo::RateList::;
}

1;
