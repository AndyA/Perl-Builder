#!perl

use strict;
use warnings;
use Perl::Builder::Version;
use Data::Dumper;
use Test::More;

my @versions = (
  { version => '5.003_07', parts => [ 5, 3,  7 ], },
  { version => '5.004',    parts => [ 5, 4,  0 ], },
  { version => '5.004_01', parts => [ 5, 4,  1 ], },
  { version => '5.004_02', parts => [ 5, 4,  2 ], },
  { version => '5.004_03', parts => [ 5, 4,  3 ], },
  { version => '5.004_04', parts => [ 5, 4,  4 ], },
  { version => '5.004_05', parts => [ 5, 4,  5 ], },
  { version => '5.005',    parts => [ 5, 5,  0 ], },
  { version => '5.005_01', parts => [ 5, 5,  1 ], },
  { version => '5.005_02', parts => [ 5, 5,  2 ], },
  { version => '5.005_03', parts => [ 5, 5,  3 ], },
  { version => '5.005_04', parts => [ 5, 5,  4 ], },
  { version => '5.6.0',    parts => [ 5, 6,  0 ], },
  { version => '5.6.1',    parts => [ 5, 6,  1 ], },
  { version => '5.6.2',    parts => [ 5, 6,  2 ], },
  { version => '5.7.0',    parts => [ 5, 7,  0 ], },
  { version => '5.7.1',    parts => [ 5, 7,  1 ], },
  { version => '5.7.2',    parts => [ 5, 7,  2 ], },
  { version => '5.7.3',    parts => [ 5, 7,  3 ], },
  { version => '5.8.0',    parts => [ 5, 8,  0 ], },
  { version => '5.8.1',    parts => [ 5, 8,  1 ], },
  { version => '5.8.2',    parts => [ 5, 8,  2 ], },
  { version => '5.8.3',    parts => [ 5, 8,  3 ], },
  { version => '5.8.4',    parts => [ 5, 8,  4 ], },
  { version => '5.8.5',    parts => [ 5, 8,  5 ], },
  { version => '5.8.6',    parts => [ 5, 8,  6 ], },
  { version => '5.8.7',    parts => [ 5, 8,  7 ], },
  { version => '5.8.8',    parts => [ 5, 8,  8 ], },
  { version => '5.9.0',    parts => [ 5, 9,  0 ], },
  { version => '5.9.1',    parts => [ 5, 9,  1 ], },
  { version => '5.9.2',    parts => [ 5, 9,  2 ], },
  { version => '5.9.3',    parts => [ 5, 9,  3 ], },
  { version => '5.9.4',    parts => [ 5, 9,  4 ], },
  { version => '5.9.5',    parts => [ 5, 9,  5 ], },
  { version => '5.10.0',   parts => [ 5, 10, 0 ], },
);

plan tests => @versions * 4;

for my $version ( @versions ) {
  my $v  = $version->{version};
  my @p  = @{ $version->{parts} };
  my $vo = Perl::Builder::Version->new( $v );
  is_deeply [ $vo->components ], [@p], "$v: parts parsed correctly"
   or diag( Dumper( $vo ) );
  is $vo->alpha, 0, "$v: no alpha component" or diag( Dumper( $vo ) );
  is $vo->stringify, $v, "$v: roundtrip" or diag( Dumper( $vo ) );
  is $vo->normal, 'v' . join( '.', @p ), "$v: normalize";
}

# vim:ts=2:sw=2:et:ft=perl

