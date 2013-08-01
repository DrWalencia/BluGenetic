#
#===============================================================================
#
#         FILE: OnePoint.t
#
#  DESCRIPTION: Basic set of tests that attempt to prove that the basic
#               functionality regarding the representation of a One Point
#				crossover strategy.
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
use diagnostics;
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
log4perl.appender.LOGFILE.layout.ConversionPattern=[%d] %F %L %p - %m%n

);

## Initialize logging behavior
Log::Log4perl->init( \$conf );

