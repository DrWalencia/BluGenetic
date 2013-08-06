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
use Test::More;
use Log::Log4perl qw(get_logger);
use Individual;
use Algorithm::GABitVector;
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

# Initialize: check that genotypeLength is a positive number bigger than 0.
# Die otherwise.
{
	my $algorithm = GABitVector->new(
		popSize => 4,
		crossover => 0.3,
		mutation => 0.4,
		fitness => \&fitness,
	);
	
	dies_ok { $algorithm->initialize() } "Initialize: check that genotypeLength is a positive number (undefined). Dies";
	dies_ok { $algorithm->initialize(0) } "Initialize: check that genotypeLength is a positive number (zero). Dies";
}

# initialize: check that evolve dies if algorithm not initialized.
{
	my $algorithm = GABitVector->new(
		popSize => 4,
		crossover => 0.3,
		mutation => 0.4,
		fitness => \&fitness,
	);

	dies_ok{$algorithm->evolve()} "initialize: check that evolve dies if algorithm not initialized.";
}

# initialize: check that getFittest dies if algorithm not initialized.
{
	my $algorithm = GABitVector->new(
		popSize => 4,
		crossover => 0.3,
		mutation => 0.4,
		fitness => \&fitness,
 	);

	dies_ok{$algorithm->getFittest()} "initialize: check that getFittest dies if algorithm not initialized.";
}

# initialize: check that getPopulation dies if algorithm not initialized.
{
	my $algorithm = GABitVector->new(
		popSize => 4,
		crossover => 0.3,
		mutation => 0.4,
		fitness => \&fitness,
	);
 
	dies_ok{$algorithm->getPopulation()} "initialize: check that getPopulation dies if algorithm not initialized.";
}

# initialize: check that insertIndividual dies if algorithm not initialized.
{
	my $algorithm = GABitVector->new(
		popSize => 4,
		crossover => 0.3,
		mutation => 0.4,
		fitness => \&fitness,
	);

	dies_ok{$algorithm->insertIndividual(undef, 2)} "initialize: check that insertIndividual dies if algorithm not initialized.";
}

# initialize: check that deleteIndividual dies if algorithm not initialized.
{
	my $algorithm = GABitVector->new(
		popSize => 4,
		crossover => 0.3,
		mutation => 0.4,
		fitness => \&fitness,
	);
	
	dies_ok{$algorithm->deleteIndividual(2)} "initialize: check that deleteIndividual dies if algorithm not initialized.";
}

# Population inside the algorithm is just a reference, so to play with it
# it must be dereferenced first.
{
	my $algorithm = GABitVector->new(
		popSize => 4,
		crossover => 0.3,
		mutation => 0.4,
		fitness => \&fitness,
	);
	
	$algorithm->initialize(20);

	my $populationRef = $algorithm->getPopulation();
	my @population = @$populationRef;
	my $individual = $population[0];
	
	my $genotype = $individual->getGenotype();
	
	ok( $genotype->getLength() == 20, "Check that individuals in the population have the correct length" );
}

# insertIndividual: check that the individual to be inserted is not undef.
# Die otherwise.
{
	my $algorithm = GABitVector->new(
		popSize => 4,
		crossover => 0.3,
		mutation => 0.4,
		fitness => \&fitness,
	);
	
	$algorithm->initialize(20);

	dies_ok { $algorithm->insertIndividual( undef, 4 ) } "insertIndividual: check that the individual to be inserted is not undef. Dies otherwise";
}

# insertIndividual: check that index is between zero and genotypeLength -1
# Die otherwise
# WARNING: INDIVIDUAL RECEIVES ARGUMENTS INSIDE OF A HASH
{
	my $algorithm = GABitVector->new(
		popSize => 4,
		crossover => 0.3,
		mutation => 0.4,
		fitness => \&fitness,
	);

	my $individual = Individual->new( 
		genotype => BitVector->new(20), 
	);
	
	dies_ok { $algorithm->insertIndividual( $individual, -1 ) } "insertIndividual: check that index is between zero and genotypeLength -1 (-1 inserted). Dies otherwise";
	dies_ok { $algorithm->insertIndividual( $individual, 20 ) } "insertIndividual: check that index is between zero and genotypeLength -1 (20 inserted). Dies otherwise";
}

