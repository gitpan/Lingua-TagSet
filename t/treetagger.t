#!/usr/bin/perl
# $Id: treetagger.t,v 1.1 2004/04/16 13:27:35 guillaume Exp $

use Lingua::TagSet::TreeTagger;
use Test::More;
use strict;

# compute plan
open(T2S, 'treetagger2feature') or die "unable to open treetagger2feature: $!";
my @tags2strings = <T2S>;
close(T2S);
open(S2T, 'feature2treetagger') or die "unable to open feature2treetagger: $!";
my @strings2tags = <S2T>;
close(S2T);
plan tests => @tags2strings + @strings2tags;

foreach my $test (@tags2strings ) {
    chomp $test;
    my ($tag, $string) = split(/\t/, $test);
    is(Lingua::TagSet::TreeTagger->tag2string($tag), $string, "$tag conversion"); 
}

foreach my $test (@strings2tags) {
    chomp $test;
    my ($string, $tag) = split(/\t/, $test);
    is(Lingua::TagSet::TreeTagger->string2tag($string), $tag, "$string conversion"); 
}