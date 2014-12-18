#!perl

use strict;
use warnings;

use Marketplace::Ebay;
use File::Spec;
use Test::More;
use Data::Dumper;
use YAML qw/LoadFile/;

my $config = File::Spec->catfile(qw/t ebay.yml/);

if (-f $config) {
    plan tests => 9;
}
else {
    plan skip_all => "Missing $config file, cannot do a request";
}

my $conf = LoadFile($config);

ok($conf, "Configuration loaded");

my $ebay = Marketplace::Ebay->new(
                                  production => 0,
                                  site_id => 77,
                                  compatibily_level => 901,
                                  xsd_file => File::Spec->catfile(qw/t ebay.xsd/),
                                  # the config can override
                                  %$conf,
                                 );

ok($ebay, "Object created");

is ($ebay->endpoint, 'https://api.sandbox.ebay.com/ws/api.dll')
  or die "Wrong endpoint!";

my $res = $ebay->api_call('GeteBayOfficialTime');
ok($res);
is $res->{Ack}, "Success", "Call is ok";

ok ($ebay->last_response);
like $ebay->last_response->status_line, qr/200 OK/;

ok ($ebay->last_parsed_response->is_success, "api call ack ok")
  or diag Dumper($ebay->last_parsed_response);

ok ($ebay->last_parsed_response->version, "Got version");
