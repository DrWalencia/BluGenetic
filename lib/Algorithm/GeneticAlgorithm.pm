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
#       AUTHOR: Pablo Valencia González (PVG), valeng.pablo@gmail.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/24/2013 07:47:51 PM
#===============================================================================

package GeneticAlgorithm;

use strict;
use warnings;
use diagnostics;

use Log::Log4perl qw(get_logger);
use Selection::Random;
use Selection::Roulette;
use Selection::Tournament;
use Selection::UserDefinedS;
use Crossover::OnePoint;
use Crossover::TwoPoint;
use Crossover::Uniform;
use Crossover::UserDefinedC;

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("GeneticAlgorithm");

# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields 'population',      # ARRAY of individuals comprising the population.
  'genotypeLength',           # INT the length of the Genotype.
  'mutation',                 # FLOAT chance of mutation 0..1
  'crossover',                # FLOAT chance of crossover 0..1
  'initialized',              # INT 1 if initialized, 0 otherwise
  'popSize',                  # INT size of the population
  'currentGeneration',        # INT indicates the current generation
  'customCrossStrategies',    # HASH that stores custom mutation strategies
  'customSelStrategies',      # HASH that stores custom selection strategies
  'fitness',                  # REFERENCE to the fitness function passed as
                              # a parameter
  'terminate';                # REFERENCE to the terminate function passed as
                              # a parameter

#=== CLASS METHOD  =============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: _getProperCrossoverStr
#
#   PARAMETERS: crossover -> string containing the crossover strategy type
#                wanted.
#
#      RETURNS: The adequate instance of a Crossover Strategy.
#
#  DESCRIPTION: Factory method that decides which crossover strategy
#               instantiate.
#
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub _getProperCrossoverStr {

    # Get the parameters...
    my $this      = shift;
    my $crossover = shift;

    my $crossoverStr;

    # Lowercase whatever is coming inside crossover...
    $crossover = lc($crossover);

    # Create the proper crossover strategy or die painfully
    if ( $crossover eq "onepoint" ) {
        $crossoverStr = OnePoint->new();
    }
    elsif ( $crossover eq "twopoint" ) {
        $crossoverStr = TwoPoint->new();
    }
    elsif ( $crossover eq "uniform" ) {
        $crossoverStr = Uniform->new();
    }
    else {
        $crossoverStr = _loadCustomCrossoverStr( $this, $crossover );
    }

    return $crossoverStr;
}

#=== CLASS METHOD  =============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: _loadCustomCrossoverStr
#   PARAMETERS: crossoverString -> a string representation of the strategy.
#      RETURNS: The adequate instance of a Crossover Strategy.
#  DESCRIPTION: Factory method that decides which crossover strategy
#               instantiate. This time searching in the custom crossover
#				strategies hash.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub _loadCustomCrossoverStr {

    my $this            = shift;
    my $crossoverString = shift;
    my $crossoverStrategy;

    my $hashref = $this->{customCrossStrategies};
    my %hash    = %$hashref;

    my @keys = keys %hash;

    # If a key containing the string passed as a parameter is found,
    # set the return value of function as the value in the key-value
    # pair that represents the strategy to be selected.
    foreach my $key (@keys) {
        if ( $key eq $crossoverString ) {
            $crossoverStrategy = $hash{$crossoverString};
        }
    }

    $log->logconfess( "Undefined crossover strategy: ", $crossoverString )
      if ( !( defined $crossoverStrategy ) );

    return $crossoverStrategy;
}

#=== CLASS METHOD  =============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: _getProperSelectionStr
#
#   PARAMETERS: selection -> string containing the selection strategy type
#                             wanted.
#
#      RETURNS: The adequate instance of a Selection Strategy.
#
#  DESCRIPTION: Factory method to decide which Selection Strategy
#               instantiate.
#
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub _getProperSelectionStr {

    # Get the parameters...
    my $this      = shift;
    my $selection = shift;

    # Lowercase whatever is coming inside selection...
    $selection = lc($selection);

    my $selectionStr;

    # Create the proper selection strategy or die painfully
    if ( $selection eq "roulette" ) {
        $selectionStr = Roulette->new();
    }
    elsif ( $selection eq "tournament" ) {
        $selectionStr = Tournament->new();
    }
    elsif ( $selection eq "random" ) {
        $selectionStr = Random->new();
    }
    else {
        $selectionStr = _loadCustomSelectionStr( $this, $selection );
    }

    return $selectionStr;

}

