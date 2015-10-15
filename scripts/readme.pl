# Convert the POD in the distribution's main module to a variety of
# formats for deployment to GitHub.
# cpanic - 2015-09-03

use strict;
use warnings;

my ( $dist_build_dir, $dist_name, $dist_version, $path_sep ) = (@ARGV, '/');
( my $module = "$dist_name.pm" ) =~ s{-}{$path_sep}g;
my $module_path = join($path_sep, $dist_build_dir, 'lib', $module);

print STDERR "$module_path\n";

`pod2text '$module_path' > README.txt`;
`pod2cpanhtml '$module_path' > README.html`;
`pod2pdf '$module_path' > README.pdf`;
`cp README.txt '$dist_build_dir/README'`;

exit 0;