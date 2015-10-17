use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Manifest;
use base ( 'WebService::Shippo::Creator',
           'WebService::Shippo::Fetcher',
           'WebService::Shippo::Lister',
           'WebService::Shippo::Resource',
);

sub api_resource {'manifests'}

package    # Hide from PAUSE
    WebService::Shippo::ManifestList;
use base ( 'WebService::Shippo::ObjectList' );

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Manifest::     = *WebService::Shippo::Manifest::;
    *Shippo::ManifestList:: = *WebService::Shippo::ManifestList::;
}

1;
