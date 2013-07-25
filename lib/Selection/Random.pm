#
#===============================================================================
#
#         FILE: Roulette.pm
#
#  DESCRIPTION: Concrete implementation of the selection strategy Interface
#  				comprising the Roulette selection technique, which consists
#  				on giving to each individual a chance of being selected 
#  				proportional to its fitness value. This way fitter individuals
#  				are more prone to be selected.
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/24/2013 12:10:19 AM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

# Avoid warnings regarding class method overriding
no warnings 'redefine';

package Roulette;

# Random inherits from Selection::SelectionStrategy
use Selection::SelectionStrategy;
our @ISA = qw(SelectionStrategy);

#===  CLASS METHOD  ============================================================
#        CLASS: Roulette
#       METHOD: new
#   PARAMETERS: None. 
#      RETURNS: A reference to the instance just created. 
#  DESCRIPTION:	Creates a newly allocated Roulette selection strategy.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub new {
	my $class = shift; # Every method of a class passes first argument as class name

	# Anonymous hash to store instance variables (AKA FIELDS)
	my $this = {};

	# Connect class name with hash is known as blessing an object
	bless $this, $class;

	return $this;
} ## --- end sub new



#===  CLASS METHOD  ============================================================
#        CLASS: Roulette
#       METHOD: performSelection
#   PARAMETERS: population -> the population on which the selection must be based
#   			on.
#      RETURNS: a list containing the result of the selection process.
#  DESCRIPTION: Performs the Roulette selection technique.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub performSelection {
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;

	# DO STUFF

	return ;
} ## --- end sub performSelection

1; # Required for all packages in Perl
