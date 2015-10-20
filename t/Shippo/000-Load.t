use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../lib";
use TestHarness;

use_ok( 'WebService::Shippo', ':all' );

done_testing();
