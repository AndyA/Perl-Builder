package Perl::Builder::Stage::Fetch;

use Moose;
use LWP::UserAgent;
use File::Spec;

extends 'Perl::Builder::Stage';

with
 'Perl::Builder::Role::Configurable',
 'Perl::Builder::Role::Speccable';

=head1 NAME

Perl::Builder::Stage::Fetch - Fetch Perl source from CPAN mirror

=head2 C<< run >>

Fetch the specified Perl source tarball from the configured CPAN mirror.

=cut

sub run {
  my $self = shift;
  my $cpan = $self->need_option( 'cpan_url' );
  warn "# $cpan\n";
}

sub _url_leaf {
  my ( $self, $url ) = @_;
  # Don't use File::Spec because URLs are always '/' separated.
  return $1 if $url =~ m{([^/]+)$};
  return $url;
}

1;

# vim:ts=2:sw=2:sts=2:et:ft=perl
