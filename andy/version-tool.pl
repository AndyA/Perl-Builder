#!/usr/bin/env perl

use strict;
use warnings;
use File::Spec;
use File::Path;
use POSIX qw( strftime );
use Time::HiRes qw( time );
use DBD::SQLite;

use constant VERSIONS => glob '~/Works/Perl/versions';

init_metadata( VERSIONS );

sub mention {
  my ( @msg ) = @_;
  my $ts = strftime "%Y/%m/%d %H:%M:%S", localtime;
  chomp( my $msg = join '', @msg );
  print "$ts $_\n" for split /\n/, $msg;
}

sub get_perl_dirs {
  my $dir = shift;

  opendir my $dh, $dir or die "Can't read $dir ($!)\n";
  return grep { -f File::Spec->catfile( $_, 'bin', 'perl' ) }
   grep { -d }
   map { File::Spec->catdir( $dir, $_ ) }
   grep { /^[^.]/ } readdir $dh;
}

sub _metadata { File::Spec->catdir( shift, 'metadata' ) }
sub _leaf { ( File::Spec->splitdir( shift ) )[-1] }

sub run_command {
  my @cmd  = @_;
  my $code = 'CODE' eq ref $cmd[-1] ? pop @cmd : sub { };
  my $cmd  = join ' ', @cmd;

  mention( "Running $cmd" );
  open my $ch, '-|', @cmd or die "Can't $cmd ($!)\n";
  while ( <$ch> ) {
    chomp;
    $code->();
  }
  close $ch or mention( "Bad exit from $cmd ($?/$!)\n" );
  return $?;
}

sub init_metadata {
  my $dir  = shift;
  my $meta = _metadata( $dir );
  unless ( -d $meta ) {
    mention( "Creating $meta" );
    my @perls = get_perl_dirs( $dir );
    for my $perl ( @perls ) {
      my $name = _leaf( $perl );
      my $home = File::Spec->catdir( $meta, $name );
      mkpath( $home );
      my $repo = File::Spec->catdir( $home, 'repo' );
      my $db   = File::Spec->catdir( $home, 'db' );
      run_command( 'svnadmin', 'create', $repo );

    }
  }
}

# vim:ts=2:sw=2:sts=2:et:ft=perl

