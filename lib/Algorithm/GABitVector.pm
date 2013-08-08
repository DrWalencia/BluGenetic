#
#===============================================================================
#
#         FILE: GABitVector.pm
#
#  DESCRIPTION: Represents a GeneticAlgorithm implementation that works with
#  				genotypes of the class BitVector, implementing the methods
#  				that are custom for such data type.
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/24/2013 07:48:17 PM
#     REVISION: ---
#===============================================================================

package GABitVector;

use strict;
use warnings;
use diagnostics;
use Individual;
use Genotype::BitVector;
use Log::Log4perl qw(get_logger);

# Avoid warnings regarding class method overriding
no warnings 'redefine';

# GABitVector inherits from Algorithm::GeneticAlgorithm
use Algorithm::GeneticAlgorithm;
use base qw(GeneticAlgorithm);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("GABitVector");

#===  FUNCTION  ================================================================
#         NAME: new
#      PURPOSE: Creates a newly allocated GABitVector genetic algorithm.
#
#   PARAMETERS: popSize 	-> size of the population (fixed)
#
#
#      RETURNS: A reference to the instance just created.
#       THROWS: no exceptions
#===============================================================================
sub new {

    $log->info("Creation of new GABitVector started.");

    # Every method of a class passes first argument as class name
    my $class = shift;

    my %args = @_; # After the class name is removed, take the hash of arguments

    # Reference to anonymous hash to store instance variables (AKA FIELDS)
    my $this = {
        popSize    				=> $args{popSize},
        crossover  				=> $args{crossover},
        mutation    			=> $args{mutation},
        fitness     			=> $args{fitness},
        customCrossStrategies	=> {},
        customSelStrategies		=> {},
        terminate   			=> $args{terminate}, # no function defined: terminate: undef
        initialized 			=> 0,
    };


  'customCrossStrategies',	# HASH that stores custom mutation strategies
  'customSelStrategies',	

    # Connect a class name with a hash is known as blessing an object
    bless $this, $class;

    $log->info("Creation of a new GABitVector ended.");

    return $this;
}    ## --- end sub new

# ===  CLASS METHOD  ===========================================================
#        CLASS: GABitVector
#       METHOD: initialize
#
#   PARAMETERS: genotypeLength -> length of the genotype to be generated
#
#      RETURNS: 1 if the initialization was performed correctly. 0
#				otherwise.
#  DESCRIPTION: Fills the populations with individuals whose genotype is
#				randomly generated.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub initialize {

    # Retrieve fields as reference to a hash and the parameter
    my ( $this, $genotypeLength ) = @_;

    # Dereference hash leaving it ready to be used
    my %fields = %$this;

    $log->logconfess("Argument genotypeLength missing")
      if ( !( defined $genotypeLength ) );

    $log->logconfess("Wrong genotypeLength value: $genotypeLength")
      if ( $genotypeLength <= 0 );

    $log->info(
        "Initializing population of $fields{popSize} individuals of
        type BitVector with length $genotypeLength"
    );

    # Initialize the current generation
    $this->{currentGeneration} = 0;

    # Declare counter and population to be filled
    my $i;
    my @pop;

    # And fill the population with individuals of type BitVector
    # randomly generated (such action takes part in the new() method)
    for ( $i = 0 ; $i < $fields{popSize} ; $i++ ) {
        my $individualTemp = Individual->new();
        $individualTemp->setGenotype( BitVector->new($genotypeLength) );
        $individualTemp->setScore( $this->_fitnessFunc($individualTemp) );
        push @pop, $individualTemp;
    }

    # Set the population just created inside the hash of fields
    # REFERENCE TO THE ARRAY, IF JUST PASS @POP THEN POPULATION WILL HAVE THE
    # AMOUNT OF ELEMENTS IN THE POPULATION.
    $this->{population} = \@pop;

    # And set the genotype length inside the hash of fields
    $this->{genotypeLength} = $genotypeLength;

    $log->info(
        "Population of $fields{popSize} individuals of type BitVector
        with length $genotypeLength initialized"
    );

    # Mark the GA as initialized, so that many other methods can be used
    $this->{initialized} = 1;

    return 1;
}    ## --- end sub initialize

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

    $log->info("EVOLVE METHOD CALLED. PREPARE FOR TROUBLE");

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
    my ( $this, %args ) = @_;

    my $numberOfKeys = scalar keys %args;

    if ( $numberOfKeys <= 2 ) {

        $log->logconfess("Cannot evolve without a selection strategy")
          if ( !( defined $args{selection} ) );

        $log->logconfess("Cannot evolve without a crossover strategy")
          if ( !( defined $args{crossover} ) );

    }

    # Instantiate the proper selection/crossover strategies...
    my $selectionStr = $this->_getProperSelectionStr( $args{selection} );
    my $crossoverStr = $this->_getProperCrossoverStr( $args{crossover} );

    my $numGenerations;

    # If numGenerations is undef, default it to 1
    if ( !( defined $args{generations} ) ) {
        $numGenerations = 1;
    }
    else {
        $numGenerations = $args{generations};
    }

    # CHECK IF INITIALIZE HAS BEEN CALLED FIRST
    $log->logconfess("The algorithm has not been initialized")
      if ( $this->{initialized} == 0 );

    # if numGenerations is zero or negative, die painfully
    $log->logconfess("Wrong number of generations: $numGenerations")
      if ( $numGenerations <= 0 );

    # Initialize the current generation
    $this->{currentGeneration} = 0;

    # Unless interrupted by terminateFunc, run $numGenerations times
    for ( my $i = 0 ; $i < $numGenerations ; $i++ ) {

        # Generation i complete...
        $this->{currentGeneration}++;

        # Dereference the population to use it
        my $popRef     = $this->{population};
        my @population = @$popRef;

        # Apply SELECTION STRATEGY...
        @population = $selectionStr->performSelection(@population);

        # Apply CROSSOVER STRATEGY...
        @population = $this->_performCrossover( $crossoverStr, @population );

        # Apply MUTATION...
        @population = $this->_performMutation(@population);

        # Always insert in the population a REFERENCE
        $this->{population} = \@population;

        # If the terminate criterion is met, iteration finishes.
        if ( $this->_terminateFunc() ) {
            return;
        }
    }

    $log->info("EVOLVE METHOD FINISHED. ARE THERE ANY SURVIVORS?");

    return;
}    ## --- end sub evolve

