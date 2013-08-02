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
package OnePoint;
use strict;
use warnings;
use diagnostics;
use Log::Log4perl qw(get_logger);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("OnePoint");

# Avoid warnings regarding class method overriding
no warnings 'redefine';

# OnePoint inherits from Crossover::CrossoverStrategy
use Crossover::CrossoverStrategy;
use base qw(CrossoverStrategy);

# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields 'indOne', 'indTwo',    # The two individuals to be mated.
  'cutPoint',          # The cut point randomly generated.
  'manualCutPoint',    # Stores cut point manually set.
  'cutPointset';       # Stoes if the manual cut point has been  set or not.

#===  FUNCTION  ================================================================
#         NAME: new
#      PURPOSE: Creates a newly allocated OnePoint crossover strategy.
#   PARAMETERS: None.
#      RETURNS: A reference to the instance just created.
#       THROWS: no exceptions
#===============================================================================
sub new {
	my $class =
	  shift;    # Every method of a class passes first argument as class name

	# Anonymous hash to store instance variables (AKA FIELDS)
	my $this = {};

	# Connect a class name with a hash is known as blessing an object
	bless $this, $class;
	return $this;
}    ## --- end sub new

#===  CLASS METHOD  ============================================================
#        CLASS: OnePoint
#       METHOD: setCutPoint
#   PARAMETERS: point -> The cut point.
#      RETURNS: Nothing
#  DESCRIPTION: Manually sets the cut point for the crossover operation. For
#				testing purposes only.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub setCutPoint {
	
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
	my $this = shift;
	
	# Retrieve parameters...
	my ( $point ) = @_;
	
	$this->{manualCutPoint} = $point;
	$this->{cutPointSet} = 1;
	
	return;
}

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
	if ( $this->{cutPointSet} == 0 ) {

		# Select  cutPoint=random number between 0 and k-1 being 
		# k=length of individual. 2 must be subtracted from the 
		# genotype length because there are length()-1 cut points
		# and the indexes go from 0 to length()-1
		$this->{cutPoint} =
		  int( rand( $this->{indOne}->getGenotype()->getLength() - 2 ) );
	}
	else {
		# Manual cut point set up for testing purposes
		$this->{cutPoint} = $this->{manualCutPoint};
	}
	
	if ( $this->{indOne}->getGenotype()->isa("BitVector") ){
		
		# Create temporal genotypes for children...
		my $genotypeChild1 = BitVector->new( $this->{indOne}->getGenotype()->getLength() );
		my $genotypeChild2 = BitVector->new( $this->{indOne}->getGenotype()->getLength() );
		
		# Child one: from 0 to cutPoint individual one, from cutPoint+1 to k individual two
		# Child two: from 0 to cutPoint individual two, from cutPoint+1 to k individual one		
		
		# First part of the children...
		for ( my $i = 0; $i <= $this->{cutPoint}; $i++ ){
			$genotypeChild1->setGen($i, $this->{indOne}->getGenotype()->getGen($i));
			$genotypeChild2->setGen($i, $this->{indTwo}->getGenotype()->getGen($i));
		}
		
		# And second...
		for ( my $j = $this->{cutPoint} + 1; $j < $this->{indOne}->getGenotype()->getLength(); $j++){
			$genotypeChild1->setGen($j, $this->{indTwo}->getGenotype()->getGen($j));
			$genotypeChild2->setGen($j, $this->{indOne}->getGenotype()->getGen($j));
		}
		
#		my $a = $genotypeChild1->{genotype};
#		my $b = $genotypeChild2->{genotype};
#		
#		print @$a;
#		print "\n";
#		
#		print @$b;
#		print "\n";
		
		my $child1 = Individual->new(
			genotype=> new BitVector($this->{indOne}->getGenotype()->getLength()),
		);
		my $child2 = Individual->new(
			genotype=> new BitVector($this->{indOne}->getGenotype()->getLength()),
		);
		
		# And create new Individuals to put the calculated genotypes..
		for ( my $k = 0; $k < $this->{indOne}->getGenotype()->getLength(); $k++ ){
			$child1->getGenotype()->setGen($k, $genotypeChild1->getGen($k));
			$child2->getGenotype()->setGen($k, $genotypeChild2->getGen($k));
		}
		
		# Put their respective scores to zero. SCORE FOR THIS TWO MUST 
		# BE RECALCULATED AGAIN
		$child1->setScore(0);
		$child2->setScore(0);
		
		# Create a vector of individuals and return the children
		# using it
		my @v;
		push @v, $child1;
		push @v, $child2;
		
		return @v;
		
	}elsif ( $this->{indOne}->getGenotype()->isa("RangeVector") ){
		$log->logconfess("Unimplemented");
	}elsif ( $this->{indOne}->getGenotype()->isa("ListVector") ){
		$log->logconfess("Unimplemented");
	}else{
		$log->logconfess("Trying to perform crossover on an unrecognized genotype type");
	}

}    ## --- end sub crossIndividuals

1;    # Required for all packages in Perl
