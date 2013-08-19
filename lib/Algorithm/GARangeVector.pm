#
#===============================================================================
#
#         FILE: GARangeVector.pm
#
#  DESCRIPTION: Represents a GeneticAlgorithm implementation that works with
#  				genotypes of the class RangeVector, implementing the methods
#  				that are custom for such data type.
#
#       AUTHOR: Pablo Valencia González (PVG), valeng.pablo@gmail.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/24/2013 07:48:17 PM
#===============================================================================

package GARangeVector;

use strict;
use warnings;
use diagnostics;

use Individual;
use Genotype::RangeVector;
use Log::Log4perl qw(get_logger);

# Avoid warnings regarding class method overriding
no warnings 'redefine';

# GARangeVector inherits from Algorithm::GeneticAlgorithm
use Algorithm::GeneticAlgorithm;
use base qw(GeneticAlgorithm);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("GARangeVector");

#===  FUNCTION  ================================================================
#         NAME: new
#      PURPOSE: Creates a newly allocated GARangeVector genetic algorithm.
#
#   PARAMETERS: popSize 	-> size of the population (fixed)
#				crossProb	-> crossover chance (0..1)
#				mutProb	    -> mutation chance (0..1)
#				myFitness	-> (function pointer) fitness function
#				myTerminate	-> (function pointer) terminate function
#
#
#      RETURNS: A reference to the instance just created.
#       THROWS: no exceptions
#===============================================================================
sub new {

    $log->info("Creation of new GARangeVector started.");

    # Every method of a class passes first argument as class name
    my $class = shift;

    my %args = @_; # After the class name is removed, take the hash of arguments

    # Reference to anonymous hash to store instance variables (AKA FIELDS)
    my $this = {
        popSize               => $args{popSize},
        crossProb             => $args{crossProb},
        mutProb               => $args{mutProb},
        myFitness             => $args{myFitness},
        customCrossStrategies => {},
        customSelStrategies   => {},

        # no function defined: terminate: undef
        myTerminate   => $args{myTerminate},
        initialized => 0,
    };

    # Connect a class name with a hash is known as blessing an object
    bless $this, $class;

    $log->info("Creation of a new GARangeVector ended.");

    return $this;

}    ## --- end sub new

# ===  CLASS METHOD  ===========================================================
#        CLASS: GARangeVector
#       METHOD: initialize
#
#   PARAMETERS: valuesPerIndividual -> list of as many lists as  individuals in
#				the population containing  a set of possible values.
#
#      RETURNS: Nothing
#  DESCRIPTION: Fills the populations with individuals whose genotype is
#				randomly generated.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub initialize {

    # Retrieve fields as reference to a hash and the parameter
    my $this                = shift;
    my @valuesPerIndividual = @_;

    $log->logconfess("Argument valuesPerIndividual missing")
      if ( !(@valuesPerIndividual) );

    # check that valuesPerIndividual is an array of refereces to
    # arrays
    foreach my $valueRef (@valuesPerIndividual) {
        $log->logconfess("Not an ARRAY reference in valuesPerIndividual array")
          if ( !( ref($valueRef) eq "ARRAY" ) );

        my @values = @$valueRef;

        $log->logconfess( "Wrong number of element in list: (",
            @values, "). Only two permitted" )
          if ( @values > 2 );

        $log->logconfess( "Wrongly placed arguments in ranges: [",
            $values[0], ",", $values[1], "]. Must be [Min,Max]" )
          if ( $values[0] > $values[1] );
    }

    $log->info(
        "Initializing population of $this->{popSize} individuals of
        type RangeVector"
    );

    # Initialize the current generation
    $this->{currentGeneration} = 0;

    # Declare counter and population to be filled
    my $i;
    my @pop;

    # And fill the population with individuals of type RangeVector
    # randomly generated (such action takes part in the new() method)
    for ( $i = 0 ; $i < $this->{popSize} ; $i++ ) {
        my $individualTemp = Individual->new();
        $individualTemp->setGenotype( RangeVector->new(@valuesPerIndividual) );
        $individualTemp->setScore( $this->_fitnessFunc($individualTemp) );
        push @pop, $individualTemp;
    }

    #    foreach my $a (@pop){
    #    	my $genotype = $a->getGenotype();
    #    	my @gen = $genotype->{genotype};
    #
    #    	foreach my $gen (@gen){
    #    		foreach my $g (@$gen){
    #    			print $g;
    #    			print " ";
    #    		}
    #    	}
    #
    #		print "\n";
    #    }

    # Set the population just created inside the hash of fields
    # REFERENCE TO THE ARRAY, IF JUST PASS @POP THEN POPULATION WILL HAVE THE
    # AMOUNT OF ELEMENTS IN THE POPULATION.
    $this->{population} = \@pop;

    # And set the genotype length inside the hash of fields
    $this->{genotypeLength} = @pop;

    $log->info(
        "Population of $this->{popSize} individuals of type RangeVector
         initialized"
    );

    # Mark the GA as initialized, so that many other methods can be used
    $this->{initialized} = 1;

    return 1;
}    ## --- end sub initialize

