# vim:ts=2:sw=2:sts=2:et:ft=perl
package Perl::Builder;

use Moose;
use Carp qw( croak );
use Perl::Builder::Config;
use Perl::Builder::Version;
use Perl::Builder::Worker;
use Perl::Builder::Spec;

has config => (
  is      => 'ro',
  isa     => 'Perl::Builder::Config',
  default => sub { Perl::Builder::Config->new },
);

=head1 NAME

Perl::Builder - Automatically build any released Perl 5.x.x binary

=head1 VERSION

This document describes Perl::Builder version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

  use Perl::Builder;
  
=head1 DESCRIPTION

=head1 INTERFACE 

=head2 C<< for_version( $ver ) >>

Get a builder for the specified Perl version.

=cut

sub for_version {
  my $self    = shift;
  my $version = shift;
  $version = Perl::Builder::Version->new( $version )
   unless 'Perl::Version' eq ref $version;
  my $spec = $self->_spec_for_version( $version )
   or croak "No build specification found for Perl $version";
  my $sp = Perl::Builder::Spec->new( %$spec );
  return Perl::Builder::Worker->new(
    spec   => $sp,
    config => $self->config
  );
}

sub _spec_for_version {
  my $self    = shift;
  my $version = shift;
  for my $spec ( @{ $self->_get_dictionary } ) {
    #return Perl::Builder::Spec->new( %$spec )
    return $spec
     if $version eq Perl::Builder::Version->new( $spec->{version} );
  }
  return;
}

