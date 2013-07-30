#
#===============================================================================
#
#         FILE: GeneticAlgoritm.pm
#
#  DESCRIPTION: Abstract class that represents the common interface shared by
#  				the different genotype types to be used. Some of the methods
#  				implementation are going to be the same for all of them, that's
#  				why it's an Abstract class.
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/24/2013 07:47:51 PM
#     REVISION: ---
#===============================================================================
package GeneticAlgorithm;
use strict;
use warnings;
use Log::Log4perl qw(get_logger);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("GeneticAlgorithm");

# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields 'population',    # LIST of individuals comprising the population.
  'lengthGenotype',         # INT the length of the Genotype.
  'mutation',               # FLOAT chance of mutation 0..1
  'crossover',              # FLOAT chance of crossover 0..1
  'popSize',                # INT size of the population
  'currentGeneration',      # INT indicates the current generation
  'fitness',                # REFERENCE to the fitness function passed as
                            # a parameter
  'terminate';              # REFERENCE to the terminate function passed as
                            # a parameter

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: _quickSort
#
#   PARAMETERS: i -> index of the last element of the population to be sorted
#   			by fitness function value. Usually population_size() - 1
#
#   			JULIAN PASSED ALWAYS ZERO AS THE FIRST PARAMETER (OMG!!)
#   			I IN THIS CASE IS THE SECOND PARAMETER
#
#      RETURNS: NOTHING.
#  DESCRIPTION: The first function to sort the population by the score. Side by
#  				side with _place() implement the quicksort algorithm.
#       THROWS: no exceptions
#     COMMENTS: PRIVATE METHOD
#     SEE ALSO: n/a
#===============================================================================
sub _quickSort {

	# Retrieve fields as reference to a hash and the parameters
	my ( $this, $i ) = @_;
	my $pivot;
	if ( 0 < $i ) {
		$pivot = _place($i);
		_quickSort( 0,          $pivot - 1 );
		_quickSort( $pivot + 1, $i );
	}
	return;
}    ## --- end sub _quickSort

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: _place
#
#   PARAMETERS: j -> index of the last element of the population to be sorted
#   			by fitness function value. Usually the i from _quickSort()
#
#      RETURNS: The pivot
#  DESCRIPTION: The second part of the quicksort algorithm.
#       THROWS: no exceptions
#     COMMENTS: PRIVATE METHOD
#     SEE ALSO: n/a
#===============================================================================
sub _place {

	# Retrieve fields as reference to a hash and the parameters
	my ( $this, $j ) = @_;
	my $i;
	my $pivot;
	my $pivot_value;
	my $individualTemp;
	$pivot       = 0;
	$pivot_value = $this->{population}->getScore();
	for ( $i = 0 ; $i <= $j ; $i++ ) {

		if ( $this->{population}->getScore() < $pivot_value ) {
			$pivot++;
			$individualTemp             = $this->{population}[$i];
			$this->{population}[$i]     = $this->{population}[$pivot];
			$this->{population}[$pivot] = $individualTemp;
		}
	}
	$individualTemp             = $this->{population}[0];
	$this->{population}[0]      = $this->{population}[$pivot];
	$this->{population}[$pivot] = $individualTemp;
	return $pivot;
}    ## --- end sub _place

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: evolve
#
#   PARAMETERS: selectionStr	-> Selection strategy to apply to the pop.
#				crossoverStr	-> Crossover strategy to apply to the pop.
#				numGenerations -> maximum number of generations.
#           	DEFAULT VALUE IF NO PARAMETER IS PASSED: 1
#
#      RETURNS: NOTHING
#  DESCRIPTION: Makes the population evolve until the terminate() function
# 				returns 1 or the limit of generations is reached.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub evolve {

	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
	my ( $this, $selectionStr, $crossoverStr, $numGenerations ) = @_;

	# Die painfully if any of the strategies are undef
	$log->confess("Selection strategy undefined.")
	  if ( !( defined $selectionStr ) );
	$log->confess("Crossover strategy undefined.")
	  if ( !( defined $selectionStr ) );

	# If $numGenerations is undef, default it to 1
	if ( !( defined $numGenerations ) ) {
		$numGenerations = 1;
	}

	# Initialize the current generation
	$this->{currentGeneration} = 0;
	my @recombinationSet;
	my @noRecombinationSet;
	my @crossoverOffspring;
	my $position1;
	my $position2;
	my $score;
	my $i;

	# Unless interrupted by terminateFunc, run $numGenerations times
	for ( $i = 0 ; $i < $numGenerations ; $i++ ) {

		# Generation i complete...
		$this->{currentGeneration}++;

		# Apply SELECTION STRATEGY...
		$this->{population} =
		  $selectionStr->performSelection( $this->{population} );

		# Fill the recombination and no recombination sets
		# It's VITAL to empty them on each iteration
		undef @recombinationSet;
		undef @noRecombinationSet;
		my $j;

		# If a random number below crossover*100 is produced, then
		# the individual given by j goes to the recombination set.
		# Otherwise, it goes to the no recombination set.
		for ( $j = 0 ; $j < $this->{popSize} ; $j++ ) {
			if ( int( rand(101) ) <= ( $this->{crossover} * 100 ) ) {
				push @recombinationSet, $this->{population}[$j];
			}
			else {
				push @noRecombinationSet, $this->{population}[$j];
			}
		}

		# If the recombination set has an odd number of individuals
		# take one from the no recombination set randomly and insert
		# it in the recombination set.
		# But before, make sure that there's something to do...
		if ( ( scalar @recombinationSet ) != 0 ) {

			# Solve the "cardinality issue"
			if ( ( ( scalar @recombinationSet ) % 2 ) != 0 ) {
				my $randomPos = int( rand( scalar @noRecombinationSet ) );
				push @recombinationSet, $noRecombinationSet[$randomPos];
				unshift @noRecombinationSet, $noRecombinationSet[$randomPos];
			}

			# And let the individuals mate...
			do {
				# Get a couple of random elements from the recombination set
				do {
					$position1 = int( rand( scalar @recombinationSet ) );
					$position2 = int( rand( scalar @recombinationSet ) );
				} while ( $position1 == $position2 );

				# Mate them and make sure TWO elements are returned
				@crossoverOffspring =
				  $crossoverStr->crossIndividuals(
												$recombinationSet[$position1],
												$recombinationSet[$position2] );
				my $nIndCrossover = ( scalar @crossoverOffspring );
				$log->confess(
					"Wrong number of individuals as a product of a
				crossover operation: $nIndCrossover" );

				# Calculate the score for the NEW child one
				my $individualTemp1 = $crossoverOffspring[0];
				$score = $this->{fitness}($individualTemp1);
				$individualTemp1->setScore($score);

				# Calculate the score for the NEW child two
				my $individualTemp2 = $crossoverOffspring[1];
				$score = $this->{fitness}($individualTemp2);
				$individualTemp1->setScore($score);

				# And put them in the no recombination set
				push @noRecombinationSet, $individualTemp1;
				push @noRecombinationSet, $individualTemp2;

				# Erase the elements who just mated from the recombination set
				unshift @recombinationSet, $recombinationSet[$position1];
				unshift @recombinationSet, $recombinationSet[$position2];
			} while ( ( scalar @recombinationSet ) != 0 );
		}

		# MUTATION stage
		for ( $j = 0 ; $j < ( scalar @noRecombinationSet ) ; $j++ ) {

			# If a random number below mutation*100 is produced
			# then perform a mutation on the individual whose
			# index corresponds to j, otherwise do nothing.
			if ( int( rand(101) ) <= ( $this->{mutation} * 100 ) ) {

				# Apply mutation on the individual and calculate new score
				my $position     = int( rand( $this->{lengthGenotype} ) );
				my $genotypeTemp = $noRecombinationSet[$j]->getGenotype();
				$genotypeTemp->changeGen($position);
				$noRecombinationSet[$j]->setGenotype($genotypeTemp);
				$score = $this->{fitness}( $noRecombinationSet[$j] );
				$noRecombinationSet[$j]->setScore($score);
			}
		}

		# Erase population and assign the result of the evolutive process
		undef $this->{population};
		$this->{population} = @noRecombinationSet;

		# If the terminate criterion is met, iteration finishes.
		if ( $this->{terminate}() ) {
			return;
		}
	}
	return;
}    ## --- end sub evolve

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: getFittest
#
#   PARAMETERS: N -> the number of fittest individuals wanted to be retrieved.
#   			DEFAULT VALUE IF NO PARAMETER IS PASSED: 1
#
#      RETURNS: A list containing as much as N individuals
#  DESCRIPTION: Returns the N fittest individuals of the population
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getFittest {

	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
	my ( $this, $nIndWanted ) = @_;

	# Before taking any decisions, sort the population
	$this->sortPopulation();

	# Individual(s) to be returned at the end
	my @fittest;

	# If no parameters are found, just push the fittest
	# Otherwise, select as many elements as needed and push them
	if ( !( defined $nIndWanted ) ) {
		push @fittest, $this->{population}[0];
	}
	else {
		# A couple of situations in which the program dies painfully
		$log->confess(
				 "Incorrect number of individuals to be retrieved: $nIndWanted")
		  if $nIndWanted < 0;
		$log->confess(
			"Too many fittest individuals (more than the total 
		  population)($nIndWanted,$this->{popSize}"
		) if $nIndWanted > $this->{popSize};
		my $i;

		# Take as many fittest individuals as needed
		for ( $i = 0 ; $i < $nIndWanted ; $i++ ) {
			push @fittest, $this->{population}[$i];
		}
	}
	my $individualsReturned = scalar @fittest;
	$log->info("Returned the $individualsReturned best individuals.");
	return @fittest;
}    ## --- end sub getFittest

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: getPopulation
#   PARAMETERS: None.
#      RETURNS: A list containing as many individuals as the population have
#  DESCRIPTION: Returns all the individuals in the population
#       THROWS: no exceptions
#     COMMENTS: CAREFUL! IT RETURNS THE POPULATION ITSELF. CHANGES WILL PERSIST
#     SEE ALSO: n/a
#===============================================================================
sub getPopulation {

	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE THE FIELDS HASH
	my $this = shift;
	$log->info("Population REFERENCE returned.");
	return $this->{population};
}    ## --- end sub getPopulation

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: getPopSize
#   PARAMETERS: None.
#      RETURNS: The size of the population
#  DESCRIPTION: Getter for the population size
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getPopSize {

	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE THE FIELDS HASH
	my $this    = shift;
	my $popSize = $this->{popSize};
	$log->info("Population size returned: $popSize");
	return $popSize;
}    ## --- end sub getPopSize

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: getCrossProb
#   PARAMETERS: None.
#      RETURNS: FLOAT the crossover chance
#  DESCRIPTION: Getter for the crossover chance 0..1
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getCrossProb {

	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE THE FIELDS HASH
	my $this        = shift;
	my $crossChance = $this->{crossover};
	$log->info("Crossover chance returned: $crossChance ");
	return $crossChance;
}    ## --- end sub getCrossProb

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: getMutProb
#   PARAMETERS: None.
#      RETURNS: FLOAT the mutation chance
#  DESCRIPTION: Getter for the mutation chance 0..1
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getMutProb {

	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE THE FIELDS HASH
	my $this      = shift;
	my $mutChance = $this->{mutation};
	$log->info("Mutation chance returned: $mutChance");
	return $mutChance;
}    ## --- end sub getMutProb

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: getCurrentGeneration
#   PARAMETERS: None.
#      RETURNS: The current generation
#  DESCRIPTION: Getter for the current generation of the Genetic Algorithm
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getCurrentGeneration {

	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE THE FIELDS HASH
	my $this              = shift;
	my $currentGeneration = $this->{currentGeneration};
	$log->info("Current generation returned: $currentGeneration");
	return $currentGeneration;
}    ## --- end sub getCurrentGeneration

