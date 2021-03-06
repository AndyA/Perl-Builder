package Perl::Builder::Stage::Fetch;

use Moose;
use Carp qw( croak );
use LWP::UserAgent;
use File::Spec;

extends 'Perl::Builder::Stage';

has ua => (
  is      => 'ro',
  isa     => 'LWP::UserAgent',
  default => sub {
    my $ua = LWP::UserAgent->new;
    $ua->agent( __PACKAGE__ );
    return $ua;
  },
);

=head1 NAME

Perl::Builder::Stage::Fetch - Fetch Perl source from CPAN mirror

=head2 C<< run >>

Fetch the specified Perl source tarball from the configured CPAN mirror.

=cut

sub run {
  my $self = shift;
  my ( $file, $url ) = $self->_get_file_and_url;
  if ( -f $file ) {
    unlink $file or croak "Can't delete old $file";
  }
  {
    my $la = $self->report( 0, 'downloading ', $url, ' to ', $file );
    my $resp = $self->ua->get( $url, ':content_file' => $file );
    carp $resp->status_line if $resp->is_error;
  }
}

=head2 C<< is_done >>

Return true if the archive has already been fully downloaded.

=cut

sub is_done {
  my $self = shift;
  my ( $file, $url ) = $self->_get_file_and_url;
  return -f $file && -s _ == $self->_url_size( $url );
}

sub _url_size {
  my ( $self, $url ) = @_;
  my $resp = $self->ua->head( $url );
  carp $resp->status_line if $resp->is_error;
  return $resp->header( 'Content-Length' );
}

sub _get_file_and_url {
  my $self   = shift;
  my $source = $self->spec->source;
  my $file   = $self->work_file( $self->_url_leaf( $source ) );
  my $cpan   = $self->_url_tidy( $self->need_option( 'cpan_url' ) );
  return ( $file, $cpan . $source );
}

sub _url_tidy {
  my ( $self, $url ) = @_;
  $url =~ s{([^/])$}{$1/};
  return $url;
}

sub _url_leaf {
  my ( $self, $url ) = @_;
  return $1 if $url =~ m{([^/]+)$};
  return $url;
}

1;

# vim:ts=2:sw=2:sts=2:et:ft=perl
