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
        my ( $invocant, $new_value ) = @_;
        return $value unless @_ > 1;
        $value = $new_value;
        return $invocant;
    }
}

{
    my $value = __PACKAGE__->parse_config_file;

    sub reload_config
    {
        my ( $invocant ) = @_;
        $value = $invocant->parse_config_file;
        return $invocant;
    }

    sub config
    {
        my ( $invocant, $new_value ) = @_;
        return $value unless @_ > 1;
        $value = $new_value;
        return $invocant;
    }
}

sub parse_config_file
{
    my ( $class ) = @_;
    $class = ref( $class ) || $class;
    my $config_file = $class->config_file;
    unless ( -e $config_file ) {
        print STDERR << "EOF";
Oops!

Your configuration file not found. Without it, your API requests may not be
authorized if you haven't used "Shippo->api_key(...)" to set your Shippo
API key.

    $config_file

You should create the file mentioned above. It's a YAML file that should look
something like this.

---
private_token: <YOUR PRIVATE API AUTHENTICATION TOKEN>
public_token: <YOUR PUBLISHABLE API AUTHENTICATION TOKEN>
EOF
        return {};
    }
    open my $fh, '<:encoding(UTF-8)', $config_file
        or croak "Can't open file '$config_file': $!";
    my $config_yaml = do { local $/ = <$fh> };
    close $fh;
    return bless( YAML::XS::Load( $config_yaml ), $class );
}

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Config:: = *WebService::Shippo::Config::;
}

1;