#=== CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: sortPopulation
#   PARAMETERS: None.
#      RETURNS: Nothing.
#  DESCRIPTION: Sorts the population of the current Genetic Algorithm
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub sortPopulation {

	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE THE FIELDS HASH
	my $this       = shift;
	
	my @population = $this->{population};
	
	$log->info(
		"Population is going to be sorted. Current situation displayed
	below: " );
	foreach my $individual (@population) {
		my $score    = $individual->getScore();
		my @genotype = $individual->getGenotype();
		$log->info( "(@genotype)", "Score: $score" );
	}

	# Indexes go from zero till popSize - 1
	_quickSort( $this->{popSize} - 1 );
	
	$log->info("Population sorted. Situation after sorting: " );
	foreach my $individual (@population) {
		my $score    = $individual->getScore();
		my @genotype = $individual->getGenotype();
		$log->info( "(@genotype)", "Score: $score" );
	}
	
	return;
}    ## --- end sub sortPopulation

#=== CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: initialize
#   PARAMETERS: None.
#      RETURNS: 1 if the initialization was performed correctly. 0
#				otherwise.
#  DESCRIPTION: Fills the populations with individuals whose genotype is
#				randomly generated.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub initialize {
	$log->confess('The function initialize() must be defined in a subclass.\n');
	return;
}    ## --- end sub initialize

