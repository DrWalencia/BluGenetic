#
#===============================================================================
#
#         FILE: GARangeVector.t
#
#  DESCRIPTION: Basic set of tests that attempt to prove that the basic
#               functionality regarding the representation of a Genetic
#				Algorithm with RangeVector as its data type.
#
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/29/2013 07:57:29 PM
#===============================================================================

use strict;
use warnings;
use diagnostics;

use Test::More;
use Log::Log4perl qw(get_logger);
use Individual;
use Algorithm::GARangeVector;

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

sub fitness {

    my ($individual) = @_;
    my $genotype = $individual->getGenotype();
    my $i;
    my $counter;

    for ( $i = 0 ; $i < $genotype->getLength() ; $i++ ) {
        $counter += $genotype->getGen($i);
    }

    return $counter;
}

sub terminate {

    my $GA = shift;

    return 0;
}

# initialize: check that the argument introduced is an array of
# references to arrays. Empty list passed. Dies painfully.
{
    my $algorithm = GARangeVector->new(
        popSize   => 4,
        crossProb => 0.3,
        mutProb  => 0.4,
        myFitness   => \&fitness,
    );

    dies_ok { $algorithm->initialize() }
"initialize: check that the argument introduced is an array of references to arrays. Die otherwise";

}

# initialize: check that the argument introduced is an array of
# references to arrays. List and scalar passed. Dies painfully.
{
    my $algorithm = GARangeVector->new(
        popSize   => 4,
        crossProb => 0.3,
        mutProb  => 0.4,
        myFitness   => \&fitness,
    );

    dies_ok { $algorithm->initialize( [ 2, 3 ], 3 ) }
"initialize: check that the argument introduced is an array of references to arrays. List and scalar passed. Dies painfully.";
}

# initialize: make sure that sublists are made of only a couple
# of scalar elements. Die otherwise.
{
    my $algorithm = GARangeVector->new(
        popSize   => 4,
        crossProb => 0.3,
        mutProb  => 0.4,
        myFitness   => \&fitness,
    );

    dies_ok { $algorithm->initialize( [ 2, 3 ], [ 2, 3, 4 ] ) }
"initialize: make sure that sublists are made of only a couple of scalar elements. Die otherwise.";
}

# initialize: make sure that sublists are arranged in the
# position [Min,Max]
{
    my $algorithm = GARangeVector->new(
        popSize   => 4,
        crossProb => 0.3,
        mutProb  => 0.4,
        myFitness   => \&fitness,
    );

    dies_ok { $algorithm->initialize( [ 4, 2 ], [ 3, 4 ] ) }
"initialize: make sure that sublists are arranged in the position [Min,Max]";
}

# insert: check that if the amount of individuals to be inserted
# is zero or negative, it dies.
{
    my $algorithm = GARangeVector->new(
        popSize   => 4,
        crossProb => 0.3,
        mutProb  => 0.4,
        myFitness   => \&fitness,
    );

    dies_ok { $algorithm->insert(0) }
    "insert: check that insert dies if amount of individuals is 0.";
}

{
    my $algorithm = GARangeVector->new(
        popSize   => 4,
        crossProb => 0.3,
        mutProb  => 0.4,
        myFitness   => \&fitness,
    );

    dies_ok { $algorithm->insert(-4) }
    "insert: check that insert dies if amount of individuals is negative.";
}

# insert: check after successful insertion that the population
# have grown as much as n.
{
    my $algorithm = GARangeVector->new(
        popSize   => 4,
        crossProb => 0.3,
        mutProb  => 0.4,
        myFitness   => \&fitness,
    );

    $algorithm->initialize( [ 1, 5 ], [ 0, 20 ], [ 4, 9 ] );

    $algorithm->insert(1);

    ok( $algorithm->getPopSize() == 5, "insert: Population grew from 4 to 5" );

    my $popRef = $algorithm->getPopulation();

    ok(
        $algorithm->getPopSize() == @$popRef,
        "insert: Population array size is the same as algorithm->getPopSize()"
    );

}

# delete: check that if the index given is less than zero or more
# than the population size, it dies.
{
    my $algorithm = GARangeVector->new(
        popSize   => 4,
        crossProb => 0.3,
        mutProb  => 0.4,
        myFitness   => \&fitness,
    );

    dies_ok { $algorithm->delete(-4) }
"deleteIndividual: check that deleteIndividual dies if amount of individuals is negative.";
}

{
    my $algorithm = GARangeVector->new(
        popSize   => 4,
        crossProb => 0.3,
        mutProb  => 0.4,
        myFitness   => \&fitness,
    );

    dies_ok { $algorithm->insert(5) }
"delete: check that insert dies if amount of individuals is bigger than the highest index.";
}

