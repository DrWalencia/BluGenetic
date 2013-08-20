#
#===============================================================================
#
#         FILE: GABitVector.pm
#
#  DESCRIPTION: Represents a GeneticAlgorithm implementation that works with
#               genotypes of the class BitVector, implementing the methods
#               that are custom for such data type.
#
#       AUTHOR: Pablo Valencia González (PVG), valeng.pablo@gmail.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/24/2013 07:48:17 PM
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
#   PARAMETERS: popSize     -> size of the population (fixed)
#               crossProb   -> crossover chance (0..1)
#               mutProb     -> mutation chance (0..1)
#               myFitness   -> (function pointer) fitness function
#               myTerminate -> (function pointer) terminate function
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
        popSize                 => $args{popSize},
        crossProb               => $args{crossProb},
        mutProb                 => $args{mutProb},
        myFitness               => $args{myFitness},
        customCrossStrategies   => {},
        customSelStrategies     => {},
        # no function defined: terminate: undef
        myTerminate             => $args{myTerminate}, 
        initialized             => 0,
    };

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
#      RETURNS: Nothing
#  DESCRIPTION: Fills the populations with individuals whose genotype is
#               randomly generated.
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

    return;
}    ## --- end sub initialize

#===  CLASS METHOD  ============================================================
#        CLASS: GABitVector
#       METHOD: evolve
#
#   PARAMETERS: selectionStr	-> Selection strategy to apply to the pop.
#               crossoverStr	-> Crossover strategy to apply to the pop.
#               numGenerations -> maximum number of generations.
#               DEFAULT VALUE IF NO PARAMETER IS PASSED: 1
#
#      RETURNS: NOTHING
#  DESCRIPTION: Makes the population evolve until the terminate() function
#               returns 1 or the limit of generations is reached.
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
#       METHOD: insert
#
#   PARAMETERS: n       -> number of individuals to insert in the population.
#               args	-> reference to array of references that stores as many
#                          as n custom arrays that store custom genotypes for
#                          the inserted individuals. OPTIONAL: if no genotypes
#                          are present then the individuals are going to be
#                          randomly generated.
#
#      RETURNS: Nothing
#
#  DESCRIPTION: Inserts an individual in the population, increasing popSize in
#               as many individuals as specified by n.
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
                my $customGenotype = BitVector->new( $genotype->getLength() );

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
                $individualTemp->setGenotype(
                    BitVector->new( $genotype->getLength() ) );
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

            $individualTemp->setGenotype(
                BitVector->new( $genotype->getLength() ) );
            $individualTemp->setScore( $this->_fitnessFunc($individualTemp) );
            push @newMembers, $individualTemp;
        }
    }

    # DEPENDING ON THE DATA TYPE THESE ARE THE OPERATIONS TO PERFORM WITH
    # THE ARRAY OF REFS CALLED ARGS:
    #
    #       BITVECTOR   -> IGNORE IT (RANGES ALREADY KNOWN)
    #       RANGEVECTOR -> PRODUCE A RANDOM FLOAT VALUE BETWEEN RANGES
    #       LISTVECTOR  -> CHOOSE RANDOMLY ONE OF THE VALUES GIVEN BY RANGES
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
#        CLASS: GABitVector
#       METHOD: delete
#
#   PARAMETERS: index -> the position of the individual to be deleted.
#
#      RETURNS: Nothing
#
#  DESCRIPTION: Deletes the individual given by index, making the population
#               one individual smaller.
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

__END__

=head1 DESCRIPTION

Represents a GeneticAlgorithm implementation that works with
genotypes of the class BitVector, implementing the methods
that are custom for such data type.

=head1 METHODS

    #===  FUNCTION  ================================================================
    #         NAME: new
    #      PURPOSE: Creates a newly allocated GABitVector genetic algorithm.
    #
    #   PARAMETERS: popSize     -> size of the population (fixed)
    #               crossProb   -> crossover chance (0..1)
    #               mutProb     -> mutation chance (0..1)
    #               myFitness   -> (function pointer) fitness function
    #               myTerminate -> (function pointer) terminate function
    #
    #      RETURNS: A reference to the instance just created.
    #       THROWS: no exceptions
    #===============================================================================

    # ===  CLASS METHOD  ===========================================================
    #        CLASS: GABitVector
    #       METHOD: initialize
    #
    #   PARAMETERS: genotypeLength -> length of the genotype to be generated
    #
    #      RETURNS: Nothing
    #  DESCRIPTION: Fills the populations with individuals whose genotype is
    #               randomly generated.
    #       THROWS: no exceptions
    #     COMMENTS: none
    #     SEE ALSO: n/a
    #===============================================================================

    #===  CLASS METHOD  ============================================================
    #        CLASS: GABitVector
    #       METHOD: evolve
    #
    #   PARAMETERS: selectionStr    -> Selection strategy to apply to the pop.
    #               crossoverStr    -> Crossover strategy to apply to the pop.
    #               numGenerations  -> maximum number of generations.
    #               DEFAULT VALUE IF NO PARAMETER IS PASSED: 1
    #
    #      RETURNS: NOTHING
    #  DESCRIPTION: Makes the population evolve until the terminate() function
    #               returns 1 or the limit of generations is reached.
    #       THROWS: no exceptions
    #     COMMENTS: none
    #     SEE ALSO: n/a
    #===============================================================================

    #=== CLASS METHOD  =============================================================
    #        CLASS: GABitVector
    #       METHOD: insert
    #
    #   PARAMETERS: n       -> number of individuals to insert in the population.
    #               args    -> reference to array of references that stores as many
    #                          as n custom arrays that store custom genotypes for
    #                          the inserted individuals. OPTIONAL: if no genotypes
    #                          are present then the individuals are going to be
    #                          randomly generated.
    #
    #      RETURNS: Nothing
    #
    #  DESCRIPTION: Inserts an individual in the population, increasing popSize in
    #               as many individuals as specified by n.
    #
    #       THROWS: no exceptions
    #     COMMENTS: none
    #     SEE ALSO: n/a
    #===============================================================================

    #=== CLASS METHOD  ============================================================
    #        CLASS: GABitVector
    #       METHOD: delete
    #
    #   PARAMETERS: index -> the position of the individual to be deleted.
    #
    #      RETURNS: Nothing
    #
    #  DESCRIPTION: Deletes the individual given by index, making the population
    #               one individual smaller.
    #
    #       THROWS: no exceptions
    #     COMMENTS: none
    #     SEE ALSO: n/a
    #===============================================================================

=head1 AUTHOR

Pablo Valencia Gonzalez, C<< <valeng.pablo at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<valeng.pablo at gmail.com>.

=head1 ACKNOWLEDGEMENTS

Special thanks to Julian Orfo and Hector Diez. The former because its 
collaboration on an early version written in other language and the latter
for stimulating discussion and provide good suggestions.

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Pablo Valencia Gonzalez.

This module is distributed under the same terms as Perl itself.

=cut

1;