#=== CLASS METHOD  =============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: _loadCustomSelectionStr
#   PARAMETERS: selectionString -> a string representation of the strategy.
#      RETURNS: The adequate instance of a Selection Strategy.
#  DESCRIPTION: Factory method that decides which selection strategy
#               instantiate. This time searching in the custom selection
#				strategies hash.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub _loadCustomSelectionStr {

    my $this            = shift;
    my $selectionString = shift;
    my $selectionStrategy;

    my $hashref = $this->{customSelStrategies};
    my %hash    = %$hashref;

    my @keys = keys %hash;

    # If a key containing the string passed as a parameter is found,
    # set the return value of function as the value in the key-value
    # pair that represents the strategy to be selected.
    foreach my $key (@keys) {
        if ( $key eq $selectionString ) {
            $selectionStrategy = $hash{$selectionString};
        }
    }

    $log->logconfess( "Undefined crossover strategy: ", $selectionString )
      if ( !( defined $selectionStrategy ) );

    return $selectionStrategy;
}

#=== CLASS METHOD  =============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: _performMutation
#
#   PARAMETERS: population -> the population in which the method operates.
#
#      RETURNS: an array of individuals that is the result of the mating
#               process.
#
#  DESCRIPTION: Encapsulates the logic regarding the mutation operation in
#               the GA.
#
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub _performMutation {

    # Get the parameters...
    my $this       = shift;
    my @population = @_;

    $log->info("MUTATION STAGE STARTED");

    for ( my $j = 0 ; $j < @population ; $j++ ) {

        # If a random number below mutation*100 is produced
        # then perform a mutation on the individual whose
        # index corresponds to j, otherwise do nothing.

        if ( int( rand(101) ) < ( $this->{mutation} * 100 ) ) {

            # Apply mutation on the individual and calculate new score
            my $position =
              int( rand( $population[0]->getGenotype()->getLength() ) );

            $log->info("Position to mute: $position \n");

            my $genotypeTemp = $population[$j]->getGenotype();

            my $c = $genotypeTemp->{genotype};
            $log->info( "Genotype before change: (",
                @$c, ") Score: ", $population[$j]->getScore(), "\n" );

            $genotypeTemp->changeGen($position);
            $population[$j]->setGenotype($genotypeTemp);
            my $score = $this->_fitnessFunc( $population[$j] );
            $population[$j]->setScore($score);

            my $genotypeTemp2 = $population[$j]->getGenotype();
            my $e             = $genotypeTemp2->{genotype};
            $log->info( "Genotype after change: (",
                @$e, ") Score: ", $population[$j]->getScore(), "\n" );

        }
    }

    $log->info("MUTATION STAGE FINISHED");

    return @population;
}

