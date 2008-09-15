#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use Perl::Version;

my $like_version = Perl::Version::REGEX;

#/usr/share/cpan
my @version = qw(
 authors/id/A/AN/ANDYD/perl5.003_07.tar.gz
 authors/id/H/HV/HVDS/perl-5.9.0.tar.gz
 authors/id/T/TI/TIMB/perl5.004_01.tar.gz
 authors/id/T/TI/TIMB/perl5.004_02.tar.gz
 authors/id/T/TI/TIMB/perl5.004_04.tar.gz
 authors/id/T/TI/TIMB/perl5.004_03.tar.gz
 authors/id/R/RG/RGARCIA/perl-5.9.2.tar.gz
 authors/id/R/RG/RGARCIA/perl-5.6.2.tar.gz
 authors/id/R/RG/RGARCIA/perl-5.9.5.tar.gz
 authors/id/R/RG/RGARCIA/perl-5.10.0.tar.gz
 authors/id/R/RG/RGARCIA/perl-5.9.4.tar.gz
 authors/id/R/RG/RGARCIA/perl-5.9.3.tar.gz
 authors/id/R/RG/RGARCIA/perl-5.9.1.tar.gz
 authors/id/L/LB/LBROCARD/perl5.005_04.tar.gz
 authors/id/C/CH/CHIPS/perl5.004_05.tar.gz
 authors/id/C/CH/CHIPS/perl5.004.tar.gz
 authors/id/N/NW/NWCLARK/perl-5.8.8.tar.gz
 authors/id/N/NW/NWCLARK/perl-5.8.5.tar.gz
 authors/id/N/NW/NWCLARK/perl-5.8.3.tar.gz
 authors/id/N/NW/NWCLARK/perl-5.8.4.tar.gz
 authors/id/N/NW/NWCLARK/perl-5.8.2.tar.gz
 authors/id/N/NW/NWCLARK/perl-5.8.7.tar.gz
 authors/id/N/NW/NWCLARK/perl-5.8.6.tar.gz
 authors/id/J/JH/JHI/perl-5.8.1.tar.gz
 authors/id/J/JH/JHI/perl-5.7.3.tar.gz
 authors/id/J/JH/JHI/perl-5.7.2.tar.gz
 authors/id/J/JH/JHI/perl-5.7.0.tar.gz
 authors/id/J/JH/JHI/perl-5.7.1.tar.gz
 authors/id/J/JH/JHI/perl-5.8.0.tar.gz
 authors/id/G/GB/GBARR/perl5.005_03.tar.gz
 authors/id/G/GS/GSAR/perl5.005_02.tar.gz
 authors/id/G/GS/GSAR/perl5.005_01.tar.gz
 authors/id/G/GS/GSAR/perl-5.6.0.tar.gz
 authors/id/G/GS/GSAR/perl5.005.tar.gz
 authors/id/G/GS/GSAR/perl-5.6.1.tar.gz
);

@version = map {
  { description => "Perl $_->[0]", source => $_->[1], patches => [] }
 }
 sort { $a->[0] <=> $b->[0] }
 map { [ Perl::Version->new( join '', ( $_ =~ $like_version ) ), $_ ] }
 @version;
print Dumper( \@version );

# vim:ts=2:sw=2:sts=2:et:ft=perl

