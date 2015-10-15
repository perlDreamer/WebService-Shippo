use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Rate;
use base ( 'WebService::Shippo::Fetcher',
           'WebService::Shippo::Lister',
           'WebService::Shippo::Resource',
);

sub api_resource {'rates'}

1;
