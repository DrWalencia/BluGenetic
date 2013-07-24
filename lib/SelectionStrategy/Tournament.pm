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

# Tournament inherits from SelectionStrategy::Interface 
use SelectionStrategy::Interface;
our @ISA = qw(Interface);

# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields 'numberOfIndividuals'; # Number of individuals that are going to fight
								  # till death.


#===  CLASS METHOD  ============================================================
#        CLASS: Roulette
#       METHOD: new
#   PARAMETERS: numberOfIndividuals -> the amount of individuals that will fight
#   			till death.
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
#        CLASS: Tournament
#       METHOD: fetchWinner
#   PARAMETERS: battlefield -> the set of individuals that'll fight till death.
#      RETURNS: An individual who is the winner of the tournament.
#  DESCRIPTION: Given a battlefield, act as a referee and decide who won.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub fetchWinner {
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;
	
	#DO STUFF

	return ;
} ## --- end sub fetchWinner

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
