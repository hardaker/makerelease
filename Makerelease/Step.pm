package Makerelease::Step;

use strict;
use Makerelease;

our $VERSION = "0.1";

our @ISA=qw(Makerelease);

sub start_step {
    my ($self, $step) = @_;
}

sub possibly_skip_yn {
    my ($self, $step, $parentstep, $counter) = @_;

    if ($self->{'opts'}{'i'} || $step->{'interactive'}) {
	my $info = $self->getinput("Do step $parentstep$counter (y,n,q)?");
	if ($info eq 'q') {
	    $self->output("... quitting as requested\n");
	    exit;
	}
	if ($info eq 'n') {
	    $self->output("... skipping step $parentstep$counter\n");
	    return 1;
	}
    }
    return 0;
}

sub possibly_skip_dryrun {
    my ($self, $step, $parentstep, $counter) = @_;
    if ($self->{'opts'}{'n'}) {
	$self->document_step($step, $parentstep, $counter);
	return 1;
    }
    return 0;
}

# return 1 to skip, 0 to do it
sub possibly_skip {
    my $self = shift;

    my ($step, $parentstep, $counter) = @_;

    # handle -n
    return 1 if ($self->possibly_skip_dryrun(@_));

    # handle -i
    return $self->possibly_skip_yn(@_);
}

sub print_description {
    my ($self, $step) = @_;
    my $text = $self->expand_parameters($step->{'text'});
    $text =~ s/\n\s*$//g;
    print $text, "\n\n" if ($text);
}

sub finish_step {
    my ($self, $step, $parentstep, $counter) = @_;

    # maybe sleep if we're not pausing
    if (!$self->{'opts'}{'p'} && !$step->{'pause'}) {
	sleep($self->{'opts'}{'s'}) if ($self->{'opts'}{'s'});
	return;
    }

    # pause display
    my $info = $self->getinput("---- PRESS ENTER TO CONTINUE (q=quit) ----");
    if ($info eq 'q') {
	$self->output("Quitting...\n");
	exit;
    }
}

sub document_step {
}

sub expand_parameters {
    my ($self, $string) = @_;

    # ignore {} sets with a leading $
    $string =~ s/([^\$]){([^\}]+)}/$1$self->{'parameters'}{$2}/g;
    return $string;
}

sub test {
    my ($self) = @_;
    return 0;
}

1;

