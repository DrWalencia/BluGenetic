#
#===============================================================================
#
#         FILE: GABitVector.t
#
#  DESCRIPTION: Basic set of tests that attempt to prove that the basic
#               functionality regarding the representation of a Genetic
#				Algorithm with BitVector as its data type.
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

use Test::More tests => 19;    # last test to print
use Log::Log4perl qw(get_logger);
use Individual;
use Algorithm::GABitVector;

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


sub fitness(){
	return 0;
}

sub terminate(){
	return 0;
}


# Constructor: check that popsize is a positive number bigger than 0. Die
# otherwise.

lives_ok {
	my $algorithm = GABitVector->new(
	    popSize   => 4,
        crossover => 0.3,
        mutation  => 0.4,
        fitness   => \&fitness,
        terminate => \&terminate,
)};

dies_ok {
	my $algorithm2 = GABitVector->new(
	    popSize   => 0,
        crossover => 0.3,
        mutation  => 0.4,
        fitness   => \&fitness,
        terminate => \&terminate,
)
};

dies_ok {
	my $algorithm3 = GABitVector->new(
	    popSize   => -43,
        crossover => 0.3,
        mutation  => 0.4,
        fitness   => \&fitness,
        terminate => \&terminate,
)
};

# Constructor: check that crossover is a float number between 0 and 1. Die
# otherwise.

dies_ok {
	my $algorithm4 = GABitVector->new(
	    popSize   => 4,
        crossover => -0.1,
        mutation  => 0.4,
        fitness   => \&fitness,
        terminate => \&terminate,
)
};

dies_ok {
	my $algorithm5 = GABitVector->new(
	    popSize   => 4,
        crossover => 1.1,
        mutation  => 0.4,
        fitness   => \&fitness,
        terminate => \&terminate,
)
};

# Constructor: check that mutation is a float number between 0 and 1. Die
# otherwise.
dies_ok {
	my $algorithm6 = GABitVector->new(
	    popSize   => 4,
        crossover => 0.3,
        mutation  => -0.4,
        fitness   => \&fitness,
        terminate => \&terminate,
)
};

dies_ok {
	my $algorithm7 = GABitVector->new(
	    popSize   => 4,
        crossover => 0.5,
        mutation  => 1.4,
        fitness   => \&fitness,
        terminate => \&terminate,
)
};

# Constructor: check that fitness and terminate are function pointers. Die
# otherwise.
dies_ok {
	my $algorithm8 = GABitVector->new(
	    popSize   => 4,
        crossover => 0.5,
        mutation  => 0.3,
        fitness   => undef,
        terminate => \&terminate,
)
};

lives_ok {
	my $algorithm9 = GABitVector->new(
	    popSize   => 4,
        crossover => 0.5,
        mutation  => 1,
        fitness   => \&fitness,
        terminate => undef,
)
};

# Initialize: check that genotypeLength is a positive number bigger than 0.
# Die otherwise.
my $algorithm = GABitVector->new(
	    popSize   => 4,
        crossover => 0.3,
        mutation  => 0.4,
        fitness   => \&fitness,
        terminate => \&terminate,
);

dies_ok {$algorithm->initialize()};
dies_ok {$algorithm->initialize(0)};

$algorithm->initialize(20);

ok($algorithm->getGenotypeLength() == 20);

# insertIndividual: check that the individual to be inserted is not undef.
# Die otherwise.
dies_ok{$algorithm->insertIndividual(undef, 4)};

# insertIndividual: check that index is between zero and genotypeLength -1
# Die otherwise
# WARNING: INDIVIDUAL RECEIVES ARGUMENTS INSIDE OF A HASH

my $ind = Individual->new(
	genotype => BitVector->new($algorithm->getGenotypeLength())
	);
	
dies_ok{$algorithm->insertIndividual($ind,-1)};
dies_ok{$algorithm->insertIndividual($ind,20)};

# insertIndividual: insert an individual and check that it has actually 
# been inserted.

my $genotype3 = BitVector->new(3);
$genotype3->setGen(0,0);
$genotype3->setGen(1,0);
$genotype3->setGen(2,0);

my $ind2 = Individual->new(
	genotype => $genotype3
	);
	
my $algorithm2 = GABitVector->new(
	    popSize   => 6,
        crossover => 0.3,
        mutation  => 0.4,
        fitness   => \&fitness,
        terminate => \&terminate,
);

$algorithm2->initialize(3);
$algorithm2->insertIndividual($ind2,0);

my $population = $algorithm2->getPopulation();
my $individual = @$population[0];

my $genotypeIndividual = $individual->getGenotype();
my $gen0 = $genotypeIndividual->getGen(0);
my $gen2 = $genotypeIndividual->getGen(1);
my $gen1 = $genotypeIndividual->getGen(2);

ok ($gen0 == $ind2->getGenotype()->getGen(0));
ok ($gen1 == $ind2->getGenotype()->getGen(1));
ok ($gen2 == $ind2->getGenotype()->getGen(2));

# insertIndividual: check if the length of the individual to be inserted is the
# same as lengthGenotype of the algorithm. Die otherwise.

# deleteIndividual: check that the index is between zero and genotypeLength-1
# Die otherwise

# deleteIndividual: delete a given individual and check that it has
# actually been substituted by a randomly generated one.

# getFittest: No parameter, pass zero as a parameter, pass more than the
# total population.
 
# getPopulation: generate population of one individual, substitute it for
# a given one and retrieve the population and check if it's there.

# getPopSize: generate population, get genotype, retrieve its size and check
# if it's the same as what's stored in popSize

# getCrossChance: generate AG, and check if crossChance is the same as the 
# one passed as a parameter.

# getMutChance: generate AG, and check if mutChance is the same as the 
# one passed as a parameter.

# getCurrentGeneration: without hitting evolve, currentGeneration must be
# undef. After hitting evolve() and not putting any terminate function,
# currentGeneration must be equal to the value passed to evolve()

# sortPopulation: generate population and sort it. Check results.

# _fitnessFunc: (BREAKING ENCAPSULATION) Generate population, insert
# individual in which we already know the fitness value and check if
# this function returns the expected value.

# _fitnessFunc: Define algorithm without a fitness func and check if it dies

# _terminateFunc: Check default behavior.

# _terminateFunc: define custom behavior and check if it works as expected.





