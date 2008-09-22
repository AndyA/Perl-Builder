#!perl

use strict;
use warnings;
use Test::More;
use Perl::Builder;

my @versions = qw(
 5.003_07 5.004    5.004_01 5.004_02
 5.004_03 5.004_04 5.004_05 5.005
 5.005_01 5.005_02 5.005_03 5.005_04
 5.6.0    5.6.1    5.6.2    5.7.0
 5.7.1    5.7.2    5.7.3    5.8.0
 5.8.1    5.8.2    5.8.3    5.8.4
 5.8.5    5.8.6    5.8.7    5.8.8
 5.9.0    5.9.1    5.9.2    5.9.3
 5.9.4    5.9.5    5.10.0
);

plan tests => @versions * 3;

for my $version ( @versions ) {
  ok my $b = Perl::Builder->new, "$version: got builder";
  ok my $w = $b->for_version( $version ), "$version: got worker";
  #use Data::Dumper;
  #diag( Dumper( $w ) );
  isa_ok $w, 'Perl::Builder::Worker', "$version: worker";
  $w->fetch;
}

# vim:ts=2:sw=2:et:ft=perl

