package Perl::Builder::Role::Configurable;

use Moose::Role;
use Carp qw( croak );

has config => (
  is       => 'ro',
  isa      => 'Perl::Builder::Config',
  required => 1,
  handles  => ['option'],
);

=head1 NAME

Perl::Builder::Role::Configurable - A configurable object

=head2 C<< need_option >>

Get the value of a mandatory option.

=cut

sub need_option {
  my ( $self, $name ) = @_;
  return $self->option(
    $name,
    sub {
      croak "Option $name is mandatory";
    }
  );
}

1;

# vim:ts=2:sw=2:sts=2:et:ft=perl
