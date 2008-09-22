package Thing;

use Moose;

with 'Configurable', 'Loggable';

sub run { shift->log }

1;
