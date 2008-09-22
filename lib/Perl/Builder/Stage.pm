package Perl::Builder::Stage;

use Moose;

with
 'Perl::Builder::Role::Configurable',
 'Perl::Builder::Role::Speccable';

=head1 NAME

Perl::Builder::Stage - Base class for build stages

=head2 C<< is_done >>

True if this stage has been successfully completed.

=cut

sub is_done { 0 }

=head2 C<< freshen >>

Run this stage if it hasn't already been completed.

=cut

sub freshen {
  my $self = shift;
  $self->run unless $self->is_done;
}

1;

# vim:ts=2:sw=2:sts=2:et:ft=perl
