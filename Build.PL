use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
  module_name => 'Perl::Builder',
  license     => 'perl',
  dist_author => 'Andy Armstrong <andy.armstrong@messagesystems.com>',
  dist_version_from => 'lib/Perl/Builder.pm',
  requires          => {
    'App::Cmd'       => '0.200',
    'LWP::UserAgent' => 0,
    'Moose'          => '0.50',
    'Test::More'     => 0,
  },
  add_to_cleanup => ['Perl-Builder-*'],
);

$builder->create_build_script();
