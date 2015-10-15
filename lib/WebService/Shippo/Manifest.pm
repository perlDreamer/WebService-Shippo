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

1;
