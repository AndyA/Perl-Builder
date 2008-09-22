package Loggable;

use Moose::Role;

requires 'option';

sub log { print 'Option is ', shift->option, "\n" }

1;
