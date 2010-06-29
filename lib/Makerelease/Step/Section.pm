package Makerelease::Step::Section;

use strict;
use Makerelease::Step;

our $VERSION = '0.1';

our @ISA=qw(Makerelease::Step);

# sub-sections don't skip on the dry-runs...  only executing steps do.
sub possibly_skip_dryrun {
    my ($self, $step, $parentstep, $counter) = @_;
    return 0;
}

sub possibly_skip_yn {
    my ($self, $step, $parentstep, $counter) = @_;
    # the parent will always skip for -n, so we override if and only if -n
    return 0 if ($self->{'opts'}{'n'});
    return $self->SUPER::possibly_skip_yn($step, $parentstep, $counter);
}

sub test {
    my ($self, $step, $parentstep, $counter) = @_;
    return 1 if ($self->require_piece($step, $parentstep, $counter,
				      'steps', 'step'));
    return $self->{'master'}->test_steps($step, "$parentstep$counter.");
}

sub step {
    my ($self, $step, $parentstep, $counter) = @_;

    # XXX: should we call this on the parent module instead of our
    # own?  Probably...
    $self->output("===== Entering Step: $parentstep$counter =====");
    $self->{'master'}->process_steps($step, "$parentstep$counter.");
    $self->output("(Leaving Step: $parentstep$counter)");
    # step does nothing other than print things already handled by the parent
    return;
}

sub print_toc_header {
    my ($self, $step, $parentstep, $counter) = @_;
    $self->output_raw(sprintf("%-15.15s %s\n",
			      "$parentstep$counter", $step->{title}));
    $self->{'master'}->print_toc($step, " $parentstep$counter.");
}


1;

