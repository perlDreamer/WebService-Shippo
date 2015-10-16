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
    # Return empty config if no Config.yml exists
    return bless( {}, $class )
        unless -e $config_file;
    # Fetch the config content. By default, this should be defined in a
    # file called Config.yml, located in the same folder as the Config.pm
    # module.
    open my $fh, '<:encoding(UTF-8)', $config_file
        or croak "Can't open file '$config_file': $!";
    my $config_yaml = do { local $/ = <$fh> };
    close $fh;
    # Return empty config if no YAML content was found
    return bless( {}, $class )
        unless $config_yaml;
    # Parse the YAML content; use an empty config if that yields nothing.
    my $self = YAML::XS::Load( $config_yaml ) || {};
    return bless( $self, $class );
}

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::Config:: = *WebService::Shippo::Config::;
}

1;
