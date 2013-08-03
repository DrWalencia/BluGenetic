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
use diagnostics;
use Log::Log4perl qw(get_logger);
use Selection::Random;
use Selection::Roulette;
use Selection::Tournament;
use Crossover::OnePoint;
use Crossover::TwoPoint;
use Crossover::Uniform;

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("GeneticAlgorithm");

# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields 'population',    # ARRAY of individuals comprising the population.
  'genotypeLength',         # INT the length of the Genotype.
  'mutation',               # FLOAT chance of mutation 0..1
  'crossover',              # FLOAT chance of crossover 0..1
  'initialized',			# INT 1 if initialized, 0 otherwise
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
#   PARAMETERS: j -> index of the first element of the population to be sorted
#				i -> index of the last element of the population to be sorted
#   			by fitness function value. Usually population_size() - 1
#
#   			JULIAN PASSED ALWAYS ZERO AS THE FIRST PARAMETER (OMG!!)
#   			I IN THIS CASE IS THE SECOND PARAMETER
#
#      RETURNS: NOTHING.
#  DESCRIPTION: The first function to sort the population by the score. Side by
#  				side with _place() implement the quicksort algorithm.
#       THROWS: no exceptions
#     COMMENTS: PRIVATE METHOD: NO $THIS CONTAINING FIELDS AS A PARAMETER
#     SEE ALSO: n/a
#===============================================================================
sub _quickSort {

    # Retrieve fields as reference to a hash and the parameters
    my ( $j, $i, $this ) = @_;
    
    if ( $j < $i ) {
        my ($pivot, $this) = _place($j, $i, $this);
        $this = _quickSort( $j,          $pivot - 1, $this);
        $this = _quickSort( $pivot + 1, $i, $this);
    }	

    return $this;
}    ## --- end sub _quickSort

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: _place
#
#   PARAMETERS: k -> index of the first element of the population to be sorted
#				j -> index of the last element of the population to be sorted
#   			by fitness function value. Usually the i from _quickSort()
#
#      RETURNS: The pivot
#  DESCRIPTION: The second part of the quicksort algorithm.
#       THROWS: no exceptions
#     COMMENTS: PRIVATE METHOD. NO $THIS CONTAINING FIELDS AS A PARAMETER
#     SEE ALSO: n/a
#===============================================================================
sub _place {

    # Retrieve fields as reference to a hash and the parameters
    my ( $k, $j, $this ) = @_;
    
    # Make a copy of the Algorithm's population
    # THIS RETURNS A REFERENCE TO THE POPULATION, NOT THE POPULATION ITSELF
    my $populationRef = $this->{population};
    my @population = @$populationRef;
    
    my $i;
    my $pivot;
    my $pivot_value;
    my $individualTemp;
    
    $pivot       = $k;
    $pivot_value = $population[$pivot]->getScore();
    for ( $i = $k+1 ; $i <= $j ; $i++ ) {

        if ( $population[$i]->getScore() < $pivot_value ) {
            $pivot++;
            $individualTemp             = $population[$i];
            $population[$i]     = $population[$pivot];
            $population[$pivot] = $individualTemp;
        }
    }
    $individualTemp             = $population[$k];
    $population[$k]      = $population[$pivot];
    $population[$pivot] = $individualTemp;

	# Assign to the field population a REFERENCE to the pop just modified
    $this->{population} = \@population;
    
    return ($pivot, $this);
}    ## --- end sub _place



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
    
    # CHECK IF INITIALIZE HAS BEEN CALLED FIRST
    $log->logconfess("The algorithm has not been initialized") 
    if ($this->{initialized} == 0);

    # Before taking any decisions, sort the population
    $this->sortPopulation();

    # Individual(s) to be returned at the end
    my @fittest;
    
    # Dereference population to play with its elements
    my $popRef = $this->{population};
    my @population = @$popRef;

    # If no parameters are found, just push the fittest
    # Otherwise, select as many elements as needed and push them
    # CAREFUL!! THE POPULATION WILL BE SORTED BY ASCENDING FITNESS VALUE
    if ( !( defined $nIndWanted ) ) {
        push @fittest, $population[$this->{popSize}-1];
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
            push @fittest, $population[$this->{popSize} - $i -1];
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
    
    # CHECK IF INITIALIZE HAS BEEN CALLED FIRST
    $log->logconfess("The algorithm has not been initialized") 
    if ($this->{initialized} == 0);
    
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
sub getCrossChance{

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
sub getMutChance{

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
    
    # Redefine this with the AG coming from the _quickSort method 
    $this =  _quickSort(0, $this->{popSize} - 1, $this );

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
    $log->logconfess('The function initialize() must be defined in a subclass.\n');
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
    $log->logconfess(
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
    $log->logconfess(
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
        $log->logconfess(
            'The function fitnessFunc() must be passed as a parameter.\n');
    }

    $log->info("Fitness function called. Score: $score");

    return $score;
}    ## --- end sub fitnessFunc

1;
