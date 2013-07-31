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

use Test::More tests => 19;    # last test to print
use Log::Log4perl qw(get_logger);
use Individual;
use Genotype::BitVector;

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
log4perl.appender.LOGFILE.layout.ConversionPattern=[%r] %F %L %c - %m%n

);

## Initialize logging behavior
Log::Log4perl->init( \$conf );

# TODO MAKE A RECOPILATION OF TEST CASES

# Constructor: check that popsize is a positive number bigger than 0. Die
# otherwise.

# Constructor: check that crossover is a float number between 0 and 1. Die
# otherwise.

# Constructor: check that mutation is a float number between 0 and 1. Die
# otherwise.

# Constructor: check that fitness and terminate are function pointers. Die
# otherwise.

# Initialize: check that genotypeLength is a positive number bigger than 0.
# Die otherwise.

# insertIndividual: check that the individual to be inserted is not undef.
# Die otherwise.

# insertIndividual: check that index is between zero and genotypeLength -1
# Die otherwise

# insertIndividual: insert an individual and check that it has actually 
# been inserted.

# deleteIndividual: check that the index is between zero and genotypeLength-1
# Die otherwise

# deleteIndividual: delete a given individual and check that it has
# actually been substituted by a randomly generated one.

# getFittest: No parameter, pass zero as a parameter, pass more than the
# total population.
 
# getPopulation: generate population of one individual, substitute it for
# a given one and retrieve the population and check if it's there.

# getPopSize: generate population, get genotype, retrieve its size and check
# if it's the same as what's stored in popSize

# getCrossChance: generate AG, and check if crossChance is the same as the 
# one passed as a parameter.

# getMutChance: generate AG, and check if mutChance is the same as the 
# one passed as a parameter.




