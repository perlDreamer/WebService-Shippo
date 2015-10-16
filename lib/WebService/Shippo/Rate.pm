use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Rate;
use base ( 'WebService::Shippo::Fetcher',
           'WebService::Shippo::Lister',
           'WebService::Shippo::CurrencyAware',
           'WebService::Shippo::Resource',
);

sub api_resource {'rates'}

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Rate:: = *WebService::Shippo::Rate::;
}

1;