#=== CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: insertIndividual
#
#   PARAMETERS: individual -> the individual to be inserted.
#				index 		-> the position where the individual will be placed.
#      RETURNS: 1 if the insertion was performed correctly. 0 otherwise.
#  DESCRIPTION: Inserts an individual in the population on the position given
#				by index.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub insertIndividual {
	$log->confess(
			'The function insertIndividual() must be defined in a subclass.\n');
	return;
}    ## --- end sub insertIndividual

#=== CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: deleteIndividual
#
#   PARAMETERS: index -> the position of the individual to be deleted.
#
#      RETURNS: 1 if the deletion was performed correctly. 0 otherwise.
#
#  DESCRIPTION: Deletes the individual given by index and inserts another
#				individual randomly generated in the same position.
#
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub deleteIndividual {
	$log->confess(
			'The function deleteIndividual() must be defined in a subclass.\n');
	return;
}    ## --- end sub deleteIndividual

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: fitnessFunc
#
#   PARAMETERS: individual -> the individual whose fitness score is wanted
#   			to be calculated.
#
#      RETURNS: FLOAT the fitness value of the individual.
#  DESCRIPTION: Calculates the fitness value associated with the individual
#  				passed as a parameter.
#       THROWS: no exceptions
#     COMMENTS: PROVIDE A DEFAULT IMPLEMENTATION FOR FITNESS FUNCTION IN
#     			CASE IT'S NOT PROVIDED AS AN ARGUMENT BY THE USER.
#     SEE ALSO: n/a
#===============================================================================
sub fitnessFunc {

	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE THE FIELDS HASH
	my ( $this, $individual ) = @_;
	my $score;

	# If there's a fitness function, use it, otherwise die painfully
	if ( defined $this->{fitness} ) {
		$score = $this->{fitness}($individual);
	}
	else {
		$log->confess(
				 'The function fitnessFunc() must be passed as a parameter.\n');
	}
	
	$log->info("Fitness function called. Score: $score");
	
	return $score;
}    ## --- end sub fitnessFunc

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: terminateFunc
#   PARAMETERS: None.
#      RETURNS: 1 if the custom condition defined here is satisfied, 0
#      			otherwise.
#  DESCRIPTION: Allows for a custom termination routine to be defined.
#       THROWS: no exceptions
#     COMMENTS:	DEFAULT IMPLEMENTATION ALWAYS MAKE THE ALGORITHM EVOLVE
#     			TILL THE MAXIMUM NUMBER OF GENERATIONS.
#     SEE ALSO: n/a
#===============================================================================
sub terminateFunc {
	
	$log->info("Terminate function called.");

	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE THE FIELDS HASH
	my $this = shift;
	my $result;

	# If there's a terminate function, use it and get its result
	if ( defined $this->{terminate} ) {
		$result = $this->{terminate}();
		$log->info("Terminate function defined. Result: $result");
	}
	else {
		$result = 0;
		$log->info("Terminate function undefined. Result: $result");
	}
	return $result;
}    ## --- end sub terminateFunc
1;