#=== CLASS METHOD  =============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: _performCrossover
#
#   PARAMETERS: crossoverStr    -> the crossover strategy to apply to the pop.
#               population      -> the population in which the method operates.
#
#      RETURNS: an array of individuals that is the result of the mating
#               process.
#
#  DESCRIPTION: Encapsulates the logic regarding the crossover operation in
#               the GA.
#
#       THROWS: no exceptions
#     COMMENTS: it doesn't operate on the population stored at $this because
#               the latter hasn't suffered the selection process.
#     SEE ALSO: n/a
#===============================================================================
sub _performCrossover {

    $log->info("SELECTION STAGE STARTED");

    # Get the arguments...
    my $this         = shift;
    my $crossoverStr = shift;
    my @population   = @_;

    my @recombinationSet;
    my @noRecombinationSet;

    # If a random number below crossover*100 is produced, then
    # the individual given by j goes to the recombination set.
    # Otherwise, it goes to the no recombination set.
    for ( my $j = 0 ; $j < $this->{popSize} ; $j++ ) {
        if ( int( rand(101) ) <= ( $this->{crossover} * 100 ) ) {
            push @recombinationSet, $population[$j];
        }
        else {
            push @noRecombinationSet, $population[$j];
        }
    }

    # If the recombination set has an odd number of individuals
    # take one from the no recombination set randomly and insert
    # it in the recombination set.
    # But before, make sure that there's something to do...
    if ( (@recombinationSet) != 0 ) {

        # Solve the "cardinality issue"
        if ( ( ( scalar @recombinationSet ) % 2 ) != 0 ) {
            my $randomPos = int( rand( scalar @noRecombinationSet ) );
            push @recombinationSet, $noRecombinationSet[$randomPos];
            splice( @noRecombinationSet, $randomPos, 1 );
        }

        # And let the individuals mate...
        do {

            my $position1;
            my $position2;

            $log->info("INDIVIDUALS START TO MATE");

            # Get a couple of random elements from the recombination set
            do {
                $position1 = int( rand(@recombinationSet) );
                $position2 = int( rand(@recombinationSet) );

            } while ( $position1 == $position2 );

            $log->info("Elements to be mated: $position1, $position2");
            $log->info( "Size of recombinationSet: ",
                scalar @recombinationSet );

            # Mate them and make sure TWO elements are returned
            my @crossoverOffspring =
              $crossoverStr->crossIndividuals( $recombinationSet[$position1],
                $recombinationSet[$position2] );

            my $nIndCrossover = ( scalar @crossoverOffspring );
            $log->logconfess(
                "Wrong number of individuals as a product of a
                crossover operation: $nIndCrossover"
            ) if ( @crossoverOffspring != 2 );

            # Calculate the score for the NEW child one
            my $individualTemp1 = $crossoverOffspring[0];
            my $score           = $this->_fitnessFunc($individualTemp1);
            $individualTemp1->setScore($score);

            # Calculate the score for the NEW child two
            my $individualTemp2 = $crossoverOffspring[1];
            $score = $this->_fitnessFunc($individualTemp2);
            $individualTemp2->setScore($score);

            # And put them in the no recombination set
            push @noRecombinationSet, $individualTemp1;
            push @noRecombinationSet, $individualTemp2;

            # Erase the elements who just mated from the recombination set

            if ( $position1 == 0 ) {
                shift @recombinationSet;
            }
            elsif ( $position1 == @recombinationSet ) {
                pop @recombinationSet;
            }
            else {
                splice( @recombinationSet, $position1, 1 );
            }

            if ( $position2 == 0 ) {
                shift @recombinationSet;
            }
            elsif ( $position2 == @recombinationSet ) {
                pop @recombinationSet;
            }
            else {
                splice( @recombinationSet, $position2, 1 );
            }

        } while ( (@recombinationSet) != 0 );

        $log->info("INDIVIDUALS FINISHED MATING");
    }

    $log->info("SELECTION STAGE FINISHED");

    return @noRecombinationSet;
}

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: getType
#   PARAMETERS: None
#      RETURNS: A string representation of the data type the GA is operating
#               with.
#  DESCRIPTION: Returns the data type the GA is operating with.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getType {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
    my ($this) = shift;

    my $returnValue;

    if ( $this->isa("GABitVector") ) {
        $returnValue = "bitvector";
        $log->info("Data type to operate with returned: bitvector");
    }
    elsif ( $this->isa("GAListVector") ) {
        $returnValue = "listvector";
        $log->info("Data type to operate with returned: listvector");
    }
    elsif ( $this->isa("GARangeVector") ) {
        $returnValue = "rangevector";
        $log->info("Data type to operate with returned: rangevector");
    }
    else {
        $log->logconfess("FATAL: unknown data type for the current GA");
    }

    return $returnValue;
}

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: createCrossoverStrategy
#
#   PARAMETERS: strategyName -> name of the strategy to be added
#				strategyRef	 -> a function pointer pointing to the custom
#								strategy implementation.
#
#      RETURNS: Nothing
#  DESCRIPTION: Adds a custom crossover strategy to the algorithm
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub createCrossoverStrategy {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
    my ($this) = shift;

    # Take the arguments...
    my ( $strategyName, $strategyRef ) = @_;

    $log->logconfess("Missing custom strategy name")
      if ( !( defined $strategyName ) );

    $log->logconfess("Missing strategy reference")
      if ( !( defined $strategyRef ) );

    # Allow anything as the name of an strategy...
    # Check that $strategyRef is a function pointer
    $log->logconfess(
        "Not a function pointer in the second argument of function.")
      if ( !( eval { $strategyRef->("CODE") } ) );

    # Create a UserDefined crossover strategy with the value passed as a
    # parameter.
    my $customStrategy = UserDefinedC->new($strategyRef);

    # Add them as a key-value pair in the custom crossover strategies hash
    $this->{customCrossStrategies}->{ lc($strategyName) } = $customStrategy;

    return;
}

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: createSelectionStrategy
#
#   PARAMETERS: strategyName -> name of the strategy to be added
#				strategyRef	 -> a function pointer pointing to the custom
#								strategy implementation.
#
#      RETURNS: Nothing
#  DESCRIPTION: Adds a custom selection strategy to the algorithm
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub createSelectionStrategy {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
    my ($this) = shift;

    # Take the arguments...
    my ( $strategyName, $strategyRef ) = @_;

    $log->logconfess("Missing custom strategy name")
      if ( !( defined $strategyName ) );

    $log->logconfess("Missing strategy reference")
      if ( !( defined $strategyRef ) );

    # Allow anything as the name of an strategy...
    # Check that $strategyRef is a function pointer
    $log->logconfess(
        "Not a function pointer in the second argument of function.")
      if ( !( eval { $strategyRef->("CODE") } ) );

    # Create a UserDefined selection strategy with the value passed as a
    # parameter.
    my $customSelection = UserDefinedS->new($strategyRef);

    # Add them as a key-value pair in the custom selection strategies hash
    $this->{customSelStrategies}->{ lc($strategyName) } = $customSelection;

    return;
}

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: getFittest
#
#   PARAMETERS: N -> the number of fittest individuals wanted to be retrieved.
#   			DEFAULT VALUE IF NO PARAMETER IS PASSED: 1
#
#      RETURNS: A list containing as much as N individuals or just one
#               individual if no parameter is passed.
#  DESCRIPTION: Returns the N fittest individuals of the population
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getFittest {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
    my ( $this, $nIndWanted ) = @_;

    # CHECK IF INITIALIZE HAS BEEN CALLED FIRST
    $log->logconfess("The algorithm has not been initialized")
      if ( $this->{initialized} == 0 );

    # Before taking any decisions, sort the population
    $this->sortPopulation();

    # Individual(s) to be returned at the end
    my @fittest;

    # Dereference population to play with its elements
    my $popRef     = $this->{population};
    my @population = @$popRef;

    # If no parameters are found, just push the fittest
    # Otherwise, select as many elements as needed and push them
    # CAREFUL!! THE POPULATION WILL BE SORTED BY ASCENDING FITNESS VALUE
    if ( !( defined $nIndWanted ) ) {
        push @fittest, $population[ $this->{popSize} - 1 ];
    }
    else {
        # A couple of situations in which the program dies painfully
        $log->logconfess(
            "Incorrect number of individuals to be retrieved: $nIndWanted")
          if $nIndWanted <= 0;
        $log->logconfess(
            "Too many fittest individuals (more than the total 
            population)($nIndWanted,$this->{popSize}"
        ) if $nIndWanted > $this->{popSize};
        my $i;

        # Take as many fittest individuals as needed
        for ( $i = 0 ; $i < $nIndWanted ; $i++ ) {
            push @fittest, $population[ $this->{popSize} - $i - 1 ];
        }
    }
    my $individualsReturned = scalar @fittest;
    $log->info("Returned the $individualsReturned best individuals.");

    if ( @fittest == 1 ) {
        return $fittest[0];
    }
    else {
        return @fittest;
    }

}    ## --- end sub getFittest

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: getPopulation
#   PARAMETERS: None.
#      RETURNS: A reference to the population with which the GA operates.
#  DESCRIPTION: Returns all the individuals in the population
#       THROWS: no exceptions
#     COMMENTS: CAREFUL! IT RETURNS THE POPULATION ITSELF. CHANGES WILL PERSIST
#     SEE ALSO: n/a
#===============================================================================
sub getPopulation {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE THE FIELDS HASH
    my $this = shift;

    # CHECK IF INITIALIZE HAS BEEN CALLED FIRST
    $log->logconfess("The algorithm has not been initialized")
      if ( $this->{initialized} == 0 );

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
#       METHOD: getCrossChance
#   PARAMETERS: None.
#      RETURNS: FLOAT the crossover chance
#  DESCRIPTION: Getter for the crossover chance 0..1
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getCrossChance {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE THE FIELDS HASH
    my $this        = shift;
    my $crossChance = $this->{crossover};
    $log->info("Crossover chance returned: $crossChance ");
    return $crossChance;
}    ## --- end sub getCrossChance

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: getMutChance
#   PARAMETERS: None.
#      RETURNS: FLOAT the mutation chance
#  DESCRIPTION: Getter for the mutation chance 0..1
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getMutChance {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE THE FIELDS HASH
    my $this      = shift;
    my $mutChance = $this->{mutation};
    $log->info("Mutation chance returned: $mutChance");
    return $mutChance;
}    ## --- end sub getMutChance

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
#     COMMENTS: It sorts the population in ascending value of fitness
#     SEE ALSO: n/a
#===============================================================================
sub sortPopulation {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE THE FIELDS HASH
    my $this = shift;

    my $populationRef = $this->{population};

    # Sort population by ASCENDING Individual scores...
    my @population = sort { $a->getScore() <=> $b->getScore() } @$populationRef;

    $this->{population} = \@population;

    return;
}    ## --- end sub sortPopulation

#=== CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: sortIndividuals
#   PARAMETERS: individuals -> array of individuals
#      RETURNS: an array of individuals sorted.
#  DESCRIPTION: Sorts the list of inidividuals passed as a parameter by
#				ASCENDING fitness scores.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub sortIndividuals {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE THE FIELDS HASH
    my $this = shift;

    # Get the arguments...
    my @individuals = @_;

    log->logconfess("Empty array. Nothing to sort") if ( !(@individuals) );

    foreach my $ind (@individuals) {
        $log->logconfess(
            "The array passed as a parameter is not comprised by Individuals")
          if ( !( $ind->isa("Individual") ) );
    }

    # Sort population by ASCENDING Individual scores...
    @individuals = sort { $a->getScore() <=> $b->getScore() } @individuals;

    return @individuals;
}

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
    $log->logconfess(
        'The function initialize() must be defined in a subclass.\n');
    return;
}    ## --- end sub initialize

