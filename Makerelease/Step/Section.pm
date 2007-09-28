package Makerelease::Step::Section;

use strict;
use Makerelease::Step;

our @ISA=qw(Makerelease::Step);

sub step {
    my ($self, $step, $parentstep, $counter) = @_;

    # XXX: should we call this on the parent module instead of our
    # own?  Probably...
    print "here: $parentstep$counter.\n";
    $self->{'master'}->process_steps($step, "$parentstep$counter.");
    # step does nothing other than print things already handled by the parent
    return;
}

1;