# insertIndividual: insert an individual and check that it has actually
# been inserted. getPopulation() test implicit here.
{
	my $genotype = BitVector->new(3);
	
	$genotype->setGen( 0, 0 );
	$genotype->setGen( 1, 0 );
	$genotype->setGen( 2, 0 );
	
	my $individual = Individual->new( 
		genotype => $genotype 
	);
	
	my $algorithm = GABitVector->new(
		popSize => 6,
		crossover => 0.3,
		mutation => 0.4,
		fitness => \&fitness,
	);

	$algorithm->initialize(3);
	$algorithm->insertIndividual( $individual, 0 );

	# Population inside the algorithm is just a reference, so to play with it
	# it must be dereferenced first.

	 my $populationRef = $algorithm->getPopulation();
	 my @population = @$populationRef;

	 my $individual2 = $population[0];
	 my $genotypeIndividual = $individual2->getGenotype();

	 my $gen0 = $genotypeIndividual->getGen(0);
	 my $gen2 = $genotypeIndividual->getGen(1);
	 my $gen1 = $genotypeIndividual->getGen(2);

	 ok( $gen0 == $individual->getGenotype()->getGen(0), "insertIndividual: gen 0 has 0" );
	 ok( $gen1 == $individual->getGenotype()->getGen(1), "insertIndividual: gen 1 has 0" );
	 ok( $gen2 == $individual->getGenotype()->getGen(2), "insertIndividual: gen 2 has 0" );
}

# insertIndividual: check if the length of the individual to be inserted is the
# same as lengthGenotype of the algorithm. Die otherwise.
{
	my $algorithm = GABitVector->new(
		popSize => 4,
		crossover => 0.3,
		mutation => 0.4,
		fitness => \&fitness,
	);
 
 	my $individual = Individual->new( genotype => BitVector->new(4) );

	 $algorithm->initialize(5);
	 dies_ok { $algorithm->insertIndividual( $individual, 0 ) } "insertIndividual: check if the length of the individual to be inserted is the same as lengthGenotype of the algorithm. Die otherwise.";
}
# deleteIndividual: check that the index is between zero and genotypeLength-1
# Die otherwise
{
	my $algorithm = GABitVector->new(
		popSize => 4,
		crossover => 0.3,
		mutation => 0.4,
		fitness => \&fitness,
	);
	
	$algorithm->initialize(5);
	
	dies_ok { $algorithm->deleteIndividual(-1) } "deleteIndividual: check that the index is between zero and genotypeLength-1. Die otherwise";
	dies_ok { $algorithm->deleteIndividual(7) } "deleteIndividual: check that the index is between zero and genotypeLength-1. Die otherwise";

}

# deleteIndividual: delete a given individual and check that it has
# actually been substituted by a randomly generated one.
# TEST DISABLED: IT WILL OBVIOUSLY GIVE FALSE FAILED TESTS
# FROM TIME TO TIME BECAUSE IT'S CHECKING AGAINST A TROIKA
# OF BINARY RANDOM VALUES.
#{
#	my $algorithm = GABitVector->new(
#		popSize => 4,
#		crossover => 0.3,
#		mutation => 0.4,
#		fitness => \&fitness,
#	);
#	
#	$algorithm->initialize(5);
#	
#	$algorithm->deleteIndividual(0);
#
#	# Population inside the algorithm is just a reference, so to play with it
#	# it must be dereferenced first.
#	my $populationRef = $algorithm->getPopulation();
#	my @population = @$populationRef;
#
#	my $individual = $population[0];
#	
#	my $individual2 = Individual->new( genotype => BitVector->new(4) );
#
#	my $genotypeIndividual = $individual->getGenotype();
#	my $gen0 = $genotypeIndividual->getGen(0);
#	my $gen1 = $genotypeIndividual->getGen(1);
#	my $gen2 = $genotypeIndividual->getGen(2);
#
#	my $result1 = ($gen0 == $individual2->getGenotype()->getGen(0));
#	my $result2 = ($gen1 == $individual2->getGenotype()->getGen(1));
#	my $result3 = ($gen2 == $individual2->getGenotype()->getGen(2));
#
#ok ( ($result1 == $result2) == $result3 );
#
#}

# getPopSize: generate population, retrieve its size and check
# if it's the same as what's stored in popSize
{
	 my $algorithm = GABitVector->new(
		 popSize => 54,
		 crossover => 0.3,
		 mutation => 0.4,
		 fitness => \&fitness,
	 );
	 
	 ok( $algorithm->getPopSize() == 54, "getPopSize: generate population, retrieve its size and check if it's the same as what's stored in popSize");
}

