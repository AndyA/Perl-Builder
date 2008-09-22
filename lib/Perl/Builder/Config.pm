package Perl::Builder::Config;

use Moose;

# Hardwire the options for now

my %Options = (
  cpan_url  => 'http://cpan.ripley',
  prefix    => sub { die },
  build_dir => '/tmp/perl-builder',
  verbosity => 9,
);

=head1 NAME

Perl::Builder::Config - Configuration for Perl::Builder

=head2 C<< option >>

Retrieve an option value.

=cut

sub option {
  my ( $self, $name, $default ) = @_;
  my $value = exists $Options{$name} ? $Options{$name} : $default;
  $value = $value->( $name ) if 'CODE' eq ref $value;
  return $value;
}

1;

# vim:ts=2:sw=2:sts=2:et:ft=perl
