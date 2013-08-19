#
#===============================================================================
#
#         FILE: BluGenetic.t
#
#  DESCRIPTION: Basic set of tests that attempt to prove that the basic
#               functionality regarding the factory that will take care of
#               the generation of the proper type of algorithm according
#               to the information passed as parameters by the user.
#
#       AUTHOR: Pablo Valencia González (PVG), valeng.pablo@gmail.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/29/2013 07:57:29 PM
#===============================================================================

use strict;
use warnings;
use diagnostics;

use Test::More;
use Log::Log4perl qw(get_logger);
use BluGenetic;

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

# In here there should be tests trying almost any possible input
# by the user, so that the library looks sturdy.

# If popSize undefined, die painfully
dies_ok {
    my $algorithm = BluGenetic->new(
        type    => "BitVector",
        myFitness => \&fitness
    );
}
"Constructor: popSize undefined, die painfully";

# If type undefined, die painfully
dies_ok {
    my $algorithm = BluGenetic->new(
        popSize => 24,
        myFitness => \&fitness
    );
}
"Constructor: type undefined, die painfully";

# If myFitness undefined, die painfully
dies_ok {
    my $algorithm = BluGenetic->new(
        popSize => 23,
        type    => "BitVector"
    );
}
"Constructor: myFitness undefined, die painfully";

# If mutProb defined but wrong, die painfully
dies_ok {
    my $algorithm = BluGenetic->new(
        popSize  => 24,
        mutProb => -4,
        type     => "BitVector",
        myFitness  => \&fitness
    );
}
"Constructor: mutProb defined but wrong, die painfully (negative)";

dies_ok {
    my $algorithm = BluGenetic->new(
        popSize  => 24,
        mutProb => 1.1,
        type     => "BitVector",
        myFitness  => \&fitness
    );
}
"Constructor: mutProb defined but wrong, die painfully (more than 1)";

# if crossProb defined but wrong, die painfully
dies_ok {
    my $algorithm = BluGenetic->new(
        popSize   => 24,
        crossProb => -3,
        type      => "BitVector",
        myFitness   => \&fitness
    );
}
"Constructor: crossProb defined but wrong (negative), die painfully";

dies_ok {
    my $algorithm = BluGenetic->new(
        popSize   => 24,
        crossProb => 1.01,
        type      => "BitVector",
        myFitness   => \&fitness
    );
}
"Constructor: crossProb defined but wrong (more than 1), die painfully";

# Check that a call to the factory with BitVector in a mix of
# cases, all upercase and all lowercase do not die and returns
# the proper algorithm.

# Check bitvector: uppercase and lowercase
{
    my $algorithm = BluGenetic->new(
        popSize => 33,
        type    => 'BITVECTOR',
        myFitness => \&fitness
    );

    ok( $algorithm->isa('GABitVector'),
        "Constructor: type case insensitive: BITVECTOR" );
}

{
    my $algorithm = BluGenetic->new(
        popSize => 33,
        type    => 'BitVector',
        myFitness => \&fitness
    );

    ok( $algorithm->isa('GABitVector'),
        "Constructor: type case insensitive: BitVector" );
}

# Check rangevector: uppercase and lowercase
{
    my $algorithm = BluGenetic->new(
        popSize => 33,
        type    => 'RANGEVECTOR',
        myFitness => \&fitness
    );

    ok( $algorithm->isa('GARangeVector'),
        "Constructor: type case insensitive: RANGEVECTOR" );
}

{
    my $algorithm = BluGenetic->new(
        popSize => 33,
        type    => 'RangeVector',
        myFitness => \&fitness
    );

    ok( $algorithm->isa('GARangeVector'),
        "Constructor: type case insensitive: RangeVector" );
}

# Check listvector: uppercase and lowercase
{
    my $algorithm = BluGenetic->new(
        popSize => 33,
        type    => 'LISTVECTOR',
        myFitness => \&fitness
    );

    ok( $algorithm->isa('GAListVector'),
        "Constructor: type case insensitive: LISTVECTOR" );
}

{
    my $algorithm = BluGenetic->new(
        popSize => 33,
        type    => 'ListVector',
        myFitness => \&fitness
    );

    ok( $algorithm->isa('GAListVector'),
        "Constructor: type case insensitive: ListVector" );
}

# Unknown data type (die painfully)
dies_ok {
    my $algorithm = BluGenetic->new(
        popSize => 33,
        type    => 'UNKNOWN',
        myFitness => \&fitness
    );
}
"Constructor: unknown data type. Dies";

# Example that works
{
    my $algorithm = BluGenetic->new(
        popSize   => 12,
        crossProb => 0.9,
        mutProb  => 0.05,
        type      => 'BITVECTOR',
        myFitness   => \&fitness,
        myTerminate => \&terminate,
    );

    $algorithm->initialize(10);

    $algorithm->evolve(
        selection   => 'tournament',
        crossover   => 'onepoint',
        generations => 25,
    );

    my $ind = $algorithm->getFittest();
    print "Score of fittest: ", $ind->getScore(), "\n";
}

done_testing;
