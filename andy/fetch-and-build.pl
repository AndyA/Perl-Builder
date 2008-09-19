#!/usr/bin/env perl

use strict;
use warnings;
use YAML qw( LoadFile );
use File::Spec;
use File::Path;
use LWP::UserAgent;
use Perl::Version;

my $CPAN    = 'http://cpan.ripley/';
my $BUILD   = 'build';
my $INST    = 'inst';
my $PATCHES = 'patches';

my $like_version = Perl::Version::REGEX;

mkpath( $BUILD );
my $versions = LoadFile( 'versions.yaml' );

my $ua = LWP::UserAgent->new;
for my $ver ( reverse @$versions ) {
  my $src = $CPAN . $ver->{source};
  my ( $dst ) = ( $src =~ m{/([^/]+)$} );
  my $ver = Perl::Version->new( join '', ( $dst =~ $like_version ) );
  my $inst = File::Spec->catdir( File::Spec->rel2abs( $INST ), "$ver" );
  my $ball = File::Spec->catfile( $BUILD, $dst );
  unless ( -e $ball ) {
    print "$src --> $ball\n";
    my $res = $ua->get( $src, ':content_file' => $ball );
    warn $res->status_line, "\n" unless $res->is_success;
  }
  print "$inst\n";
  my @cmd = ( './Configure', '-de', '-Dprefix=' . $inst );
  push @cmd, ( '-Dusedevel', '-Uversiononly' ) if $ver->version % 2;
  my $cmd = join( ' ', @cmd );
  print "$cmd\n";
  ( my $dir = $dst ) =~ s/\.tar\.gz$//g;
  for my $d ( $dir, "$dir.orig" ) {
    my $dp = File::Spec->catdir( $BUILD, $d );
    rmtree( $dp ) if -d $dp;
  }
  my @prepare = ();
  my @build   = ();
  my $patch   = File::Spec->rel2abs(
    File::Spec->catfile( $PATCHES, "$dir.patch" ) );
  push @prepare, "yes n | patch -t -p1 < $patch | tee stdout.patch 2>&1"
   if -f $patch;
  push @build,
   "echo '$cmd' > reconfig.sh",
   "$cmd | tee stdout.config 2>&1",
   "make | tee stdout.make 2>&1",
   "make test | tee stdout.test 2>&1",
   "make install | tee stdout.install 2>&1"
   unless -d $inst;
  my $build_cmd
   = join ' && ',
   "cd $BUILD",
   "rm -rf $dir",
   "tar zxf $dst",
   "cp -r $dir $dir.orig",
   "cd $dir",
   "chmod -R u+w .",
   @prepare, @build;
  print "$build_cmd\n";
  system $build_cmd;

}

# vim:ts=2:sw=2:sts=2:et:ft=perl

