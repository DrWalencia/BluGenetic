#
#===============================================================================
#
#         FILE: BluGenetic.pm
#
#  DESCRIPTION:	STATIC class that works as a Factory, returning one of the
#               types of genetic algorithms according to the arguments passed
#               as parameters to its only public method.
#
#       AUTHOR: Pablo Valencia González (PVG), valeng.pablo@gmail.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/22/2013 09:25:14 PM
#===============================================================================

package BluGenetic;

use 5.006;

use strict;
use warnings FATAL => 'all';
use diagnostics;

#use Log::Log4perl qw(get_logger);
use Log::Log4perl qw(:easy);
use Algorithm::GABitVector;
use Algorithm::GAListVector;
use Algorithm::GARangeVector;

# Get a logger from the singleton
my $log = Log::Log4perl::get_logger("BluGenetic");

# Default constants used throughout the whole module
use constant DEF_CROSS_CHANCE => 0.95;
use constant DEF_MUT_CHANCE   => 0.05;

#===  CLASS METHOD  ============================================================
#        CLASS: BluGenetic
#       METHOD: new
#
#   PARAMETERS: popSize     -> INTEGER size of the population
#   		crossProb   -> FLOAT chance of crossProb (default 0.95)
#   		mutProb     -> FLOAT chance of mutProb (default 0.05)
#   		type	    -> STRING type of data e.g: 'bitvector'
#   		myFitness   -> FUNCTION POINTER custom fitness function (MUST)
#   		myTerminate -> FUNCTION POINTER custom terminate function
#   			               (OPTIONAL)
#
#      RETURNS: A reference to the proper GA.
#  DESCRIPTION:	Returns one of the three types of Genetic Algorithm according
#  				to the arguments passed.
#       THROWS: no exceptions
#     COMMENTS: THIS METHOD IS NOT A CONSTRUCTOR EVEN THOUGH ITS NAME IS NEW
#     SEE ALSO: n/a
#===============================================================================
sub new {

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

    # Initialize logging behavior
    # Log::Log4perl->init( \$conf );

    $log->info("Factory job to create a Genetic Algorithm started.");

    # Take the class name and the arguments passed as a hash
    my ( $class, %args ) = @_;

    # If any of the three mandatory arguments is missing, die painfully
    if ( !( defined $args{popSize} ) ) {
        $log->logconfess("popSize argument undefined.");
    }

    if ( !( defined $args{type} ) ) {
        $log->logconfess("type argument undefined.");
    }

    if ( !( defined $args{myFitness} ) ) {
        $log->logconfess("myFitness function undefined.");
    }

    # For optional values, check if they're defined
    # If not, check their ranges
    if ( !( defined $args{crossProb} ) ) {
        $args{crossProb} = DEF_CROSS_CHANCE;
    }
    elsif ( ( $args{crossProb} < 0 ) or ( $args{crossProb} > 1 ) ) {
        $log->confess( "Wrong value for crossProb: ", $args{crossProb} );
    }

    if ( !( defined $args{mutProb} ) ) {
        $args{mutProb} = DEF_MUT_CHANCE;
    }
    elsif ( ( $args{mutProb} < 0 ) or ( $args{mutProb} > 1 ) ) {
        $log->confess( "Wrong value for mutProb: ", $args{mutProb} );
    }

    # Terminate is managed by GeneticAlgorithm

    # The algorithm that the factory is going to return
    my $algorithm = _getProperAlgorithm(%args);

    $log->info("Factory job to create a Genetic Algoritm finished.");

    return $algorithm;

}    ## --- end sub new

#===  CLASS METHOD  ============================================================
#        CLASS: BluGenetic
#       METHOD: _getProperAlgorithm
#   PARAMETERS: args -> a hash containing the needed arguments.
#      RETURNS: The needed instance of Genetic Algorithm.
#  DESCRIPTION:	Factory method that instantiates the proper GA and returns it.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub _getProperAlgorithm {

    # Retrieve the arguments...
    my %args = @_;

    my $algorithm;

    my $type = lc( $args{type} );
    delete $args{type};

    # Now according to what's inside type, the factory decides...
    if ( $type eq 'bitvector' ) {
        $algorithm = GABitVector->new(%args);
        $log->info("Algorithm of type 'bitvector' generated");
    }
    elsif ( $type eq 'rangevector' ) {
        $algorithm = GARangeVector->new(%args);
        $log->info("Algorithm of type 'rangevector' generated");
    }
    elsif ( $type eq 'listvector' ) {
        $algorithm = GAListVector->new(%args);
        $log->info("Algorithm of type 'listvector' generated");
    }
    else {
        $log->logconfess(
"Unknown data type: $args{type}. Arguments case should all be in lowercase."
        );
    }

    return $algorithm;
}

__END__

=head1 NAME

BluGenetic - Solve problems using genetic algorithms.

