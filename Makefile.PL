# $Id: Makefile.PL,v 1.1.1.1 2004/04/13 15:32:23 guillaume Exp $

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'         => 'Lingua::TagSet',
    'VERSION_FROM' => 'lib/Lingua/TagSet.pm',
    'AUTHOR'       => 'Guillaume Rousse',
    'PREREQ_PM'    => {
	'Lingua::Features' => 0,
	'Memoize'          => 0
    }
);
