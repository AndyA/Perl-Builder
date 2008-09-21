package Perl::Builder::Role::Configurable;

use Moose;

has config => (
  is       => 'ro',
  isa      => 'Perl::Builder::Config',
  required => 1,
);

=head1 NAME

Perl::Builder::Role::Configurable - A configurable object

=cut

1;

# vim:ts=2:sw=2:sts=2:et:ft=perl
