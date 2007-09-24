#!/usr/bin/perl

use ExtUtils::MakeMaker;

%opts = (
	 'NAME'		=> 'makerelease',
	 'PREREQ_PM'    => { XML::Simple => 0 },
	 'EXE_FILES' => [qw(makerelease)],
	);

WriteMakefile(%opts);
