use strict;
use warnings;

use Marketplace::Ebay;
use File::Spec;
use Test::More;
use Data::Dumper;

# pulled in by XML::Compile
# use Log::Report  mode => "DEBUG";


plan tests => 3;


my $ebay = Marketplace::Ebay->new(
                                  production => 0,
                                  site_id => 77,
                                  developer_key => '1234',
                                  application_key => '6789',
                                  certificate_key => '6666',
                                  token => 'asd12348' x 20,
                                  xsd_file => File::Spec->catfile(qw/t ebay.xsd/),
                                 );
my $xml = <<'XML';
<?xml version="1.0" encoding="UTF-8"?>
<GeteBayOfficialTimeResponse xmlns="urn:ebay:apis:eBLBaseComponents"><Timestamp>2014-12-16T11:31:23.999Z</Timestamp><Ack>Success</Ack><Version>891</Version><Build>E891_INTL_API_17051666_R1</Build></GeteBayOfficialTimeResponse>
XML

my $data = $ebay->_parse_response(GeteBayOfficialTime => $xml);

# print $ebay->show_xml_template(GeteBayOfficialTime => 'Response');

ok($data);
is($data->{Timestamp}, '2014-12-16T11:31:23.999Z', "Found the timestamp");
is($data->{Ack}, 'Success', "Found success ack");
diag Dumper($data);
