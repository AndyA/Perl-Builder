package Perl::Builder::Spec;

use Moose;

has source      => ( is => 'ro', );
has description => ( is => 'ro', );
has version     => (
  is       => 'ro',
  required => 1,
  isa      => 'Perl::Builder::Version',
);

=head1 NAME

Perl::Builder::Spec - Specification for a Perl version

=cut

1;

# vim:ts=2:sw=2:sts=2:et:ft=perl
