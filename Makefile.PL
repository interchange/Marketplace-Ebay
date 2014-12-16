use 5.010001;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Marketplace::Ebay',
    AUTHOR           => q{Marco Pessotto <melmothx@gmail.com>},
    VERSION_FROM     => 'lib/Marketplace/Ebay.pm',
    ABSTRACT_FROM    => 'lib/Marketplace/Ebay.pm',
    LICENSE          => 'Perl_5',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.010001,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
                  'HTTP::Thin' => 0,
                  'XML::Compile::Schema' => 0,
                  'Moo' => 0,
                  'MooX::Types::MooseLike' => 0,
                  'HTTP::Request' => 0,
                  'XML::LibXML' => 0,
                 },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Marketplace-Ebay-*' },
);
