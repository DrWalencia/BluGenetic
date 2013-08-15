#
#===============================================================================
#
#         FILE: Random.t
#
#  DESCRIPTION: Basic set of tests that attempt to prove that the basic
#               functionality regarding the representation of a random
#				selection strategy.
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
use Individual;
use Selection::Random;
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

# Initialize logging behavior
Log::Log4perl->init( \$conf );

# Create a population with a couple of individuals and perform the selection.
# Just test that the returned population has two elements.
{
    my @population;
    my $selectionStr = Random->new();

    push @population,
      Individual->new(
        score    => 1.0,
        genotype => BitVector->new(6),
      );

    push @population,
      Individual->new(
        score    => 0,
        genotype => BitVector->new(6),
      );

    my @selectedPop = $selectionStr->performSelection(@population);

    ok(
        @selectedPop == @population,
"Check that the population size is the same as before the selection process"
    );

}

done_testing;
