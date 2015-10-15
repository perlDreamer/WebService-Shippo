use strict;
use warnings;

package WebService::Shippo::Config;
use Carp ( 'croak' );
use YAML::XS ();
use namespace::clean;

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
    unless ( -e $config_file ) {
        print STDERR << "EOF";
Oops!
Configuration file not found:

    $config_file

It should look something like this:

---
private_token: <YOUR PRIVATE API AUTHENTICATION TOKEN>
public_token: <YOUR PUBLISHABLE API AUTHENTICATION TOKEN>
default_token: private_token
EOF
        return {};
    }
    open my $fh, '<:encoding(UTF-8)', $config_file
        or croak "Can't open file '$config_file': $!";
    my $config_yaml = do { local $/ = <$fh> };
    close $fh;
    return YAML::XS::Load( $config_yaml );
}

1;
