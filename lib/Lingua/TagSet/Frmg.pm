package Lingua::TagSet::Frmg;
use base qw/Lingua::TagSet/;
use strict;
use warnings;

our @id_maps = (
		{ features => { cat => 'noun' },
		  tokens => [ pos => 'nc', gender => undef, number => undef ],
		  submap   => [
			       3 => 'gender',
			       5 => 'num',
			      ]
		},
		{ features => { cat => 'noun', type => 'proper'},
		  tokens => [ pos => 'np', gender => undef, number => undef ],
		  submap   => [
			       3 => 'gender',
			       5 => 'num',
			      ]
		},
		{ features => { cat => 'ponct' },
		  tokens => [ pos => ['poncts','ponctw'] ],
		  submap => [
			    ]
		},
		{ features => { cat => 'verb' },
		  tokens => [ pos => ['v','aux'], mood => undef, tense => undef, pers => undef, number => undef ],
		  submap => [
			     3 => 'mode',
			     5 => 'tense',
			     7 => 'pers',
			     9 => 'num'
			    ]
		},
		{ features => { cat => 'adv' },
		  tokens => [ pos => 'adv', degree => undef ],
		  submap => [
			     3 => 'degree'
			    ]
		},
		{ features => { cat => 'adj' },
		  tokens => [ pos => 'adj', gender => undef, number => undef, degree => undef ],
		  submap   => [
			       3 => 'gender',
			       5 => 'num',
			       7 => 'degree'
			      ]
		},
		{ features => { cat => 'advneg' },
		  tokens => [ pos => 'advneg' ],
		  submap => [
			    ]
		},
		{ features => { cat => 'det' },
		  tokens => [ pos => 'det', number => undef, gender => undef, def => undef ],
		  submap => [
			     3 => 'num',
			     5 => 'gender',
			     7 => 'def'
			    ]
		},
		{ features => { cat => 'pron' },
		  tokens => [ pos => 'pro', gender => undef, number => undef, person => undef ],
		  submap   => [
			       3 => 'gender',
			       5 => 'num',
			       7 => 'pers'
			      ]
		},
		{ features => { cat => 'pron', type => 'cli' },
		  tokens => [ pos => ['cln','cla','cld','clr','clg','cll'], 
			      case => undef,  gender => undef, number => undef, person => undef ],
		  submap   => [
			       3 => 'case',
			       5 => 'gender',
			       7 => 'num',
			       9 => 'pers'
			      ]
		},
		{ features => { cat => 'pron', type => 'int' },
		  tokens => [ pos => 'pri', fct => undef,  gender => undef, number => undef, person => undef ],
		  submap   => [
			       3 => 'case',
			       5 => 'gender',
			       7 => 'num',
			       9 => 'pers'
			      ]
		},
		{ features => { cat => 'pron', type => 'rel' },
		  tokens => [ pos => 'prel', fct => undef,  gender => undef, number => undef, person => undef ],
		  submap   => [
			       3 => 'case',
			       5 => 'gender',
			       7 => 'num',
			       9 => 'pers'
			      ]
		},
		{ features => { cat => 'cc' },
		  tokens => [ pos => 'coo' ],
		  submap => [
			    ]
		},
		{ features => { cat => 'cs' },
		  tokens => [ pos => 'csu' ],
		  submap => [
			    ]
		},
		{ features => { cat => 'prep' },
		  tokens => [ pos => 'prep' ],
		  submap => [
			    ]
		},
	       );

our %value_maps = (
		   mode => [ 
			    indicative => 'ind',
			    subjunctive => 'subj',
			    imperative => 'imp',
			    conditional => 'cond',
			    infinitive => 'inf',
			    participle => 'part',
			    gerundive => 'ger'
			   ],
		   tense => [ 
			     present => 'pres',
			     imperfect => 'imp',
			     future => 'fut',
			     past => 'past',
			    ],
		   pers => [
			    1 => '1',
			    2 => '2',
			    3 => '3',
			   ],
		   gender => [
			      masc => 'masc',
			      fem => 'fem',
			     ],
		   num => [
			   pl => 'pl',
			   sing => 'sing',
			  ],
		   case => [ 
			    acc => 'acc',
			    dat => 'dat',
			    nom => 'nom',
##			    obl => 'obl',
			    refl => 'refl',
			    gen => 'gen',
			    loc => 'loc'
			   ],
		   cli => [ 
			   cla => 'acc',
			   cld => 'dat',
			   cln => 'nom',
			   clr => 'refl',
			  ],
		   degree => [
			      pos => 'pos',
			      comp => 'comp',
			     ],
		   def => [
			   true => 'def',
			   false => 'ind',
			  ]
		  );

__PACKAGE__->_init();

sub structure2tag {
  my ($class, $structure) = @_;
  
  # call generic routine
  my $tag    = $class->SUPER::structure2tag($structure);
  my @tokens = $tag->get_tokens();
  
  my @v=();
  
  while (@tokens) {
    my $f = shift @tokens;
    my $x = shift @tokens;
    next unless ((defined $x) && ref($x) eq 'ARRAY');
    $x = join('.',@$x);
    push(@v,"@$f.$x");
    }
  
  return join(' ',@v);
}

1;
