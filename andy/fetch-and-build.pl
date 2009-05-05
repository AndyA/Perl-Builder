#!/usr/bin/env perl

use strict;
use warnings;

use File::Path;
use File::Spec;
use Getopt::Long;
use LWP::UserAgent;
use Perl::Version;
use YAML qw( LoadFile );

my %options = ( stop_on_fail => 0 );

my $CPAN    = 'http://cpan.ripley/';
my $BUILD   = 'build';
my $INST    = glob '~/Works/Perl/versions';
my $PATCHES = 'patches';

GetOptions( 'S|stop-on-fail' => \$options{stop_on_fail} )
 or die "Bad option";

my $like_version = Perl::Version::REGEX;

mkpath( $BUILD );
my $versions = LoadFile( 'versions.yaml' );

my @failed = ();
my $ua     = LWP::UserAgent->new;

VERSION: for my $ver ( reverse @$versions ) {
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
  my @build = ();

  push @build, patches( $dir );
  push @build, $cmd, "make", "make test", "make install"
   unless -d $inst;

  my $build_cmd
   = join ' && ',
   "cd $BUILD",
   "rm -rf $dir $dir.orig",
   "tar zxf $dst",
   "cp -r $dir $dir.orig",
   "cd $dir",
   "chmod -R u+w .",
   "echo '$cmd' > reconfig.sh",
   catch( 'stdout.build', @build );

  print "$build_cmd\n";
  system $build_cmd and warn "$build_cmd failed $?\n";

  unless ( -d $inst ) {
    warn "Build failed\n";
    push @failed, $ver;
    last if $options{stop_on_fail};
  }

}

sub catch {
  my $file = shift;
  return unless @_;
  return '{ ' . join( ' && ', @_ ) . " ; } | tee $file 2>&1";
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
    push @cmd, "yes n | patch -t -p1 < $patch";
  }
  return @cmd;
}

if ( @failed ) {
  print "The following versions had build problems:\n";
  print "  $_\n" for sort @failed;
}

# vim:ts=2:sw=2:sts=2:et:ft=perl

