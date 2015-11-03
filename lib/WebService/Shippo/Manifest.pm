use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Manifest;
use base (
    'WebService::Shippo::Resource',
    'WebService::Shippo::Creator',
    'WebService::Shippo::Fetcher',
);

sub api_resource ()     { 'manifests' }
sub collection_class () { 'WebService::Shippo::Manifests' }
sub item_class ()       { __PACKAGE__ }

package    # Hide from PAUSE
    WebService::Shippo::Manifests;
use base ( 'WebService::Shippo::Collection' );
sub item_class ()       { 'WebService::Shippo::Manifest' }
sub collection_class () { __PACKAGE__ }

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Manifest::     = *WebService::Shippo::Manifest::;
    *Shippo::ManifestList:: = *WebService::Shippo::ManifestList::;
}

1;
