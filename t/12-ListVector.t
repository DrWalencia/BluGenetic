#
#===============================================================================
#
#         FILE: ListVector.t
#
#  DESCRIPTION: Basic set of tests that attempt to prove that the basic
#               functionality regarding the ListVector genotype is working.
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/23/2013 08:12:35 PM
#===============================================================================

use Test::More;
use Log::Log4perl qw(get_logger);
use Genotype::ListVector;
use diagnostics;

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

# Initialize logging behavior
Log::Log4perl->init( \$conf );

# Constructor: memory allocated and correct number of genes
# If it doesn't complain we're okay
{
	ok( ListVector->new([ [qw/red blue green/],
               [qw/big medium small/],
               [qw/very_fat fat fit thin very_thin/] ]), "Constructor: memory allocated and correct number of genes" );
}

# Constructor: size and genotypes are the same


# Constructor: check if gen values randomly generated are within range.


# setGen: Introduce gen in wrong position: over genotype length or below 0. Dies


# setGen: value out of range: over and below limits. Dies


# setGen: make sure a zero is inserted in bit 0 by inserting it

# getGen: check that the gen returned and the one got by breaking
# encapsulation are the same


# getLength: check that the length returned an the one got by
# breaking encapsulation are the same


# getType: Create a ListVector element and check if the type corresponds to RangeVector


# changeGen: mutate and check that the values are different.
# COMMENTED -> IT MAY RARELY FAIL BECAUSE OF ITS RANDOM NATURE


# getRanges: call the function and check that it contains
# a reference to an array of references to array


done_testing;