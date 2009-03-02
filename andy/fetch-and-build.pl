#!/usr/bin/env perl

use strict;
use warnings;

use File::Path;
use File::Spec;
use Getopt::Long;
use LWP::UserAgent;
use Perl::Version;
use YAML qw( LoadFile );

my $CPAN    = 'http://cpan.ripley/';
my $BUILD   = 'build';
my $INST    = glob '~/Works/Perl/versions';
my $PATCHES = 'patches';

my $like_version = Perl::Version::REGEX;

mkpath( $BUILD );
my $versions = LoadFile( 'versions.yaml' );

my @failed = ();
my $ua     = LWP::UserAgent->new;
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

  push @prepare, patches( $dir );

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
   "rm -rf $dir $dir.orig",
   "tar zxf $dst",
   "cp -r $dir $dir.orig",
   "cd $dir",
   "chmod -R u+w .",
   @prepare, @build;

  print "$build_cmd\n";
  system $build_cmd and push @failed, $ver;
}

sub patches {
  my $dir = shift;
  my @cmd = ();
  my $patch_dir
   = File::Spec->rel2abs( File::Spec->catdir( $PATCHES, $dir ) );
  return unless -d $patch_dir;
  my $index = File::Spec->catfile( $patch_dir, 'index' );
  open my $ih, '<', $index or die "Can't read $index ($1)\n";
  while ( <$ih> ) {
    chomp;
    my $patch = File::Spec->catfile( $patch_dir, $_ );
    die "$patch not found\n" unless -f $patch;
    push @cmd, "yes n | patch -t -p1 < $patch | tee stdout.patch 2>&1";
  }
  return @cmd;
}

if ( @failed ) {
  print "The following versions had build problems:\n";
  print "  $_\n" for sort @failed;
}

# vim:ts=2:sw=2:sts=2:et:ft=perl