=head1 SYNOPSIS

    use BluGenetic;

    sub simpleFitness {

        ($individual) = @_;
        $genotype = $individual->getGenotype();
        $counter = 0;

        for ( $i = 0 ; $i < $genotype->getLength() ; $i++ ) {
            $counter += $genotype->getGen($i);
        }

        return $counter;
    }

    my $algorithm = BluGenetic->new(
        popSize     => 20,
        crossProb   => 0.9,
        mutProb     => 0.06,
        type        => 'BitVector',
        myFitness   => \&simpleFitness,
    );

    $algorithm->initialize(20);

    $algorithm->evolve(
        selection   => "tournament",
        crossover   => "onepoint",
        generations => 10,
    );

    $ind = $algorithm->getFittest();

    print "Score of fittest:", $ind->getScore(), "\n";

=head1 DESCRIPTION

B<BluGenetic> is a module for solving problems using Genetic
Algorithms (GAs) written in pure Perl and focused on simplicity and
clearness of use and development. It's pretty much a drop-in replacement
for B<AI::Genetic>. For those wondering why reinventing the wheel, please
read the section L<MOTIVATIONS>.

In a Genetic Algorithm, a population of individuals fight for survival. 
Each individual is given a set of genes that define its behavior. Individuals 
that perform better (as defined by a fitness function) have a higher 
chance of mating with other individuals. When two individuals mate, 
they swap some of their genes, resulting in an individual that has 
properties from both of its parents. From time to time, a mutation
occurs where some gene randomly changes value, resulting in a different 
individual, perhaps fitter, perhaps less fit. 

After a few generations, the population 
should converge on an acceptable solution to the proposed problem.

So a basic implementation of a GA would be comprised by 
three stages:

=over 3

=item 1.- Selection

The performance of all the individuals comprising the population
is evaluated by using the fitness function. For a given individual,
the higher the fitness value, the bigger the chance to pass its
genes on in future generations in the next stage.

=item 2.- Crossover

Individuals given as a product of the previous stage are randomly
paired to mate (equivalent of sexual reproduction). This is controlled
by the crossover chance (0..1) and may result in new individuals
for the current population, which contain genes from both parents
and substitute them.

=item 3.- Mutation

Controlled by a very small mutation chance, each individual is given
a chance to mutate. If selected to mutate, a given individual will
change one of its genes randomly selected.

=back

=head1 INSTALLATION

In order to install it, the standard process for building and
installing modules can be followed:

  perl Build.PL
  ./Build
  ./Build test
  ./Build install

Or, on a platform like DOS or Windows that doesn't require
the "./" notation, this can be done:  

  perl Build.PL
  Build
  Build test
  Build install

=head1 MOTIVATIONS

The main reason for implementing a module to solve problems
using genetic algorithms was the same as many free software projects
start out: scratching one's own itch.

B<AI::Genetic> was to be used for a course at university, and an 
inconsistency was found between what was explained in the
documentation and the behavior of the module. So, the obvious
was done: check the source code, which was poorly documented 
and such fact made the bug catch much more difficult than
expected.

So, the developer of the current module thought he could come 
up with a better solution for him and his classmates, and 
started a well-documented and thoroughly tested module which
is the current product.

Also, it was a very good chance to experiment with OOP in Perl
while at the same time a more understandable code was produced,
which could help in the search for future bugs.

=head1 METHODS

The current class works as a Factory, returning one of the
types of GA according to the arguments passed as parameters to 
its only public method. Obviously because it's a factory, it works
as a singleton, allowing only one instance of itself, globally
accessible.

    #===  CLASS METHOD  ============================================================
    #        CLASS: BluGenetic
    #       METHOD: new
    #
    #   PARAMETERS: popSize     -> INTEGER size of the population
    #               crossProb   -> FLOAT chance of crossProb (default 0.95)
    #               mutProb     -> FLOAT chance of mutProb (default 0.05)
    #               type        -> STRING type of data e.g: 'bitvector'
    #               myFitness   -> FUNCTION POINTER custom fitness function (MUST)
    #               myTerminate -> FUNCTION POINTER custom terminate function
    #                              (OPTIONAL)
    #
    #      RETURNS: A reference to the proper GA.
    #  DESCRIPTION: Returns one of the three types of Genetic Algorithm according
    #               to the arguments passed.
    #       THROWS: no exceptions
    #     COMMENTS: THIS METHOD IS NOT A CONSTRUCTOR EVEN THOUGH ITS NAME IS NEW
    #     SEE ALSO: n/a
    #===============================================================================

    #===  CLASS METHOD  ============================================================
    #        CLASS: BluGenetic
    #       METHOD: _getProperAlgorithm
    #   PARAMETERS: args -> a hash containing the needed arguments.
    #      RETURNS: The needed instance of Genetic Algorithm.
    #  DESCRIPTION: Factory method that instantiates the proper GA and returns it.
    #       THROWS: no exceptions
    #     COMMENTS: THIS IS A PRIVATE METHOD
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

1;    # End of BluGenetic
