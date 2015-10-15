use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Refund;
use base ( 'WebService::Shippo::Creator',
           'WebService::Shippo::Fetcher',
           'WebService::Shippo::Lister',
           'WebService::Shippo::Resource',
);

sub api_resource {'refunds'}

1;
