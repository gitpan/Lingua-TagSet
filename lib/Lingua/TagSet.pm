# $Id: TagSet.pm,v 1.3 2004/04/19 08:30:15 guillaume Exp $
package Lingua::TagSet;

=head1 NAME

Lingua::TagSet - Natural language tagset conversion

=head1 VERSION

Version 0.2

=head1 DESCRIPTION

This module allows to convert values between different tagsets used in natural
language processing, using Lingua::Features as a pivot format

=head1 SYNOPSIS

    use Lingua::TagSet::Multext;

    # tagset to features conversions
    my $struct = Lingua::TagSet::Multext->tag2structure($multext);
    my $string = Lingua::TagSet::Multext->tag2string($multext);

    # features to tagset conversions
    my $multext = Lingua::TagSet::Multext->string2tag($string);
    my $multext = Lingua::TagSet::Multext->structure2tag($structure);

=cut

use Memoize;
use Lingua::Features;
use strict;
use warnings;

our $VERSION = '0.2';

my (%tag2string, %string2tag);
memoize 'tag2string', SCALAR_CACHE => [ HASH => \%tag2string ];
memoize 'string2tag', SCALAR_CACHE => [ HASH => \%string2tag ];

my %tokens_trees;
my %features_trees;
my %tokens_tables;
my %features_tables;

sub _init {
    my ($class) = @_;

    no strict 'refs';

    my $tokens_tree    = {};
    my $features_tree  = {};
    my $tokens_table   = {};
    my $features_table = {};

    foreach my $map (@{$class . '::id_maps'}) {

	# token to feature: tree of tokens valued by mappings
	my $token_leaf;
	$token_leaf->{features} = $map->{features};
	$token_leaf->{submap}   = $map->{submap} if $map->{submap};

	my $token_node = $tokens_tree;
	for (my $i = 0; $i <= $#{$map->{tokens}}; $i++) {
	    my $token = $map->{tokens}->[$i];
	    if ($i == $#{$map->{tokens}}) {
		# end of tokens list
		foreach my $value (split(/\|/, $token)) {
		    if ($token_node->{$value}->{_map}) {
			push (@{$token_node->{$value}->{_map}}, $map);
		    } else {
			$token_node->{$value}->{_map} = [ $map ]
		    }
		}
	    } else {
		# still tokens left
		$token_node->{$token} = {} unless $token_node->{$token} ;
		$token_node = $token_node->{$token};
	    }
	}

	# feature to token: tree of features valued by mappings
	my $feature_leaf;
	$feature_leaf->{tokens} = $map->{tokens};
	$feature_leaf->{submap} = $map->{submap} if $map->{submap};

	my $feature_node = $features_tree;
	for (my $i = 0; $i <= $#{$map->{features}}; $i++) {
	    my $category = $map->{features}->[$i];
	    if ($i == $#{$map->{features}}) {
		# end of features list
		foreach my $value (split(/\|/, $category)) {
		    if ($feature_node->{$value}->{_map}) {
			push (@{$feature_node->{$value}->{_map}}, $map);
		    } else {
			$feature_node->{$value}->{_map} = [ $map ]
		    }
		}
	    } else {
		# still category left
		$feature_node->{$category} = {} unless $feature_node->{$category} ;
		$feature_node = $feature_node->{$category};
	    }
	}
    }

    while (my ($type, $map) = each %{$class . '::value_maps'}) {
	foreach my $item (@{$map}) {
	    # token to feature: feature values indexed by token value
	    push(@{$tokens_table->{$type}->{$item->[0]}}, $item->[1]);
	    # feature to token: token values indexed by feature value
	    push(@{$features_table->{$type}->{$item->[1]}}, $item->[0]);
	}
    }

    $tokens_trees{$class}    = $tokens_tree;
    $features_trees{$class}  = $features_tree;
    $tokens_tables{$class}   = $tokens_table;
    $features_tables{$class} = $features_table;
}

=head2 Lingua::TagSet->tag2structure()

Convert a tag to a features structure.

=cut

sub tag2structure {
    my ($class, $tokens, %args) = @_;

    return unless $tokens;

    # get converter data
    my $tree  = $tokens_trees{$class};
    my $table = $tokens_tables{$class};

    # find matching maps
    my $id_maps = _get_maps_from_tree($tree, $tokens);
    return unless $id_maps;

    # select most relevant one
    my @id_maps = @{$id_maps};
    my $id_map = $id_maps[0];

    # compute category and subcategory
    my $structure = Lingua::Features::Structure->new();
    my @categories = split(/\|/, $id_map->{features}->[0]);
    $structure->tag('cat', @categories);
    if (@{$id_map->{features}} == 2) {
	my @subcategories = split(/\|/, $id_map->{features}->[1]);
	$structure->tag($categories[0] . '_type', @subcategories);
    }

    # compute other features
    my $submap = $id_map->{submap};
    if ($submap) {
	for (my $i = 0; $i <= $#$submap; $i++) {
	    next unless $submap->[$i]; # not appliable
	    foreach my $feature_id (split(/&/, $submap->[$i])) {
		my $feature = $Lingua::Features::lib->feature($feature_id);
		die "no feature $feature_id" unless $feature;

		my $token = $tokens->[$i];
		next unless $token; # not appliable

		my $type      = $feature->type();
		my $type_id   = $type->id();
		my $value_map = $table->{$type_id};
		die "no value map for type $type_id" unless $value_map;

		my @values;
		if ($token eq '.') {
		    # explicit undefined value
		    splice @$tokens, $i, 0, undef;
		    next;
		} else {
		    # single or multiple values
		    if ($value_map->{$token}) {
			@values = @{$value_map->{$token}};
		    } else {
			if ($args{no_strict_align}) {
			    # consider undefined value
			    splice @$tokens, $i, 0, undef;
			    next;
			}
		    }
		    foreach my $value (@values) {
			die "illegal value $value for type $type_id" unless $type->value($value);
		    }
		}
		$structure->tag($feature_id, @values);
	    }
	}
    }

    return $structure;
}

