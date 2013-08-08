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

	dies_ok{$algorithm->insertIndividual(3)} "initialize: check that insertIndividual dies if algorithm not initialized.";
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

# insertIndividual: check that if the amount of individuals to be inserted
# is zero or negative, it dies.

# insertIndividual: check after successful insertion that the population
# have grown as much as n.

# deleteIndividual: check that if the index given is less than zero or more
# than the population size, it dies.

# deleteIndividual: check after successful deletion that de population had
# become 1 individual smaller.


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
#{
#	 my $genotype = BitVector->new(3);
#	
#	 $genotype->setGen( 0, 0 );
#	 $genotype->setGen( 1, 1 );
#	 $genotype->setGen( 2, 1 );
#	
#	 my $individual = Individual->new( genotype => $genotype );
#	
#	 my $algorithm = GABitVector->new(
#	 popSize => 12,
#	 crossover => 0.3,
#	 mutation => 0.4,
#	 fitness => \&fitness,
#	 );
#	
#	 $algorithm->initialize(3);
#	 $algorithm->insertIndividual($individual,0);
#
#	# Population inside the algorithm is just a reference, so to play with it
#	# it must be dereferenced first.
#	
#	my $populationRef = $algorithm->getPopulation();
#	my @population = @$populationRef;
#	
#	my $individual2 = $population[0];
#	
#	ok ( $individual2->getScore() == 2, "_fitnessFunc: Generate population, insert individual in which we already know the fitness value and check if this function returns the expected value." );
#}

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

# sortIndividuals: try to sort an undef list. Dies painfully
{
	 my $algorithm = GABitVector->new(
		 popSize => 12,
		 crossover => 0.3,
		 mutation => 0.4,
		 fitness => \&fitness,
	 );
	
	my @array = undef;
	dies_ok{$algorithm->sortIndividuals(@array)} "try to sort an undef list. Dies painfully";
}

# sortIndividuals: try to sort a list with one element which is not an Individual. Dies painfully
{
	my $algorithm = GABitVector->new(
		 popSize => 12,
		 crossover => 0.3,
		 mutation => 0.4,
		 fitness => \&fitness,
	);
	 
	my @array;
	 
	push @array, Individual->new( genotype => BitVector->new(3));
	push @array, "Whatever";
	
	dies_ok{$algorithm->sortIndividuals(@array)} "try to sort a list with one element which is not an Individual. Dies painfully";
}

# sortIndividuals: sort a proper list of individuals. Check that it works correctly.
{
	my $algorithm = GABitVector->new(
		 popSize => 12,
		 crossover => 0.3,
		 mutation => 0.4,
		 fitness => \&fitness,
	);
	 
	my @array;
	 
	push @array, Individual->new(
		score	 => 9, 
		genotype => BitVector->new(3)
	);
	
	push @array, Individual->new(
		score	 => 3, 
		genotype => BitVector->new(3)
	);

	@array = $algorithm->sortIndividuals(@array);
	
	ok( $array[0]->getScore() == 3, "First element of sortIndividuals sorted");
	ok( $array[1]->getScore() == 9, "Second element of sortIndividuals sorted");

}

# getType: generate AG and call getType. Check if it returns the
# expected value.
{
	 my $algorithm = GABitVector->new(
	    popSize => 12,
	    crossover => 0.3,
	    mutation => 0.4,
	    fitness => \&fitness,
	 );

     ok( $algorithm->getType() eq "bitvector", "generate AG and call getType. Check if it returns the expected value");
}

# createCrossoverStrategy: pass anything but a function pointer as the second
# parameter. Dies painfully.
{
	my $algorithm = GABitVector->new(
	    popSize => 12,
	    crossover => 0.3,
	    mutation => 0.4,
	    fitness => \&fitness,
	);
	
	dies_ok{$algorithm->createCrossoverStrategy("Incredible", undef)} "createCrossoverStrategy: pass anything but a function pointer as the second parameter. Dies painfully.";
	 
}