# getCrossChance: generate AG, and check if crossChance is the same as the
# one passed as a parameter.
{
	 my $algorithm = GABitVector->new(
		 popSize => 54,
		 crossover => 0.3,
		 mutation => 0.4,
		 fitness => \&fitness,
	 );
	 
	 ok( $algorithm->getCrossChance() == 0.3, "getCrossChance: generate AG, and check if crossChance is the same as the one passed as a parameter." );
}

# getMutChance: generate AG, and check if mutChance is the same as the
# one passed as a parameter.
{
	 my $algorithm6 = GABitVector->new(
		 popSize => 54,
		 crossover => 0.3,
		 mutation => 0.4,
		 fitness => \&fitness,
	 );
	 
	 ok( $algorithm6->getMutChance() == 0.4, "getMutChance: generate AG, and check if mutChance is the same as the one passed as a parameter." );
}

# _fitnessFunc: (BREAKING ENCAPSULATION) Generate population, insert
# individual in which we already know the fitness value and check if
# this function returns the expected value.
{
	 my $genotype = BitVector->new(3);
	
	 $genotype->setGen( 0, 0 );
	 $genotype->setGen( 1, 1 );
	 $genotype->setGen( 2, 1 );
	
	 my $individual = Individual->new( genotype => $genotype );
	
	 my $algorithm = GABitVector->new(
	 popSize => 12,
	 crossover => 0.3,
	 mutation => 0.4,
	 fitness => \&fitness,
	 );
	
	 $algorithm->initialize(3);
	 $algorithm->insertIndividual($individual,0);

	# Population inside the algorithm is just a reference, so to play with it
	# it must be dereferenced first.
	
	my $populationRef = $algorithm->getPopulation();
	my @population = @$populationRef;
	
	my $individual2 = $population[0];
	
	ok ( $individual2->getScore() == 2, "_fitnessFunc: Generate population, insert individual in which we already know the fitness value and check if this function returns the expected value." );
}
# sortPopulation: generate population and sort it. Check results.
{
	 my $algorithm = GABitVector->new(
	 popSize => 12,
	 crossover => 0.3,
	 mutation => 0.4,
	 fitness => \&fitness,
	 );
	
	 $algorithm->initialize(30);
	 $algorithm->sortPopulation();
	
	 my $population = $algorithm->getPopulation();
	 my $i;
	
	 for ( $i = 0; $i < $algorithm->{popSize} - 1; $i++ ){
		 my $lowFit = @$population[$i];
		 my $hiFit = @$population[$i+1];
		 ok ($lowFit->getScore() <= $hiFit->getScore(), "Element in position $i has lower fitness than the following");
	 }
}

# getFittest: No parameter, pass zero as a parameter, pass more than the
# total population.
{
	my $algorithm = GABitVector->new(
		popSize => 12,
		crossover => 0.3,
		mutation => 0.4,
		fitness => \&fitness,
	);
	
	$algorithm->initialize(30);
	 
 	my @fittest = $algorithm->getFittest();

	# Population inside the algorithm is just a reference, so to play with it
	# it must be dereferenced first.

	my $refPopulation = $algorithm->getPopulation();
	my @population = @$refPopulation;
	
	my $byHandFittest = $population[$algorithm->{popSize} -1];
	ok ( $byHandFittest->getScore() == $fittest[0]->getScore(), "getFittest: No parameter, pass zero as a parameter, pass more than the total population." );
}

# getFittest: Pass a parameter between limits. Very basic, just checking
# cardinality.
{
	my $algorithm = GABitVector->new(
		popSize => 12,
		crossover => 0.3,
		mutation => 0.4,
		fitness => \&fitness,
	);
	
	$algorithm->initialize(30);

	my @fittest = $algorithm->getFittest(4);
	ok ( @fittest == 4, "getFittest: Pass a parameter between limits. Very basic, just checking cardinality.");
}

# getFittest: Pass zero as a parameter. It dies painfully
{
	my $algorithm = GABitVector->new(
		popSize => 12,
		crossover => 0.3,
		mutation => 0.4,
		fitness => \&fitness,
	);
	
	$algorithm->initialize(30);
	
 	dies_ok{ my $fittest = $algorithm->getFittest(0)} "getFittest: Pass zero as a parameter. It dies painfully";
}

