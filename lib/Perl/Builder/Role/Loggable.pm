package Perl::Builder::Role::Loggable;

use Moose::Role;
use POSIX qw( strftime );
use Time::HiRes qw( time );

# TODO: Find out why this breaks.
#requires 'option';

=head1 NAME

Perl::Builder::Role::Loggable - Log output

=cut

sub mention {
  my ( $self, $level, @msg ) = @_;
  $self->_log( $level, @msg ) if $self->_should_log( $level );
}

package Perl::Builder::Role::Loggable::Capture;

use strict;
use warnings;
use Time::HiRes qw( time );

sub _new {
  my ( $class, $self, $level, @msg ) = @_;
  my $start_time = time;
  $self->_log( $level, 'start: ', @msg );
  return bless sub {
    my $end_time = time;
    $self->_log( $level, 'done:  ', @msg, ' in ',
      sprintf( '%.2f', $end_time - $start_time ),
      ' seconds' );
  }, $class;
}

sub DESTROY { shift->() }

package Perl::Builder::Role::Loggable;

sub report {
  my ( $self, $level, @msg ) = @_;
  return unless $self->_should_log( $level );
  return Perl::Builder::Role::Loggable::Capture->_new( $self, $level,
    @msg );
}

sub _should_log {
  my ( $self, $level ) = @_;
  return $level < $self->option( 'verbosity' );
}

sub _log {
  my ( $self, $level, @msg ) = @_;
  my $ts = strftime "%Y/%m/%d %H:%M:%S", localtime;
  my $pad = '  ' x $level;
  chomp( my $msg = join '', @msg );
  print "$ts$pad $_\n" for split /\n/, $msg;
}
1;

# vim:ts=2:sw=2:sts=2:et:ft=perl
