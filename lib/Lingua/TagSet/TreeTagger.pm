# $Id: TreeTagger.pm,v 1.1 2004/04/16 13:25:28 guillaume Exp $
package Lingua::TagSet::TreeTagger;

=head1 NAME

Lingua::TagSet::TreeTagger - TreeTagger tagset for Lingua::TagSet

=cut

use base qw/Lingua::TagSet/;
use strict;

our @id_maps = (
    {
	features => [ 'abr' ],
	tokens   => [ 'ABR' ],
    },
    {
	features => [ 'adj' ],
	tokens   => [ 'ADJ' ],
    },
    {
	features => [ 'adv' ],
	tokens   => [ 'ADV' ]
    },
    {
	features => [ 'det' ],
	tokens   => [ 'DET' ],
	submap   => [ 'det_type' ]
    },
    {
	features => [ 'interj' ],
	tokens   => [ 'INT' ],
    },
    {
	features => [ 'cc|cs' ],
	tokens   => [ 'KON' ],
    },
    {
	features => [ 'noun', 'common' ],
	tokens   => [ 'NOM' ],
    },
    {
	features => [ 'noun', 'proper' ],
	tokens   => [ 'NAM' ],
    },
    {
	features => [ 'noun|adj|det' ],
	tokens   => [ 'NUM' ],
    },
    {
	features => [ 'pron' ],
	tokens   => [ 'PRO' ],
	submap   => [ 'pron_type' ]
    },
    {
	features => [ 'ponct' ],
	tokens   => [ 'PUN' ],
    },
    {
	features => [ 'prep' ],
	tokens   => [ 'PRP' ],
    },
    {
	features => [ 'ponct' ],
	tokens   => [ 'SENT' ],
    },
    {
	features => [ 'x' ],
	tokens   => [ 'SYM' ],
    },
    {
	features => [ 'verb' ],
	tokens   => [ 'VER' ],
	submap   => [ 'mode&tense' ]
    },
);

our %value_maps = (
    det_type_type => [
	[ qw/POS poss/ ],
    ],
    pron_type_type => [
    	[ qw/DEM dem/ ],
	[ qw/REL rel/ ],
	[ qw/IND ind/ ],
	[ qw/POS poss/ ],
	[ qw/PER pers/ ],
    ],
    mode_type => [ 
	[ qw/cond cond/ ],
    	[ qw/futu ind/ ],
	[ qw/impe imp/ ],
	[ qw/impf ind/ ],
	[ qw/infi inf/ ],
	[ qw/pper part/ ],
	[ qw/ppre part/ ],
	[ qw/pres ind/ ],
	[ qw/simp ind/ ],
	[ qw/subi subj/ ],
	[ qw/subp subj/ ],
    ],
    tense_type => [
    	[ qw/futu fut/ ],
	[ qw/impe pres/ ],
	[ qw/impf imp/ ],
	[ qw/infi pres/ ],
	[ qw/pper past/ ],
	[ qw/ppre pres/ ],
	[ qw/pres pres/ ],
	[ qw/simp past/ ],
	[ qw/subi imp/ ],
	[ qw/subp pres/ ],
    ],
);

__PACKAGE__->_init();

sub tag2structure {
    my ($class, $tag) = @_;

    # fail fast
    return unless $tag;

    # split tag in parts
    my @tokens = split(/:/, $tag, 2);

    # convert special values
    @tokens = map { defined $_ ? $_ : '' } @tokens;

    # call generic routine
    return $class->SUPER::tag2structure(\@tokens);
}

sub structure2tag {
    my ($class, $structure) = @_;

    # call generic routine
    my @tokens = $class->SUPER::structure2tag($structure);

    # handle special cases
    @tokens =
	map { $_ ? $_ : '' }
	map { ref $_ eq 'ARRAY' ? $_->[0] : $_ }
	@tokens;

    # join tokens in tag
    my $tag = join(':', @tokens);

    return $tag;
}

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004, INRIA.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 AUTHOR

Guillaume Rousse <grousse@cpan.org>

=cut

1;
