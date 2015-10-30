use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::CarrierAccount;
use Carp         ( 'confess' );
use Scalar::Util ( 'blessed' );
use base (
    'WebService::Shippo::Resource',
    'WebService::Shippo::Creator',
    'WebService::Shippo::Fetcher',
    'WebService::Shippo::Lister',
    'WebService::Shippo::Updater',

);

sub api_resource { 'carrier_accounts' }    # why not "carrier/accounts", which
                                           # would be consistent with Customs
                                           # Declaration resource?

sub activate
{
    my ( $invocant, $object_id ) = @_;
    $object_id = $invocant->{object_id}
        if blessed( $invocant ) && !$object_id;
    confess 'Expected an object id'
        unless $object_id;
    my $upd = __PACKAGE__->update( $object_id, active => 1 );
    return $upd
        unless blessed( $invocant ) && $invocant->id eq $object_id;
    $invocant->refresh_from( $upd );
}

sub deactivate
{
    my ( $invocant, $object_id ) = @_;
    $object_id = $invocant->{object_id}
        if blessed( $invocant ) && !$object_id;
    confess 'Expected an object id'
        unless $object_id;
    my $upd = __PACKAGE__->update( $object_id, active => 0 );
    return $upd
        unless blessed( $invocant ) && $invocant->id eq $object_id;
    $invocant->refresh_from( $upd );
}

sub enable_test_mode
{
    my ( $invocant, $object_id ) = @_;
    $object_id = $invocant->{object_id}
        if blessed( $invocant ) && !$object_id;
    confess 'Expected an object id'
        unless $object_id;
    my $upd = __PACKAGE__->update( $object_id, test => 1 );
    return $upd
        unless blessed( $invocant ) && $invocant->id eq $object_id;
    return $invocant->refresh_from( $upd );
}

sub enable_production_mode
{
    my ( $invocant, $object_id ) = @_;
    $object_id = $invocant->{object_id}
        if blessed( $invocant ) && !$object_id;
    confess 'Expected an object id'
        unless $object_id;
    my $upd = __PACKAGE__->update( $object_id, test => 0 );
    return $upd
        unless blessed( $invocant ) && $invocant->id eq $object_id;
    return $invocant->refresh_from( $upd );
}

package    # Hide from PAUSE
    WebService::Shippo::CarrierAccountList;
use base ( 'WebService::Shippo::ObjectList' );

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::CarrierAccount::     = *WebService::Shippo::CarrierAccount::;
    *Shippo::CarrierAccountList:: = *WebService::Shippo::CarrierAccountList::;
}

1;
