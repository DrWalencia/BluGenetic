#
#===============================================================================
#
#         FILE: Individual.t
#
#  DESCRIPTION: Basic set of tests that attempt to prove that the basic
#               functionality regarding the representation of an Individual
#               in the library is working.
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
use Individual;
use diagnostics;

use Genotype::BitVector;

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

# Constructor: correct instantiation (void, with both arguments and with just the genotype)
{
	my $individual = Individual->new();
	
	ok( !$individual->scoreSet(), "Constructor: void instantiation" );
}

{
	my $individual = Individual->new(
	    score    => 40,
	    genotype => BitVector->new(30)
	);
	
	
	ok( $individual->getScore() == 40, "Constructor: both arguments. Check score" );
	ok( $individual->getGenotype()->getLength() == 30, "Constructor: both arguments. Check genotype length" );
	ok( $individual->scoreSet(), "Constructor: both arguments. Check if score is set" );
}

dies_ok { ( my $individual = Individual->new( score => 34 ) ) } "Constructor: just score. Dies";

{
	my $individual = Individual->new( genotype => BitVector->new(3) );
	
	ok( $individual->getGenotype()->getLength() == 3, "Constructor: just genotype. Check length" );
	ok( !( $individual->scoreSet() ), "Constructor: just genotype: Check if score is set" );
}


# Constructor: instantiation with a null genotype pointer
dies_ok {
    (
        my $individual = Individual->new(
            score    => 23,
            genotype => undef
        )
    );
} "Constructor: instantiation with null genotype and score. Dies";

dies_ok {
    (
        my $individual = Individual->new(
            genotype => undef
        )
    );
} "Constructor: instantiation with null genotype. Dies";

# setScore: Negative, zero and positive score
{
	my $individual = Individual->new( genotype => BitVector->new(34) );
	$individual->setScore(35);
	
	ok( $individual->getScore() == 35, "setScore: positive score" );
}

{
	my $individual = Individual->new( genotype => BitVector->new(34) );
	dies_ok { ( $individual->setScore(-1) ) } "setScore: negative score. Dies";
	
	$individual->setScore(0);
	ok( $individual->getScore() == 0, "setScore: zero score" );
}

# getGenotype: create an individual and check if the returned genotype contains the same info as the one passed in the constructor.
{
	my $genotype = BitVector->new(3);
	$genotype->setGen( 0, 0 );
	$genotype->setGen( 1, 0 );
	$genotype->setGen( 2, 0 );
	
	my $individual = Individual->new(
	    score    => 32,
	    genotype => $genotype
	);
	
	my $genotypeTemp = $individual->getGenotype();
	
	ok( $genotype->getGen(0) == $genotypeTemp->getGen(0), "getGenotype: check if bit 0 is ok");
	ok( $genotype->getGen(1) == $genotypeTemp->getGen(1), "getGenotype: check if bit 1 is ok");
	ok( $genotype->getGen(2) == $genotypeTemp->getGen(2), "getGenotype: check if bit 2 is ok");
}

# setGenotype: try to set it with an null genotype as argument and a proper set too.
{
	my $individual = Individual->new();
	dies_ok{ ( $individual->setGenotype(undef) ) } "setGenotype: try to set it with an null genotype as argument.";
}

{
	my $individual = Individual->new(
	    genotype => BitVector->new(3)
	);
	
	my $genotype = BitVector->new(3);
	$genotype->setGen(0,0);
	$genotype->setGen(1,0);
	$genotype->setGen(2,0);
	
	$individual->setGenotype($genotype);
	
	ok($individual->getGenotype()->getGen(0) == 0, "setGenotype: check if  bit 0 is ok");
	ok($individual->getGenotype()->getGen(1) == 0, "setGenotype: check if  bit 1 is ok");
	ok($individual->getGenotype()->getGen(2) == 0, "setGenotype: check if  bit 2 is ok");
}
done_testing;