sub _get_dictionary {
  my $versions = [
    {
      source      => 'authors/id/A/AN/ANDYD/perl5.003_07.tar.gz',
      description => 'Perl 5.003_07',
      version     => '5.003_07',
    },
    {
      source      => 'authors/id/C/CH/CHIPS/perl5.004.tar.gz',
      description => 'Perl 5.004',
      version     => '5.004',
    },
    {
      source      => 'authors/id/T/TI/TIMB/perl5.004_01.tar.gz',
      description => 'Perl 5.004_01',
      version     => '5.004_01',
    },
    {
      source      => 'authors/id/T/TI/TIMB/perl5.004_02.tar.gz',
      description => 'Perl 5.004_02',
      version     => '5.004_02',
    },
    {
      source      => 'authors/id/T/TI/TIMB/perl5.004_03.tar.gz',
      description => 'Perl 5.004_03',
      version     => '5.004_03',
    },
    {
      source      => 'authors/id/T/TI/TIMB/perl5.004_04.tar.gz',
      description => 'Perl 5.004_04',
      version     => '5.004_04',
    },
    {
      source      => 'authors/id/C/CH/CHIPS/perl5.004_05.tar.gz',
      description => 'Perl 5.004_05',
      version     => '5.004_05',
    },
    {
      source      => 'authors/id/G/GS/GSAR/perl5.005.tar.gz',
      description => 'Perl 5.005',
      version     => '5.005',
    },
    {
      source      => 'authors/id/G/GS/GSAR/perl5.005_01.tar.gz',
      description => 'Perl 5.005_01',
      version     => '5.005_01',
    },
    {
      source      => 'authors/id/G/GS/GSAR/perl5.005_02.tar.gz',
      description => 'Perl 5.005_02',
      version     => '5.005_02',
    },
    {
      source      => 'authors/id/G/GB/GBARR/perl5.005_03.tar.gz',
      description => 'Perl 5.005_03',
      version     => '5.005_03',
    },
    {
      source      => 'authors/id/L/LB/LBROCARD/perl5.005_04.tar.gz',
      description => 'Perl 5.005_04',
      version     => '5.005_04',
    },
    {
      source      => 'authors/id/G/GS/GSAR/perl-5.6.0.tar.gz',
      description => 'Perl 5.6.0',
      version     => '5.6.0',
    },
    {
      source      => 'authors/id/G/GS/GSAR/perl-5.6.1.tar.gz',
      description => 'Perl 5.6.1',
      version     => '5.6.1',
    },
    {
      source      => 'authors/id/R/RG/RGARCIA/perl-5.6.2.tar.gz',
      description => 'Perl 5.6.2',
      version     => '5.6.2',
    },
    {
      source      => 'authors/id/J/JH/JHI/perl-5.7.0.tar.gz',
      description => 'Perl 5.7.0',
      version     => '5.7.0',
    },
    {
      source      => 'authors/id/J/JH/JHI/perl-5.7.1.tar.gz',
      description => 'Perl 5.7.1',
      version     => '5.7.1',
    },
    {
      source      => 'authors/id/J/JH/JHI/perl-5.7.2.tar.gz',
      description => 'Perl 5.7.2',
      version     => '5.7.2',
    },
    {
      source      => 'authors/id/J/JH/JHI/perl-5.7.3.tar.gz',
      description => 'Perl 5.7.3',
      version     => '5.7.3',
    },
    {
      source      => 'authors/id/J/JH/JHI/perl-5.8.0.tar.gz',
      description => 'Perl 5.8.0',
      version     => '5.8.0',
    },
    {
      source      => 'authors/id/J/JH/JHI/perl-5.8.1.tar.gz',
      description => 'Perl 5.8.1',
      version     => '5.8.1',
    },
    {
      source      => 'authors/id/N/NW/NWCLARK/perl-5.8.2.tar.gz',
      description => 'Perl 5.8.2',
      version     => '5.8.2',
    },
    {
      source      => 'authors/id/N/NW/NWCLARK/perl-5.8.3.tar.gz',
      description => 'Perl 5.8.3',
      version     => '5.8.3',
    },
    {
      source      => 'authors/id/N/NW/NWCLARK/perl-5.8.4.tar.gz',
      description => 'Perl 5.8.4',
      version     => '5.8.4',
    },
    {
      source      => 'authors/id/N/NW/NWCLARK/perl-5.8.5.tar.gz',
      description => 'Perl 5.8.5',
      version     => '5.8.5',
    },
    {
      source      => 'authors/id/N/NW/NWCLARK/perl-5.8.6.tar.gz',
      description => 'Perl 5.8.6',
      version     => '5.8.6',
    },
    {
      source      => 'authors/id/N/NW/NWCLARK/perl-5.8.7.tar.gz',
      description => 'Perl 5.8.7',
      version     => '5.8.7',
    },
    {
      source      => 'authors/id/N/NW/NWCLARK/perl-5.8.8.tar.gz',
      description => 'Perl 5.8.8',
      version     => '5.8.8',
    },
    {
      source      => 'authors/id/H/HV/HVDS/perl-5.9.0.tar.gz',
      description => 'Perl 5.9.0',
      version     => '5.9.0',
    },
    {
      source      => 'authors/id/R/RG/RGARCIA/perl-5.9.1.tar.gz',
      description => 'Perl 5.9.1',
      version     => '5.9.1',
    },
    {
      source      => 'authors/id/R/RG/RGARCIA/perl-5.9.2.tar.gz',
      description => 'Perl 5.9.2',
      version     => '5.9.2',
    },
    {
      source      => 'authors/id/R/RG/RGARCIA/perl-5.9.3.tar.gz',
      description => 'Perl 5.9.3',
      version     => '5.9.3',
    },
    {
      source      => 'authors/id/R/RG/RGARCIA/perl-5.9.4.tar.gz',
      description => 'Perl 5.9.4',
      version     => '5.9.4',
    },
    {
      source      => 'authors/id/R/RG/RGARCIA/perl-5.9.5.tar.gz',
      description => 'Perl 5.9.5',
      version     => '5.9.5',
    },
    {
      source      => 'authors/id/R/RG/RGARCIA/perl-5.10.0.tar.gz',
      description => 'Perl 5.10.0',
      version     => '5.10.0',
    }
  ];
}

1;
__END__

=head1 CONFIGURATION AND ENVIRONMENT
  
Perl::Builder requires no configuration files or environment variables.

=head1 DEPENDENCIES

None.

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-perl-builder@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 AUTHOR

Andy Armstrong  C<< <andy.armstrong@messagesystems.com> >>

=head1 LICENCE AND COPYRIGHT

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

Copyright (c) 2008, Message Systems, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or
without modification, are permitted provided that the following
conditions are met:

  * Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in
    the documentation and/or other materials provided with the
    distribution.
  * Neither the name Message Systems, Inc. nor the names of its
    contributors may be used to endorse or promote products derived
    from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
