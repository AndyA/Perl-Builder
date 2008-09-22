package Perl::Builder::Role::Configurable;

use Moose::Role;
use Carp qw( croak );
use File::Path;
use File::Spec;
use File::Basename;

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

=head2 C<< work_file >>

Get the name of a file relative to the build directory.

=cut

sub work_file {
  my ( $self, $name ) = @_;
  my $file
   = File::Spec->catfile( $self->need_option( 'build_dir' ), $name );
  mkpath( dirname( $file ) );
  return $file;

}

sub work_dir {
  my ( $self, $name ) = @_;
  my $dir
   = File::Spec->catdir( $self->need_option( 'build_dir' ), $name );
  mkpath( $dir );
  return $dir;
}

1;

# vim:ts=2:sw=2:sts=2:et:ft=perl
