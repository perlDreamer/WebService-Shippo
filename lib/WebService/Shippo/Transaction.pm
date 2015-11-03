use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Transaction;
use Carp         ( 'confess' );
use Scalar::Util ( 'blessed' );
use base (
    'WebService::Shippo::Resource',
    'WebService::Shippo::Creator',
    'WebService::Shippo::Fetcher',
    'WebService::Shippo::Async',
);

sub api_resource { 'transactions' }

sub get_shipping_label
{
    my ( $invocant, $transaction_id, %params ) = @_;
    confess "Expected a transaction id"
        unless $transaction_id;
    my $transaction;
    if ( $invocant->is_same_object($transaction_id) ) {
        $transaction = $invocant;
    }
    else {
        $transaction = WebService::Shippo::Transaction->fetch( $transaction_id );
    }
    $transaction->wait_if_status_in( 'QUEUED', 'WAITING' )
        unless $params{async};
    return $transaction->label_url;
}

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