#===  CLASS METHOD  ============================================================
#        CLASS: GARangeVector
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
#        CLASS: GARangeVector
#       METHOD: insert
#
#   PARAMETERS: n		-> number of individuals to insert in the population.
#				args	-> array of refs to array that specifies the values of
#						   the genes of the individuals to be inserted. This
#						   argument is OPTIONAL, if the user doesn't provide
#						   it, genes will be filled randomly (with values from
#						   the ranges obviously).
#
#      RETURNS: Nothing
#
#  DESCRIPTION: Inserts an individual in the population, increasing popSize in
#				as many individuals as specified by n.
#
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub insert {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
    my $this = shift;

    # Get the arguments...
    my $n = shift;

    # CHECK IF INITIALIZE HAS BEEN CALLED FIRST
    $log->logconfess("The algorithm has not been initialized")
      if ( $this->{initialized} == 0 );

    # If anything strange is inserted in n, die painfully
    $log->logconfess(" Wrong number of individuals to insert: $n")
      if ( $n <= 0 );

    # Take the array of custom genotypes...
    my @args = @_;

    # If the number of custom genotypes passed as parameters is bigger than
    # n, then die painfully
    $log->logconfess("Too many custom genotypes. Just $n are allowed")
      if ( @args > $n );

    # Array to store generated elements into
    my @newMembers;

    # Get genotype of one of its members...
    my $popRef   = $this->getPopulation();
    my @pop      = @$popRef;
    my $genotype = $pop[0]->getGenotype();
    my $ranges   = $genotype->getRanges();

    # If the optional array of values is defined, use it
    if (@args) {

        foreach my $valueRef (@args) {
            $log->logconfess("Not an ARRAY reference in args array")
              if !( ref($valueRef) eq "ARRAY" );
        }

        # Check that each one of the sub arrays is composed by as many elements
        # as genotypeLength of the rest of individuals.
        my $genotypeLength = $genotype->getLength();

        foreach my $valueRef (@args) {
            my @value = @$valueRef;

            log->logconfess(
                "Wrong number of genes inserted in genotype: ",
                scalar @value,
                " != ", $genotypeLength
            ) if ( @value != $genotypeLength );
        }

        # Use those arrays to create custom individuals and insert them
        # into the population.
        for ( my $i = 0 ; $i < $n ; $i++ ) {
            my $valuesRef = $args[$i];

            # If custom genotype is defined, use it
            if ( defined $valuesRef ) {

                my @customValues = @$valuesRef;

                my $individualTemp = Individual->new();
                my $customGenotype = RangeVector->new(@$ranges);

                for ( my $j = 0 ; $j < @customValues ; $j++ ) {
                    $customGenotype->setGen( $j, $customValues[$j] );
                }

                $individualTemp->setGenotype($customGenotype);
                $individualTemp->setScore(
                    $this->_fitnessFunc($individualTemp) );

                push @newMembers, $individualTemp;

            }
            else {    # If not generate random individuals

                my $individualTemp = Individual->new();
                $individualTemp->setGenotype( RangeVector->new(@$ranges) );
                $individualTemp->setScore(
                    $this->_fitnessFunc($individualTemp) );
                push @newMembers, $individualTemp;
            }
        }

    }
    else {

        # Generate as many as n random individuals and insert them into
        # the population.
        for ( my $i = 0 ; $i < $n ; $i++ ) {
            my $individualTemp = Individual->new();
            $individualTemp->setGenotype( RangeVector->new(@$ranges) );
            $individualTemp->setScore( $this->_fitnessFunc($individualTemp) );
            push @newMembers, $individualTemp;
        }
    }

    # DEPENDING ON THE DATA TYPE THESE ARE THE OPERATIONS TO PERFORM WITH
    # THE ARRAY OF REFS CALLED ARGS:
    #
    #       BITVECTOR   -> IGNORE IT (RANGES ALREADY KNOWN)
    #       RANGEVECTOR -> PRODUCE A RANDOM FLOAT VALUE BETWEEN RANGES
    #       RangeVector  -> CHOOSE RANDOMLY ONE OF THE VALUES GIVEN BY RANGES
    #
    # FOR THE TWO LAST ONES WE COULD GET AS MANY REFERENCES TO ARRAYS AS
    # INDIVIDUALS TO  BE INSERTED. IF LESS ELEMENTS ARE PASSED THEN CHOOSE
    # RANGES RANDOMLY FROM THE ONES PREVIOUSLY DEFINED BY THE GENOTYPE WHERE
    # INDIVIDUALS ARE TO BE INSERTED

    # Population update...
    @pop = ( @pop, @newMembers );
    $this->{population} = \@pop;

    # Popsize update...
    $this->{popSize} = @pop;

    return;

}    ## --- end sub insert

#=== CLASS METHOD  ============================================================
#        CLASS: GARangeVector
#       METHOD: delete
#
#   PARAMETERS: index -> the position of the individual to be deleted.
#
#      RETURNS: Nothing
#
#  DESCRIPTION: Deletes the individual given by index, making the population
#				one individual smaller.
#
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub delete {

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

    # Update population...

    # Make a copy of the population
    my $popRef = $this->getPopulation();
    my @pop    = @$popRef;

    # Eliminate the damned individual
    if ( $index == 0 ) {
        shift @pop;
    }
    elsif ( $index == $this->{popSize} ) {
        pop @pop;
    }
    else {
        splice( @pop, $index, 1 );
    }

    # And reassign population
    $this->{population} = \@pop;

    # Update popsize
    $this->{popSize} = @pop;

    return;
}    ## --- end sub delete

1;
