#!perl

use strict;
use warnings;

use Marketplace::Ebay;
use File::Spec;
use Test::More;
use Data::Dumper;

# pulled in by XML::Compile
use Log::Report  mode => "DEBUG";


plan tests => 3;


my $ebay = Marketplace::Ebay->new(
                                  production => 0,
                                  developer_key => '1234',
                                  application_key => '6789',
                                  certificate_key => '6666',
                                  token => 'asd12348' x 20,
                                  xsd_file => File::Spec->catfile(qw/t ebay.xsd/),
                                 );

like $ebay->session_certificate, qr/;/, "Session created";

ok($ebay->schema, "Schema found");

my $xml = $ebay->prepare_xml('GeteBayOfficialTime');
like $xml, qr{<GeteBayOfficialTimeRequest .*</GeteBayOfficialTimeRequest>},
  "XML looks ok";

