package Perl::Builder::Config;

use Moose;

=head1 NAME

Perl::Builder::Config - Configuration for Perl::Builder

=head2 C<< cpan_url >>

The URL of the user's preferred CPAN mirror.

=cut

sub cpan_url { 'http://cpan.ripley/' }

sub prefix { die }

sub build_dir { die }

1;

# vim:ts=2:sw=2:sts=2:et:ft=perl
