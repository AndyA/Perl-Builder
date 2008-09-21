package Perl::Builder::Version;

use strict;
use warnings;
use Carp qw( croak );
use base qw( Perl::Version );

=head1 NAME

Perl::Builder::Version - A Perl version number

=cut

sub _init_for_perl_version {
  my ( $self, $printf, @parts ) = @_;
  $self->{version} = [ map { 1 * ( $_ || 0 ) } @parts ];
  $self->{format} = {
    printf => $printf,
    prefix => '',
    suffix => '',
    fields => @parts - 1,
    extend => '',
    alpha  => ''
  };
}

sub _parse {
  my $self    = shift;
  my $version = shift;

  if ( $version =~ /^(\d+)\.(\d\d\d)(?:_(\d\d))?$/ ) {
    $self->_init_for_perl_version( [ '%d', '.%03d', $3 ? '_%02d' : '' ],
      $1, $2, $3 );
  }
  elsif ( $version =~ /^(\d+)\.(\d+)\.(\d+)$/ ) {
    $self->_init_for_perl_version( [ '%d', '.%d', '.%d' ], $1, $2, $3 );
  }
  else {
    $self->SUPER::_parse( $version );
  }
}

1;

# vim:ts=2:sw=2:sts=2:et:ft=perl