# createSelectionStrategy: pass a valid function pointer and check the custom
# selection strategies hash to prove it's there.
{
	my $algorithm = GABitVector->new(
	    popSize => 12,
	    crossover => 0.3,
	    mutation => 0.4,
	    fitness => \&fitness,
	);

	sub selection {
	
		# Get the arguments...
		my @population = @_;
		
		my @returnPopulation;
		
		# Push random elements till returnPopulation has the same size as
		# population
		while ( @returnPopulation < @population ){
			push @returnPopulation, $population[int(rand(@population))];
		}
	
		return @returnPopulation;
		
	} ## --- end sub selection
	
	$algorithm->createSelectionStrategy("simple", \&selection);
	
	ok ( defined $algorithm->{customSelStrategies}->{simple}, "createSelectionStrategy: pass a valid function pointer and check the custom selection strategies hash to prove it's there" );
}

# createSelectionStrategy: pass anything but a function pointer as the second
# parameter. Dies painfully.
{
	my $algorithm = GABitVector->new(
	    popSize => 12,
	    crossover => 0.3,
	    mutation => 0.4,
	    fitness => \&fitness,
	);
	
	dies_ok{$algorithm->createSelectionStrategy("Incredible", undef)} "createSelectionStrategy: pass anything but a function pointer as the second parameter. Dies painfully.";
	 
}

# createCrossoverStrategy: pass a valid function pointer and check the custom
# crossover strategies hash to prove it's there.
{
	my $algorithm = GABitVector->new(
	    popSize => 12,
	    crossover => 0.3,
	    mutation => 0.4,
	    fitness => \&fitness,
	);

	sub cross {
	
		# Retrieve parameters..
		my ( $individualOne, $individualTwo ) = @_;
	

		my @v;
		push @v, $individualOne;
		push @v, $individualTwo;

		return @v;
	}     ## --- end sub cross
	
	$algorithm->createCrossoverStrategy("Incredible", \&cross);
	
	ok ( defined $algorithm->{customCrossStrategies}->{incredible}, "createCrossoverStrategy: pass a valid function pointer and check the custom crossover strategies hash to prove it's there" );
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
	 
 	my $fittest = $algorithm->getFittest();

	# Population inside the algorithm is just a reference, so to play with it
	# it must be dereferenced first.

	my $refPopulation = $algorithm->getPopulation();
	my @population = @$refPopulation;
	
	my $byHandFittest = $population[$algorithm->{popSize} -1];
	ok ( $byHandFittest->getScore() == $fittest->getScore(), "getFittest: No parameter, pass zero as a parameter, pass more than the total population." );
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
	
	sub sel {
	
		# Get the arguments...
		my @population = @_;
		
		my @returnPopulation;
		
		# Push random elements till returnPopulation has the same size as
		# population
		while ( @returnPopulation < @population ){
			push @returnPopulation, $population[int(rand(@population))];
		}
	
		return @returnPopulation;
		
	} ## --- end sub selection
	
	$algorithm->createSelectionStrategy("simple", \&sel);
	
	$algorithm->initialize(20);
	
	$algorithm->evolve(
		selection =>"simple",
		crossover =>"onepoint",
        generations => 10
	);
	
	my $ind = $algorithm->getFittest();
	
	print "Score of fittest:", $ind->getScore(), "\n";
}


# _terminateFunc: implicit check of currentGeneration

sub myTerminate() {

    my $GA = shift;

    print ($GA->getCurrentGeneration());
    print "\n";

    my $fittest = $GA->getFittest();


    if ( $fittest->getScore() > 14 ){
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
   
   	sub customCross {
	
		# Retrieve parameters..
		my ( $individualOne, $individualTwo ) = @_;
	

		my @v;
		push @v, $individualOne;
		push @v, $individualTwo;

		return @v;
	}     ## --- end sub cross
	
	$algorithm->createCrossoverStrategy("Incredible", \&customCross);

   $algorithm->evolve(
       selection    => "tournament",
       crossover    => "onepoint",
       generations  => 10,
   );

	my $ind = $algorithm->getFittest();
	
	print "Score of fittest:", $ind->getScore(), "\n";

}

done_testing;