#=== CLASS METHOD  =============================================================
#        CLASS: GABitVector
#       METHOD: insertIndividual
#
#   PARAMETERS: individual -> the individual to be inserted.
#				index 		-> the position where the individual will be placed.

#      RETURNS: 1 if the insertion was performed correctly. 0 otherwise.

#  DESCRIPTION: Inserts an individual in the population on the position given
#				by index. Calculates its fitness value previously.

#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub insertIndividual {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
    my $this = shift;

    # Get the arguments...
    my ( $individual, $index ) = @_;

    # CHECK IF INITIALIZE HAS BEEN CALLED FIRST
    $log->logconfess("The algorithm has not been initialized")
      if ( $this->{initialized} == 0 );

    # Check if the individual is defined
    $log->logconfess("Undefined individual") if ( !( defined $individual ) );
    $log->logconfess("Undefined index")      if ( !( defined $index ) );

    my $genotypeLength  = $individual->getGenotype()->getLength();
    my $aGenotypeLength = $this->{genotypeLength};

    # Check if the length of the individual is compatible with lengthGenotype
    $log->logconfess(
"Incompatible genotype lengths: ind: $genotypeLength, AG: $aGenotypeLength "
    ) if ( $genotypeLength != $aGenotypeLength );

    # Couple of cases in which the program dies horribly
    $log->logconfess("Index bigger than population size ($index)")
      if ( $index > $this->{popSize} );

    $log->logconfess("Index smaller than zero ($index)") if ( $index < 0 );

    # Make a copy of the Algorithm's population
    # THIS RETURNS A REFERENCE TO THE POPULATION, NOT THE POPULATION ITSELF
    my $pop        = $this->{population};
    my @population = @$pop;

    # Calculate the individual's score before inserting it
    $individual->setScore( $this->_fitnessFunc($individual) );

    # Put the individual on the position specified, destroying what was there
    $population[$index] = $individual;

    $this->{population} = \@population;

    $log->info(
        "Individual with genotype ($individual->getGenotype()) inserted
        on position $index"
    );

    return 1;
}    ## --- end sub insertIndividual

#=== CLASS METHOD  ============================================================
#        CLASS: GABitVector
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

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
    my $this = shift;

    # Get the argument
    my ($index) = @_;

    # CHECK IF INITIALIZE HAS BEEN CALLED FIRST
    $log->logconfess("The algorithm has not been initialized")
      if ( $this->{initialized} == 0 );

    # Couple of cases in which the program dies horribly
    $log->logconfess("Index bigger than population size ($index)")
      if ( $index > $this->{popSize} - 1 );

    $log->logconfess("Index smaller than zero ($index)") if ( $index < 0 );

    my $genotypeTemp = BitVector->new( $this->{genotypeLength} );
    my $individualTemp = Individual->new( genotype => $genotypeTemp );

    $individualTemp->setScore( $this->_fitnessFunc($individualTemp) );

    # Make a copy of the Algorithm's population
    # THIS RETURNS A REFERENCE TO THE POPULATION, NOT THE POPULATION ITSELF
    my $pop        = $this->{population};
    my @population = @$pop;

    $population[$index] = $individualTemp;

    $this->{population} = \@population;

    return 1;

}    ## --- end sub deleteIndividual

1;
