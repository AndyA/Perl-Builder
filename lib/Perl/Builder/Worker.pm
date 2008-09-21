package Perl::Builder::Worker;

use Moose;
use Moose::Util::TypeConstraints;

my @stage;

BEGIN {
  @stage = qw(
   fetch
   unpack
   patch
   configure
   build
   test
   install
   clean
  );

  for my $m ( @stage ) {
    no strict 'refs';
    *$m = sub { shift->stage( $m, @_ ) };
  }
}

#enum 'BuildStage' => @stage;

# I guess this is going to be a trait. Fun.
has config => (
  is       => 'ro',
  isa      => 'Perl::Builder::Config',
  required => 1,
);

has spec => (
  is       => 'ro',
  required => 1,
);

=head1 NAME

Perl::Builder::Worker - Build a specific Perl version

=head2 C<< stage >>

Execute the named build stage.

=cut

sub stage {
}

1;

# vim:ts=2:sw=2:sts=2:et:ft=perl
