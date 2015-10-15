use strict;
use warnings;

package API::Shippo;
# ABSTRACT: Shippo Perl API wrapper
our $VERSION = '0.0.1';
use Carp ( 'croak' );
use YAML::XS ();
use API::Shippo::Address;
use API::Shippo::CustomsItem;
use API::Shippo::CustomsDeclaration;
use API::Shippo::Manifest;
use API::Shippo::Parcel;
use API::Shippo::Refund;
use API::Shippo::Shipment;
use API::Shippo::Transaction;
use API::Shippo::Rate;
use API::Shippo::CarrierAccount;
use base ( 'Exporter' );

{
    ( my $value = __FILE__ ) =~ s{\.\w+$}{.yml};

    sub config_file
    {
        my ( $class, $new_value ) = @_;
        return $value unless @_ > 1;
        $value = $new_value;
        return $class;
    }
}

{
    my $value = __PACKAGE__->parse_config_file;

    sub config
    {
        my ( $class, $new_value ) = @_;
        return $value unless @_ > 1;
        $value = $new_value;
        return $class;
    }
}

sub parse_config_file
{
    my ( $class ) = @_;
    my $config_file = __PACKAGE__->config_file;
    return {}
        unless -e $config_file;
    open my $fh, '<:encoding(UTF-8)', $config_file
        or croak "Can't open file '$config_file': $!";
    my $config_yaml = do { local $/ = <$fh> };
    close $fh;
    return YAML::XS::Load( $config_yaml );
}

sub import
{
    my ( $class )     = @_;
    my $c             = $class->config;
    my $private_token = $c->{private_token};
    my $public_token  = $c->{public_token};
    my $default_token = $c->{default_token} || 'public_token';
    # Setup some resource defaults
    API::Shippo::Resource->api_private_token( $private_token );
    API::Shippo::Resource->api_public_token( $public_token );
    API::Shippo::Resource->api_token( $c->{$default_token} );
    goto &Exporter::import;
}

1;
