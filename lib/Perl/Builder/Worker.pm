package Perl::Builder::Worker;

use Moose;
use Moose::Util::TypeConstraints;

with
 'Perl::Builder::Role::Configurable',
 'Perl::Builder::Role::Speccable';

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
    *$m = sub { shift->stage( $m, @_ )->run; };
  }
}

=head1 NAME

Perl::Builder::Worker - Build a specific Perl version

=head2 C<< stage >>

Execute the named build stage.

=cut

sub stage {
  my ( $self, $stage, @args ) = @_;
  my $class = $self->_class_for_stage( $stage );
  eval "require $class";
  croak $@ if $@;
  return $class->new(
    spec   => $self->spec,
    config => $self->config,
    @args
  );
}

sub _class_for_stage {
  my ( $self, $stage ) = @_;
  return 'Perl::Builder::Stage::' . ucfirst( lc( $stage ) );
}

1;

# vim:ts=2:sw=2:sts=2:et:ft=perl
