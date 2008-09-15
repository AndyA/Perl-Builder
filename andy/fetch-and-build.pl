#!/usr/bin/env perl

use strict;
use warnings;
use YAML qw( LoadFile );
use File::Spec;
use File::Path;
use LWP::UserAgent;
use Perl::Version;

my $CPAN  = 'http://cpan.ripley/';
my $BUILD = 'build';
my $INST  = 'inst';

my $like_version = Perl::Version::REGEX;

mkpath( $BUILD );
my $versions = LoadFile( 'versions.yaml' );

my $ua = LWP::UserAgent->new;
for my $ver ( @$versions ) {
  my $src = $CPAN . $ver->{source};
  my ( $dst ) = ( $src =~ m{/([^/]+)$} );
  my $ver = Perl::Version->new( join '', ( $dst =~ $like_version ) );
  my $ball = File::Spec->catfile( $BUILD, $dst );
  unless ( -e $ball ) {
    print "$src --> $ball\n";
    my $res = $ua->get( $src, ':content_file' => $ball );
    warn $res->status_line, "\n" unless $res->is_success;
  }
  my $inst = File::Spec->catdir( File::Spec->rel2abs( $INST ), "$ver" );
  print "$inst\n";
  my @cmd = ( './Configure', '-de', '-Dprefix=' . $inst );
  push @cmd, ( '-Dusedevel', '-Uversiononly' ) if $ver->version % 2;
  my $cmd = join( ' ', @cmd );
  print "$cmd\n";
  ( my $dir = $dst ) =~ s/\.tar\.gz$//g;
  system(
    "cd $BUILD && rm -rf $dir && tar zxf $dst && cd $dir && $cmd > stdout 2> stderr && make && make test && make install" );

}

# vim:ts=2:sw=2:sts=2:et:ft=perl