=head2 Lingua::TagSet->structure2tag()

Convert a features structure to a tag.

=cut

sub structure2tag {
    my ($class, $structure, %args) = @_;

    return unless $structure;

    # get converter data
    my $tree  = $features_trees{$class};
    my $table = $features_tables{$class};

    # get structure category
    my @categories    = $structure->tag('cat')->values();
    my $category      = $categories[0]; # FIXME: handle category conjonction
    my $subcategory;
    my $subcategory_tag = $structure->tag($category . '_type');
    if ($subcategory_tag) {
	my @subcategories = $subcategory_tag->values();
	$subcategory   = $subcategories[0];
    }

    # find matching maps
    my $id_maps = _get_maps_from_tree($tree, [ $category, $subcategory ]);
    return unless $id_maps;

    # select most relevant one
    my $id_map = _select_alternative_maps(
	$id_maps,
	[
	    sub { return $_->{features}->[0] !~ /\|/ }, # prefer specific maps
	    sub { return $_->{submap} }                 # prefer exhaustive maps
	]
    );

    # compute first tokens
    my @tokens = @{$id_map->{tokens}};
    my $offset = @tokens;

    # handle special values
    @tokens = map { /\|/ ? [ split(/\|/, $_) ] : $_ } @tokens;

    # compute other tokens
    my $submap = $id_map->{submap};
    if ($submap) {
	for (my $i = 0; $i <= $#$submap; $i++) {
	    my (@token_values, @all_token_values);
	    CASE: {
		my $feature_ids = $submap->[$i];
		last CASE unless $feature_ids; # not appliable

		my @feature_ids = split(/&/, $feature_ids);
		foreach my $feature_id (@feature_ids) {
		    my $feature = $Lingua::Features::lib->feature($feature_id);
		    die "no feature $feature_id" unless $feature;

		    my $tag = $structure->tag($feature_id);
		    next unless $tag; # not appliable

		    my @feature_values = $tag->values();
		    next unless @feature_values;

		    my $type      = $feature->type();
		    my $type_id   = $type->id();
		    my $value_map = $table->{$type_id};
		    die "no value map for type $type_id" unless $value_map;

		    foreach my $feature_value (@feature_values) {
			push(@token_values, @{$value_map->{$feature_value}}) if $value_map->{$feature_value};
		    }
		}

		# filter values
		my %count;
		$count{$_}++ foreach @token_values;
		my %seen;
		@token_values =
		    grep { ! $seen{$_}++ }              # filter duplicates
		    grep { $count{$_} == @feature_ids } # filter values uncompatible with all features
		    @token_values;
	    }
	    $tokens[$i + $offset] =
		@token_values > 1 ?
		\@token_values :
		$token_values[0];
	}
    }

    return @tokens;
}

sub _get_maps_from_tree {
    my ($node, $tokens, $result) = @_;

    # extract first token
    my $token = shift @$tokens;

    # keep current map if present
    if ($node->{_map}) {
	$result = $node->{_map};
    }

    # try to get further if still tokens left
    if ($token) {
	# get further if specific pattern node exist
	if ($node->{$token}) {
	    return _get_maps_from_tree($node->{$token}, $tokens, $result);
	}

	# get further if generic pattern node exist
	if ($node->{'.'}) {
	    return _get_maps_from_tree($node->{'.'}, $tokens, $result);
	}
    }

    # otherwise return current result
    unshift @$tokens, $token;
    return $result;
}

sub _select_alternative_maps {
    my ($maps, $functions) = @_;

    # return unique solution
    return $maps->[0] if $#$maps == 0;

    my $function = shift @$functions;

    # keep filtering while criterias available
    if ($function) {
	my @filtered_maps = grep { $function->($_) } @$maps;
	return @filtered_maps ?
	    _select_alternative_maps(\@filtered_maps, $functions) :
	    _select_alternative_maps($maps, $functions) ;
    }

    # otherwise merge remaining mappings
    my $max = 0;
    for my $map (@$maps) {
	$max = $#{$map->{tokens}} if $#{$map->{tokens}} > $max
    }

    my @tokens;
    for (my $i = 0; $i <= $max; $i++) {
	$tokens[$i] = join('|', map { $_->{tokens}->[$i] } @$maps);
    }

    return {
	tokens => \@tokens
    }
}

=head2 Lingua::TagSet->tag2string()

Convert a tag into a string representation of a features structure.
The result is cached.

=cut

sub tag2string {
    my ($class, $tag) = @_;
    return unless $tag;
    my $structure = $class->tag2structure($tag);
    return $structure ? $structure->to_string(): '';
}

=head2 Lingua::TagSet->string2tag()

Convert a string representation of a features structure into a tag.
The result is cached.

=cut

sub string2tag {
    my ($class, $string) = @_;
    return unless $string;
    my $structure = Lingua::Features::Structure->from_string($string);
    my $tag = $class->structure2tag($structure);
    return $tag ? $tag : '';
}

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004, INRIA.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 AUTHOR

Guillaume Rousse <grousse@cpan.org>

=cut

1;
