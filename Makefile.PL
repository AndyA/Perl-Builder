use strict;
use warnings;
use ExtUtils::MakeMaker;

eval 'use ExtUtils::MakeMaker::Coverage';

WriteMakefile(
    ( MM->can( 'signature_target' ) ? ( SIGN => 1 ) : () ),
    NAME          => 'Perl::Builder',
    AUTHOR        => 'Andy Armstrong <andy.armstrong@messagesystems.com>',
    LICENSE       => 'perl',
    VERSION_FROM  => 'lib/Perl/Builder.pm',
    ABSTRACT_FROM => 'lib/Perl/Builder.pm',
    PL_FILES      => {},
    PREREQ_PM     => {
        'Test::More' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Perl-Builder-*' },
);
