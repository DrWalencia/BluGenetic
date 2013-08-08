#
#===============================================================================
#
#         FILE: SelectionStrategy.pm
#
#  DESCRIPTION: Common INTERFACE for every selection strategy wanted to be 
#  				implemented by the library.
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/23/2013 11:37:31 PM
#     REVISION: ---
#===============================================================================

package SelectionStrategy;

use strict;
use warnings;
use diagnostics;
use Log::Log4perl qw(get_logger);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("SelectionStrategy");
 
#===  FUNCTION  ================================================================
#         NAME: performSelection
#      PURPOSE: Runs the selection algorithm over the population passed as a 
#      			parameter.
#   PARAMETERS: population -> the set of individuals from where the selection
#   			is performed.
#      RETURNS: An array of individuals of size popSize
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub performSelection {
	$log->logconfess("The function performSelection() must be implemented in a subclass.\n");
    return;
} ## --- end sub performSelection

1;
