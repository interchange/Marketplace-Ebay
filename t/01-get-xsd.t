#!perl
#
# This tests downloads the latest XSD if the file t/ebay.xsd doesn't exist
# or the RELEASE_TESTING environment variable is set.

use strict;
use warnings;
use Test::More;
# pulled in by HTTP::Thin
use HTTP::Tiny;
use File::Spec;

plan tests => 1;

my $xsd = File::Spec->catfile(qw/t ebay.xsd/);
my $url = 'https://developer.ebay.com/webservices/latest/ebaySvc.xsd';

if ( $ENV{RELEASE_TESTING} or ! -f $xsd ) {
    my $res = HTTP::Tiny->new->mirror($url, $xsd);
    die "Failed to retrieve XSD from $url: $res->{status} $res->{reason}: " unless $res->{success};
}
ok (-f $xsd, "$xsd found");
