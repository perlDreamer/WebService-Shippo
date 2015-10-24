use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Transaction;
use base (
    'WebService::Shippo::Resource',
    'WebService::Shippo::Creator',
    'WebService::Shippo::Fetcher',
    'WebService::Shippo::Lister',
    'WebService::Shippo::Async',
);

sub api_resource { 'transactions' }

package    # Hide from PAUSE
    WebService::Shippo::TransactionList;
use base ( 'WebService::Shippo::ObjectList' );

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Transaction::     = *WebService::Shippo::Transaction::;
    *Shippo::TransactionList:: = *WebService::Shippo::TransactionList::;
}

1;
