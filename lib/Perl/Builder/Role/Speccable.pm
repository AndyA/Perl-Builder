package Perl::Builder::Role::Speccable;

use Moose::Role;

has spec => (
  is       => 'ro',
  required => 1,
);

=head1 NAME

Perl::Builder::Role::Speccable - An object that can receive a specification

=cut

1;

# vim:ts=2:sw=2:sts=2:et:ft=perl
