#
#===============================================================================
#
#         FILE: CrossoverStrategy.pm
#
#  DESCRIPTION: Common INTERFACE for every crossover strategy wanted to be
#  				implemented by the library
#
#				So far implemented -> OnePoint, TwoPoint, Uniform
#
#        FILES: ---
#         BUGS: ---
#        NOTES: THIS CLASS SHOULD NEVER BE INSTANTIATED
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/12/2013 08:32:05 PM
#===============================================================================

package CrossoverStrategy;

use strict;
use warnings;
use diagnostics;
use Log::Log4perl qw(get_logger);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("CrossoverStrategy");


#===  FUNCTION  ================================================================
#         NAME: crossIndividuals
#      PURPOSE: Performs the crossover between the couple of individuals passed
#      			as parameters.
#   PARAMETERS: individualOne -> the first individual
#   			individualTwo -> the second individual.
#      RETURNS: An array containing the offspring of the previous individuals.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub crossIndividuals {
	$log->logconfess("The function crossIndividuals() must be defined in a subclass.\n");
} ## --- end sub crossIndividuals

1; # Required for all packages in Perl