# delete: check after successful deletion that de population had
# become 1 individual smaller.
{
    my $algorithm = GARangeVector->new(
        popSize   => 4,
        crossProb => 0.3,
        mutProb  => 0.4,
        myFitness   => \&fitness,
    );

    $algorithm->initialize( [ 1, 5 ], [ 0, 20 ], [ 4, 9 ] );

    $algorithm->delete(3);

    ok( $algorithm->getPopSize() == 3,
        "delete: population smaller by 1 individual" );

    my $popRef = $algorithm->getPopulation();

    ok(
        $algorithm->getPopSize() == @$popRef,
        "delete: population array size is the same as algorithm->getPopSize()"
    );
}

# Population inside the algorithm is just a reference, so to play with it
# it must be dereferenced first.
{
    my $algorithm = GARangeVector->new(
        popSize   => 4,
        crossProb => 0.3,
        mutProb  => 0.4,
        myFitness   => \&fitness,
    );

    $algorithm->initialize( [ 1, 5 ], [ 0, 20 ], [ 4, 9 ] );

    my $populationRef = $algorithm->getPopulation();
    my @population    = @$populationRef;
    my $individual    = $population[0];

    my $genotype = $individual->getGenotype();

    ok( $genotype->getLength() == 3,
        "Check that individuals in the population have the correct length" );
}

# _fitnessFunc: (BREAKING ENCAPSULATION) Generate population, insert
# individual in which we already know the fitness value and check if
# this function returns the expected value.
{

    my $algorithm = GARangeVector->new(
        popSize   => 12,
        crossProb => 0.3,
        mutProb  => 0.4,
        myFitness   => \&fitness,
    );

    $algorithm->initialize( [ 1, 5 ], [ 0, 20 ], [ 4, 9 ] );
    $algorithm->insert( 1, [ 2, 3, 5 ] );

    # Population inside the algorithm is just a reference, so to play with it
    # it must be dereferenced first.

    my $populationRef = $algorithm->getPopulation();
    my @population    = @$populationRef;

    my $individual2 = $population[-1];

    ok(
        $individual2->getScore() == 10,
"_fitnessFunc: Generate population, insert individual in which we already know the fitness value and check if this function returns the expected value."
    );
}

# getType: generate AG and call getType. Check if it returns the
# expected value.
{
    my $algorithm = GARangeVector->new(
        popSize   => 12,
        crossProb => 0.3,
        mutProb  => 0.4,
        myFitness   => \&fitness,
    );

    ok(
        $algorithm->getType() eq "rangevector",
        "generate AG and call getType. Check if it returns the expected value"
    );
}

# evolve: example that works.
{
    my $algorithm = GARangeVector->new(
        popSize   => 20,
        crossProb => 0.8,
        mutProb  => 0.05,
        myFitness   => \&fitness,
        terminate => \&terminate,
    );

    sub sel {

        # Get the arguments...
        my @population = @_;

        return @population;

    }    ## --- end sub selection

    $algorithm->createSelectionStrategy( "simple", \&sel );

    $algorithm->initialize( [ 1, 5 ], [ 0, 20 ], [ 4, 9 ] );

    my $popref     = $algorithm->getPopulation();
    my @population = @$popref;

    $algorithm->evolve(
        selection   => "simple",
        crossover   => "onepoint",
        generations => 20
    );

    my $ind = $algorithm->getFittest();

    print "Score of fittest:", $ind->getScore(), "\n";
}

# _terminateFunc: implicit check of currentGeneration

sub myTerminate {

    my $GA = shift;

    print( $GA->getCurrentGeneration() );
    print "\n";

    my $fittest = $GA->getFittest();

    if ( $fittest->getScore() > 14 ) {
        return 1;
    }
    else {
        return 0;
    }
}

{
    my $algorithm = GARangeVector->new(
        popSize   => 20,
        crossProb => 0.9,
        mutProb  => 0.04,
        myFitness   => \&fitness,
        terminate => \&myTerminate,
    );

    $algorithm->initialize( [ 1, 5 ], [ 0, 20 ], [ 4, 9 ] );

    sub customCross {

        # Retrieve parameters..
        my ( $individualOne, $individualTwo ) = @_;

        my @v;
        push @v, $individualOne;
        push @v, $individualTwo;

        return @v;
    }    ## --- end sub cross

    $algorithm->createCrossoverStrategy( "Incredible", \&customCross );

    $algorithm->evolve(
        selection   => "tournament",
        crossover   => "onepoint",
        generations => 10,
    );

    my $ind = $algorithm->getFittest();

    print "Score of fittest:", $ind->getScore(), "\n";

}

done_testing;
