use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::CarrierAccount;
use boolean ( 'boolean' );
use base ( 'WebService::Shippo::Creator',
           'WebService::Shippo::Fetcher',
           'WebService::Shippo::Lister',
           'WebService::Shippo::Updater',
           'WebService::Shippo::Resource',
);

sub api_resource {'carrier_accounts'}    # why not "carrier/accounts", which
                                         # would be consistent with Customs
                                         # Declaration resource?

sub active
{
    my ( $invocant, $bool ) = @_;
    return boolean( $invocant->{active} ) unless @_ > 1;
    my $object_id = $invocant->{object_id}
        or return $invocant;
    my $upd = __PACKAGE__->update( $object_id, active => boolean( $bool ) );
    return $invocant->refresh_from( $upd );
}

sub production
{
    my ( $invocant, $bool ) = @_;
    return boolean( !$invocant->{test} ) unless @_ > 1;
    my $object_id = $invocant->{object_id}
        or return $invocant;
    my $upd = __PACKAGE__->update( $object_id, test => boolean( !$bool ) );
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
