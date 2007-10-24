package Makerelease::Step::Modify;

use strict;
use Makerelease::Step;
use IO::File;

our $VERSION = "0.1";

our @ISA=qw(Makerelease::Step);

sub get_files {
    my ($self, $modify) = @_;

    my @files;

    my $files = $modify->{'files'};
    if (ref($files) eq 'HASH') {
	foreach my $fileref (@{$self->ensure_array($files->{'file'})}) {
	    push @files, glob($self->expand_parameters($fileref));
	}
    } else {
	@files = glob($self->expand_parameters($modify->{'files'}));
    }

    return \@files;
}

sub step {
    my ($self, $step, $parentstep, $counter) = @_;

    foreach my $modify (@{$step->{'modifications'}[0]{'modify'}}) {
	my $files = $self->get_files($modify);
	my $findregex = $self->expand_parameters($modify->{'find'});
	my $replaceregex = $self->expand_parameters($modify->{'replace'});

	my $asub = eval "sub { s/$findregex/$replaceregex/; }";

	foreach my $file (@$files) {

	    $self->output("modifying $file\n");

	    my $in = new IO::File();
	    my $out = new IO::File();
	    $in->open("<$file") || die "ack: couldn't open $file";
	    $out->open(">$file.mrnew") || die "ack: couldn't open $file.mrnew";

	    while (<$in>) {
		$asub->();
		print $out $_;
	    }

	    $in->close();
	    $out->close();
			
	    rename("$file","$file.bak");
	    rename("$file.mrnew","$file");
	}
    }
}

sub document_step {
    my ($self, $step, $parentstep, $counter) = @_;

    foreach my $modify (@{$step->{'modifications'}[0]{'modify'}}) {
	my $findregex = $self->expand_parameters($modify->{'find'});
	my $replaceregex = $self->expand_parameters($modify->{'replace'});
	$self->output("Modifying files:\n");
	$self->output("  replacing: '$findregex' with: '$replaceregex'\n\n");
	$self->output("  files:  glob=" .
		      $self->expand_parameters($modify->{'files'}) . "\n");
	my $files = $self->get_files($modify);
	foreach my $file (@$files) {
	    $self->output("    " . $file . "\n");
	}
	$self->output("\n");
    }
}

1;

