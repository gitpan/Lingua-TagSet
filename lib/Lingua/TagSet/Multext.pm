# $Id: Multext.pm,v 1.1.1.1 2004/04/13 15:32:23 guillaume Exp $
package Lingua::TagSet::Multext;

=head1 NAME

Lingua::TagSet::Multext - Multext tagset for Lingua::TagSet

=cut


use base qw/Lingua::TagSet/;
use strict;
use warnings;

our @id_maps = (
    {
	features => [ 'noun' ],
	tokens   => [ 'X' ]
    },
    {
	features => [ 'noun' ],
	tokens   => [ 'N' ],
	submap   => [ 'noun_type', 'gender', 'num', undef, 'sem' ]
    },
    {
	features => [ 'verb' ],
	tokens   => [ 'V' ],
	submap   => [ 'verb_type', 'mode', 'tense', 'pers', 'num', 'gender', undef ]
    },
    {
	features => [ 'det|adj' ],
	tokens   => [ 'M', 'c' ],
	submap   => [ 'gender', 'num' ]
    },
    {
	features => [ 'adj' ],
	tokens   => [ 'A' ],
	submap   => [ 'adj_type', 'degree', 'gender', 'num', undef ]
    },
    {
	features => [ 'det' ],
	tokens   => [ 'D' ],
	submap   => [ 'det_type', 'pers', 'gender', 'num', undef, 'numposs', 'def', undef ]
     },
    {
	features => [ 'pron' ],
	tokens   => [ 'P' ],
	submap   => [ 'pron_type', 'pers', 'gender', 'num', 'case', 'numposs' ]
    },
    {
	features => [ 'advneg' ],
	tokens   => [ 'R', '.', 'n|d' ],
    },
    {
	features => [ 'adv' ],
	tokens   => [ 'R' ],
    },
    {
	features => [ 'prep' ],
	tokens   => [ 'S', 'p' ]
    },
    {
	features => [ 'cc' ],
	tokens   => [ 'C', 'c' ]
    },
    { 
	features => [ 'cs' ],
	tokens   => [ 'C', 's' ]
    },
    { 
	features => [ 'interj' ],
	tokens   => [ 'I' ],
    },
    {
	features => [ 'ponct' ],
	tokens   => [ 'F' ],
    },
);

our %value_maps = (
    det_type_type => [
	[ qw/a art/ ],
	[ qw/d dem/ ],
	[ qw/i ind/ ],
	[ qw/s poss/ ],
	[ qw/t int/ ],
	[ qw/t excl/ ],
    ],
    adj_type_type => [
	[ qw/f qual/ ],
	[ qw/o ord/ ],
	[ qw/i ind/ ],
	[ qw/s poss/ ],
    ],
    noun_type_type => [ 
	[ qw/f qual/ ],
	[ qw/o ord/ ],
	[ qw/i ind/ ],
	[ qw/c common/ ],
	[ qw/p proper/ ],
	[ qw/d dist/ ],
    ],
    pron_type_type => [
    	[ qw/p pers/ ],
    	[ qw/d dem/ ],
	[ qw/r rel/ ],
	[ qw/x cli/ ],
	[ qw/i ind/ ],
	[ qw/s poss/ ],
	[ qw/t int/ ],
    ],
    verb_type_type => [ 
    	[ qw/a avoir/ ],
	[ qw/e etre/ ],
	[ qw/m main/ ],
    ],
    mode_type => [ 
    	[ qw/i ind/ ],
	[ qw/s subj/ ],
	[ qw/m imp/ ],
	[ qw/c cond/ ],
	[ qw/n inf/ ],
	[ qw/p part/ ],
    ],
    tense_type => [ 
    	[ qw/p pres/ ],
	[ qw/i imp/ ],
	[ qw/f fut/ ],
	[ qw/s past/ ],
    ],
    pers_type => [
	[ qw/1 1/ ],
	[ qw/2 2/ ],
	[ qw/3 3/ ],
    ],
    gender_type => [
	[ qw/m masc/ ],
	[ qw/f fem/ ],
    ],
    num_type => [
	[ qw/p pl/ ],
	[ qw/s sing/ ],
    ],
    case_type => [ 
	[ qw/j acc/ ],
	[ qw/j dat/ ],
	[ qw/n nom/ ],
	[ qw/o obl/ ],
    ],
    degree_type => [
	[ qw/p pos/ ],
	[ qw/c comp/ ],
    ],
    res_type => [
	[ qw/u unit/ ],
	[ qw/e exp/ ],
	[ qw/f foreign/ ],
    ],
    sem_type => [
    	[ qw/c pl/ ],
	[ qw/h inh/ ],
	[ qw/s ent/ ],
    ],
    def_type => [
    	[ qw/d def/ ],
	[ qw/i ind/ ],
    ]
);

__PACKAGE__->_init();

sub tag2structure {
    my ($class, $tag) = @_;

    # fail fast
    return unless $tag;

    # split tag in tokens
    my @tokens = split(//, $tag);

    # convert special values
    @tokens = map { $_ eq '-' ? undef : $_ } @tokens;

    # call generic routine
    return $class->SUPER::tag2structure(\@tokens);
}

sub structure2tag {
    my ($class, $structure) = @_;

    # call generic routine
    my @tokens = $class->SUPER::structure2tag($structure);

    # convert special values
    @tokens =
	map { ref $_ eq 'ARRAY' ? '[' . join('', @$_) . ']' : $_ } 
	map { $_ ? $_ : '-' }
	@tokens;

    # join tokens in tag
    my $tag = join('', @tokens);

    return $tag;
}

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004, INRIA.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 AUTHOR

Guillaume Rousse <grousse@cpan.org>

=cut

1;
