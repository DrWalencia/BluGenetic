#
#===============================================================================
#
#         FILE: BluGenetic.t
#
#  DESCRIPTION: Basic set of tests that attempt to prove that the basic
#               functionality regarding the factory that will take care of
#               the generation of the proper type of algorithm according
#               to the information passed as parameters by the user.
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/29/2013 07:57:29 PM
#     REVISION: ---
#===============================================================================
use Test::More;
use Log::Log4perl qw(get_logger);
use BluGenetic;
use diagnostics;
use strict;
use warnings;

# Tests for checking if a certain section of code dies
use Test::Exception;
my $conf = q(

############################################################
## A simple root logger with a Log::Log4perl::Appender::File 
## file appender in Perl.
#############################################################
log4perl.rootLogger=DEBUG, LOGFILE

log4perl.appender.LOGFILE=Log::Log4perl::Appender::File
log4perl.appender.LOGFILE.filename=./BluGenetic.log
log4perl.appender.LOGFILE.mode=write

log4perl.appender.LOGFILE.layout=PatternLayout
log4perl.appender.LOGFILE.layout.ConversionPattern=[%d] %F %L %p - %m%n

);
## Initialize logging behavior
Log::Log4perl->init( \$conf );

# This fitness function just returns the amount of ones in
# the genotype.
sub fitness() {
	my ($individual) = @_;
	my $genotype = $individual->getGenotype();
	my $i;
	my $counter;
	for ( $i = 0 ; $i < $genotype->getLength() ; $i++ ) {
		$counter += $genotype->getGen($i);
	}
	return $counter;
}

sub terminate() {

    my $GA = shift;

    
	return 0;
}

# In here there should be tests trying almost any possible input by the user,
# so that the library looks sturdy.

# If popSize undefined, die painfully
dies_ok{
	my $algorithm = BluGenetic->new(
		type	=>	"BitVector",
		fitness	=>	\&fitness
	)
} "Constructor: popSize undefined, die painfully";

# If type undefined, die painfully
dies_ok{
	my $algorithm = BluGenetic->new(
		popSize	=>	24,
		fitness	=>	\&fitness
	)
} "Constructor: type undefined, die painfully";

# If fitness undefined, die painfully
dies_ok{
	my $algorithm = BluGenetic->new(
		popSize	=> 23,
		type	=> "BitVector"
	)
} "Constructor: fitness undefined, die painfully";

# If mutation defined but wrong, die painfully
dies_ok{
	my $algorithm = BluGenetic->new(
		popSize => 24,
		mutation => -4,
		type => "BitVector",
		fitness => \&fitness
	)	
} "Constructor: mutation defined but wrong, die painfully (negative)";

dies_ok{
	my $algorithm = BluGenetic->new(
		popSize => 24,
		mutation => 1.1,
		type => "BitVector",
		fitness => \&fitness
	)	
} "Constructor: mutation defined but wrong, die painfully (more than 1)";

# if crossover defined but wrong, die painfully
dies_ok{
	my $algorithm = BluGenetic->new(
		popSize => 24,
		crossover => -3,
		type => "BitVector",
		fitness => \&fitness
	)	
} "Constructor: crossover defined but wrong (negative), die painfully";

dies_ok{
	my $algorithm = BluGenetic->new(
		popSize => 24,
		crossover => 1.01,
		type => "BitVector",
		fitness => \&fitness
	)	
} "Constructor: crossover defined but wrong (more than 1), die painfully";

# Check that a call to the factory with BitVector in a mix of
# cases, all upercase and all lowercase do not die and returns
# the proper algorithm.

# Check bitvector: uppercase and lowercase
{
	my $algorithm = BluGenetic->new(
		popSize		=> 33,
		type		=> 'BITVECTOR',
		fitness		=> \&fitness
	);
	
	ok ( $algorithm->isa('GABitVector'), "Constructor: type case insensitive: BITVECTOR" );
}

{
	my $algorithm = BluGenetic->new(
		popSize		=> 33,
		type		=> 'BitVector',
		fitness		=> \&fitness
	);
	
	ok ( $algorithm->isa('GABitVector'), "Constructor: type case insensitive: BitVector" );
}

# Check rangevector: uppercase and lowercase
{
	my $algorithm = BluGenetic->new(
		popSize		=> 33,
		type		=> 'RANGEVECTOR',
		fitness		=> \&fitness
	);
	
	ok ( $algorithm->isa('GARangeVector'), "Constructor: type case insensitive: RANGEVECTOR" );
}

{
	my $algorithm = BluGenetic->new(
		popSize		=> 33,
		type		=> 'RangeVector',
		fitness		=> \&fitness
	);
	
	ok ( $algorithm->isa('GARangeVector'), "Constructor: type case insensitive: RangeVector" );
}

# Check listvector: uppercase and lowercase
{
	my $algorithm = BluGenetic->new(
		popSize		=> 33,
		type		=> 'LISTVECTOR',
		fitness		=> \&fitness
	);
	
	ok ( $algorithm->isa('GAListVector'), "Constructor: type case insensitive: LISTVECTOR" );
}

{
	my $algorithm = BluGenetic->new(
		popSize		=> 33,
		type		=> 'ListVector',
		fitness		=> \&fitness
	);
	
	ok ( $algorithm->isa('GAListVector'), "Constructor: type case insensitive: ListVector" );
}

# Unknown data type (die painfully)

dies_ok{
	my $algorithm = BluGenetic->new(
		popSize		=> 33,
		type		=> 'UNKNOWN',
		fitness		=> \&fitness
	)
} "Constructor: unknown data type. Dies";

# Example that works.

#my $algorithm = BluGenetic->new(
#
#    popSize     => 12,
#    crossover   => 0.9,
#    mutation    => 0.05,
#    type        => 'BITVECTOR',
#    fitness     => \&fitness,
#    terminate   => \&terminate,
#);
#
#$algorithm->initialize(10);
#
#$algorithm->evolve(
#    selection   => 'tournament',
#    crossover   =>  'onepoint',
#    generations =>  25,
#);





# TODO make getFittest return just an individual, not an array if
# it is called without arguments.

#my @ind = $algorithm->getFittest();
#
#print "Score of fittest: ", $ind[0]->getScore(), "\n";

done_testing;

