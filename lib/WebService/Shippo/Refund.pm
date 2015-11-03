use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Refund;
use base (
    'WebService::Shippo::Resource',
    'WebService::Shippo::Creator',
    'WebService::Shippo::Fetcher',
    'WebService::Shippo::Async',

);

sub api_resource ()     { 'refunds' }
sub collection_class () { 'WebService::Shippo::Refunds' }
sub item_class ()       { __PACKAGE__ }

package    # Hide from PAUSE
    WebService::Shippo::Refunds;
use base ( 'WebService::Shippo::Collection' );
sub item_class ()       { 'WebService::Shippo::Refund' }
sub collection_class () { __PACKAGE__ }

BEGIN {
    no warnings 'once';

    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Refund::     = *WebService::Shippo::Refund::;
    *Shippo::RefundList:: = *WebService::Shippo::RefundList::;
}

1;