# getFittest: pass more than the total population. It dies painfully
{
	my $algorithm = GABitVector->new(
		popSize => 12,
		crossover => 0.3,
		mutation => 0.4,
		fitness => \&fitness,
	);
	
	$algorithm->initialize(30);
	
	dies_ok{ my $fittest = $algorithm->getFittest(13)} "getFittest: pass more than the total population. It dies painfully";
}

# evolve: die painfully if no selection strategy
{
	 my $algorithm = GABitVector->new(
		 popSize => 12,
		 crossover => 0.3,
		 mutation => 0.4,
		 fitness => \&fitness,
	 );

	 $algorithm->initialize(4);

	 dies_ok{ $algorithm->evolve(
	 	crossover => "OnePoint",
	 )} "evolve: die painfully if no selection strategy";
}


# evolve: die painfully if no crossover strategy
{
	 my $algorithm = GABitVector->new(
		 popSize => 12,
		 crossover => 0.3,
		 mutation => 0.4,
		 fitness => \&fitness,
	 );
	
	 $algorithm->initialize(4);
	
	 dies_ok{ $algorithm->evolve(
		 selection => "Tournament",
		 generations => 34,
	 )} "evolve: die painfully if no crossover strategy";
}

# evolve: die painfully if undefined selection strategy
{
	 my $algorithm = GABitVector->new(
		 popSize => 12,
		 crossover => 0.3,
		 mutation => 0.4,
		 fitness => \&fitness,
	 );
	
	 $algorithm->initialize(4);
	
	 dies_ok{ $algorithm->evolve(
		 selection => "foo",
		 crossover => "onepoint",
		 generations => 33,
	 )} "evolve: die painfully if undefined selection strategy";
}

# evolve: die painfully if undefined crossover strategy
{
	 my $algorithm = GABitVector->new(
		 popSize => 12,
		 crossover => 0.3,
		 mutation => 0.4,
		 fitness => \&fitness,
	 );
	
	 $algorithm->initialize(4);
	
	 dies_ok{ $algorithm->evolve(
	 	selection => "Tournament",
	 	crossover => "bar",
	 	generations => 33,
	 )} "evolve: die painfully if undefined crossover strategy";
}

# evolve: die painfully if numGenerations negative or zero
{
	 my $algorithm = GABitVector->new(
		 popSize => 12,
		 crossover => 0.3,
		 mutation => 0.4,
		 fitness => \&fitness,
	 );
	
	 $algorithm->initialize(4);
	
	 dies_ok{ $algorithm->evolve(
		 selection =>"Tournament",
		 crossover =>"ONEPOINT",
		 generations => 0,
	 )} "evolve: die painfully if numGenerations negative or zero";
}

# evolve: die painfully if numgenerations is negative or zero
{
	 my $algorithm = GABitVector->new(
		 popSize => 12,
		 crossover => 0.3,
		 mutation => 0.4,
		 fitness => \&fitness,
	 );
	
	 $algorithm->initialize(4);
	
	 dies_ok{ $algorithm->evolve(
		 selection =>"tournament",
		 crossover =>"onepoint",
		 generations => -10,
	 )} "evolve: die painfully if numgenerations is negative or zero";
}
	
# evolve: example that works.
{
	my $algorithm = GABitVector->new(
		popSize   => 20,
		crossover => 0.8,
		mutation  => 0.05,
		fitness   => \&fitness,
        terminate => \&terminate,
	);
	
	$algorithm->initialize(20);
	
	$algorithm->evolve(
		selection =>"tournament",
		crossover =>"onepoint",
        generations => 10
	);
	
	my @ind = $algorithm->getFittest();
	
	print "Score of fittest:", $ind[0]->getScore(), "\n";
}


# _terminateFunc: implicit check of currentGeneration

sub myTerminate() {

    my $GA = shift;

    print ($GA->getCurrentGeneration());
    print "\n";

    my @fittest = $GA->getFittest();


    if ( $fittest[0]->getScore() > 14 ){
        return 1;
    }else{
        return 0;
    }
}

{
    my $algorithm = GABitVector->new(
        popSize =>  20,
        crossover => 0.9,
        mutation => 0.04,
        fitness =>  \&fitness,
        terminate => \&myTerminate,
   );

   $algorithm->initialize(20);

   $algorithm->evolve(
       selection    => "tournament",
       crossover    => "twopoint",
       generations  => 10,
   );

	my @ind = $algorithm->getFittest();
	
	print "Score of fittest:", $ind[0]->getScore(), "\n";

}

done_testing;
