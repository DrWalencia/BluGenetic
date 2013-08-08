#
#===============================================================================
#
#         FILE: UserDefinedS.pm
#
#  DESCRIPTION: Concrete implementation of the selection strategy interface 
#				comprising the UserDefinedS selection strategy in which
#				a reference to a custom selection strategy is passed as
#				a parameter in the constructor of the class.
#        
#		 FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/24/2013 12:10:19 AM
#     REVISION: ---
#===============================================================================

package UserDefinedS;

use strict;
use warnings;
use diagnostics;

use Log::Log4perl qw(get_logger);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("UserDefinedS");

# Avoid warnings regarding class method overriding
no warnings 'redefine';


# UserDefinedS inherits from Selection::SelectionStrategy
use Selection::SelectionStrategy;
use base qw(SelectionStrategy);

#===  CLASS METHOD  ============================================================
#        CLASS: UserDefinedS
#       METHOD: new
#   PARAMETERS: None. 
#      RETURNS: A reference to the instance just created. 
#  DESCRIPTION:	Creates a newly allocated UserDefinedS selection strategy.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub new {
	my $class = shift; # Every method of a class passes first argument as class name

	# Take the parameters..
	my $ref = shift;

	# Anonymous hash to store instance variables (AKA FIELDS)
	my $this = {
		strategyRef => $ref
	};

	# Connect class name with hash is known as blessing an object
	bless $this, $class;

	return $this;
} ## --- end sub new



#===  CLASS METHOD  ============================================================
#        CLASS: UserDefinedS
#       METHOD: performSelection
#   PARAMETERS: population -> the population on which the selection must be based
#   			on.
#      RETURNS: a list containing the result of the selection process.
#  DESCRIPTION: Performs the UserDefinedS selection technique.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub performSelection {
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS ARRAY
	my $this = shift;

	# Get the arguments...
	my @population = @_;
	
	my @returnPopulation = $this->{strategyRef}(@population);

	return @returnPopulation;
	
} ## --- end sub performSelection

1; # Required for all packages in Perl