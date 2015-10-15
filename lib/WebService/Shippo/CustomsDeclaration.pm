use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::CustomsDeclaration;
use base ( 'WebService::Shippo::Creator',
           'WebService::Shippo::Fetcher',
           'WebService::Shippo::Lister',
           'WebService::Shippo::Resource',
);

sub api_resource {'customs/declarations'}

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::CustomsDeclaration:: = *WebService::Shippo::CustomsDeclaration::;
}

1;
