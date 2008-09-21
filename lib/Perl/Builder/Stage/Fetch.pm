package Perl::Builder::Stage::Fetch;

use Moose;

extends 'Perl::Builder::Stage';

with
 'Perl::Builder::Role::Configurable',
 'Perl::Builder::Role::Speccable';

=head1 NAME

Perl::Builder::Stage::Fetch - Fetch Perl source from CPAN mirror

=cut

sub run {
  my $self = shift;
}

1;

# vim:ts=2:sw=2:sts=2:et:ft=perl