#=== CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: insert
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
sub insert {
    $log->logconfess('The function insert() must be defined in a subclass.\n');
    return;
}    ## --- end sub insert

#=== CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: delete
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
sub delete {
    $log->logconfess('The function delete() must be defined in a subclass.\n');
    return;
}    ## --- end sub delete

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: _fitnessFunc
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
sub _fitnessFunc {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE THE FIELDS HASH
    my ( $this, $individual ) = @_;
    my $score;

    # If there's a fitness function, use it, otherwise die painfully
    if ( defined $this->{fitness} ) {
        $score = $this->{fitness}($individual);
    }
    else {
        $log->logconfess(
            'The function fitnessFunc() must be passed as a parameter.\n');
    }

    $log->info("Fitness function called. Score: $score");

    return $score;
}    ## --- end sub _fitnessFunc

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: _terminateFunc
#   PARAMETERS: None.
#      RETURNS: 1 if the custom condition defined here is satisfied, 0
#               otherwise.
#  DESCRIPTION: Allows for a custom termination routine to be defined.
#       THROWS: no exceptions
#     COMMENTS: DEFAULT IMPLEMENTATION ALWAYS MAKE THE ALGORITHM EVOLVE
#               TILL THE MAXIMUM NUMBER OF GENERATIONS. THIS IS A PRIVATE
#               METHOD.
#     SEE ALSO: n/a
#===============================================================================
sub _terminateFunc {

    $log->info("Terminate function called.");

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE THE FIELDS HASH
    my $this = shift;
    my $result;

    # If there's a terminate function, use it and get its result
    if ( defined $this->{terminate} ) {
        $result = $this->{terminate}($this);
        $log->info("Terminate function defined. Result: $result");
    }
    else {
        $result = 0;
        $log->info("Terminate function undefined. Result: $result");
    }
    return $result;
}    ## --- end sub _terminateFunc

1;
