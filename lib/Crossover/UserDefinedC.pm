#
#===============================================================================
#
#         FILE: UserDefinedC.pm
#
#  DESCRIPTION: Concrete implementation of the CrossStrategy interface
#  				comprising the UserDefinedC crossover strategy in which
#				a reference to a custom crossover strategy is passed as
#				a parameter in the constructor of the class.
#
#        FILES: ---
#         BUGS: ---
#
#        NOTES: strategyRef MUST FOLLOW the same signature as
#				crossIndividuals.
#
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/22/2013 09:25:14 PM
#     REVISION: ---
#===============================================================================
package UserDefinedC;
use strict;
use warnings;
use diagnostics;
use Log::Log4perl qw(get_logger);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("UserDefinedC");

# Avoid warnings regarding class method overriding
no warnings 'redefine';

# UserDefinedC inherits from Crossover::CrossoverStrategy
use Crossover::CrossoverStrategy;
use base qw(CrossoverStrategy);

# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields 'indOne', 'indTwo',	# The two individuals to be mated.
			'strategyRef';		# Function pointer to custom Crossover strategy
			
#===  FUNCTION  ================================================================
#         NAME: new
#      PURPOSE: Creates a newly allocated UserDefinedC crossover strategy.
#   PARAMETERS: None.
#      RETURNS: A reference to the instance just created.
#       THROWS: no exceptions
#===============================================================================
sub new {

    # Every method of a class passes first argument as class name
	my $class = shift;
	
	# Take the parameters..
	my $ref = shift;

	# Anonymous hash to store instance variables (AKA FIELDS)
	my $this = {
		strategyRef => $ref
	};

	# Connect a class name with a hash is known as blessing an object
	bless $this, $class;

    $log->info("Newly created Uniform crossover strategy created");

	return $this;
}    ## --- end sub new

#=== CLASS METHOD  ============================================================
#        CLASS: UserDefinedC
#       METHOD: crossIndividuals
#   PARAMETERS: individualOne -> the first individual to be mated.
#   			individualTwo -> the second individual to be mated.
#      RETURNS: A vector of individuals containing the offspring of those passed
#      			as parameters.
#  DESCRIPTION: Crosses a couple of individuals of the same length following
#  				the UserDefinedC technique.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub crossIndividuals {

	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
	my $this = shift;

	# Retrieve parameters..
	my ( $individualOne, $individualTwo ) = @_;

	# Die horribly if any of them is undefined
	$log->logconfess("First individual undefined")
	  if ( !( defined $individualOne ) );
	$log->logconfess("Second individual undefined")
	  if ( !( defined $individualTwo ) );

	# Also die if any of them do not have a proper genotype to operate with
	$log->logconfess("Genotype of first individual undefined")
	  if ( !( defined $individualOne->getGenotype() ) );
	$log->logconfess("Genotype of second individual undefined")
	  if ( !( defined $individualTwo->getGenotype() ) );

	# If everything is in order, proceed...
	$this->{indOne} = $individualOne;
	$this->{indTwo} = $individualTwo;

	# If the length of the genotype is less than two, nothing has to
	# be done
	if ( $this->{indOne}->getGenotype()->getLength() < 2 ) {
		my @v;
		push @v, $this->{indOne};
		push @v, $this->{indTwo};
		return @v;
	}
	
	# Call custom strategy and get the results...
	my @v;
	@v = $this->{strategyRef}($this->{indOne},$this->{indTwo});
	return @v;

}     ## --- end sub crossIndividuals

1;    # Required for all packages in Perl
