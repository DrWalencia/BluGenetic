#
#===============================================================================
#
#         FILE: OnePoint.pm
#
#  DESCRIPTION: Concrete implementation of the CrossStrategy interface
#  				comprising the one point crossover technique, which consists on
#  				defining a random cut position (which will be the same for 
#  				both individuals) and split them and put the first half of the 
#  				first individual with the second half of the other and the
#  				other way around.
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/22/2013 09:25:14 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

# Avoid warnings regarding class method overriding
no warnings 'redefine';

package OnePoint;

# OnePoint inherits from CrossoverStrategy::Interface
use CrossoverStrategy::Interface;
our @ISA = qw(Interface);

# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields 'indOne',
		   'indTwo', # The two individuals to be mated.
		   'cutPoint'; # The cut point randomly generated.



#===  FUNCTION  ================================================================
#         NAME: new
#      PURPOSE: Creates a newly allocated OnePoint crossover strategy.
#   PARAMETERS: None. 
#      RETURNS: A reference to the instance just created.
#       THROWS: no exceptions
#===============================================================================
sub new {
	my $class = shift; # Every method of a class passes first argument as class name

	# Anonymous hash to store instance variables (AKA FIELDS)
	my $this = {};

	# Connect a class name with a hash is known as blessing an object
	bless $this , $class;

	return $this;
} ## --- end sub new


#===  CLASS METHOD  ============================================================
#        CLASS: OnePoint
#       METHOD: crossIndividuals
#   PARAMETERS: individualOne -> The first individual to be mated
#   			individualTwo -> The second individual to be mated
#      RETURNS: A vector of individuals containing the offspring of those
#      			passed as parameters.
#  DESCRIPTION: Crosses a couple of individuals of the same length following
#  				the one-point techniques
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub crossIndividuals {
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;

	# DO STUFF... 

	return;
} ## --- end sub crossIndividuals

1; # Required for all packages in Perl
