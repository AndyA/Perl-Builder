#!/usr/bin/env perl

use strict;
use warnings;
use File::Spec;

use constant BUILD      => 'build';
use constant PATCHES    => 'patches';
use constant PATCHLEVEL => 'patchlevel.h';
use constant COMMENT    => 'Perl::Builder - config / build patches';

opendir my $dh, PATCHES or die "Can't read ", PATCHES, " ($!)\n";
my @patches = grep $_ !~ /^\./, readdir $dh;
closedir $dh;

for my $patch ( @patches ) {
  ( my $dir = $patch ) =~ s/\.patch$//;
  my $pl_orig = File::Spec->catfile( BUILD, "$dir.orig", PATCHLEVEL );
  if ( -e $pl_orig ) {
    my $pl_new = File::Spec->catfile( BUILD, $dir, PATCHLEVEL );
    print "Adding patch to $pl_new\n";
    fixup( $pl_orig, $pl_new, COMMENT );
  }
  else {
    print "No $pl_orig, skipping\n";
  }
}

sub fixup {
  my ( $in, $out, @comments ) = @_;
  open my $ih, '<', $in or die "Can't read $in ($!)\n";
  chmod 0644, $out or die "Can't chmod on $out ($!)\n";
  open my $oh, '>', $out or die "Can't write $out ($!)\n";
  my $seen = 0;
  while ( defined( my $line = <$ih> ) ) {
    if ( $seen && $line =~ /^(\s+),NULL/ ) {
      print $oh qq{$1, "$_"\n} for @comments;
      $seen = 0;
    }
    elsif ( $line =~ /local_patches\[\]/ ) {
      $seen++;
    }
    print $oh $line;
  }
}

# vim:ts=2:sw=2:sts=2:et:ft=perl
