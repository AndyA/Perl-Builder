package Configurable;

use Moose::Role;
use Configuration;

has 'config' => (
  handles  => ['option'],
  default  => sub { Configuration->new },
);

#sub option { 'fake' }

1;
