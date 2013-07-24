#
#===============================================================================
#
#         FILE: Interface.pm
#
#  DESCRIPTION: Common INTERFACE for every crossover strategy wanted to be
#  				implemented by the library.
#
#        FILES: ---
#         BUGS: ---
#        NOTES: THIS CLASS SHOULD NEVER BE INSTANTIATED
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/12/2013 08:32:05 PM
#===============================================================================

use strict;
use warnings;

package Interface;

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
	die 'The function crossIndividuals() must be defined in a subclass.\n';
} ## --- end sub crossIndividuals

1; # Required for all packages in Perl
