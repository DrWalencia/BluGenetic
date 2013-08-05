#
#===============================================================================
#
#         FILE: TwoPoint.pm
#
#  DESCRIPTION: Concrete implementation of the CrossStrategy interface
#  				comprising the two point crossover technique, which consists on
#  				defining two random cut positions (which will be the same for
#  				both individuals) and divide them and reconstruct each one
#  				interchanging parts of both individuals.
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
package TwoPoint;
use strict;
use warnings;
use diagnostics;
use Log::Log4perl qw(get_logger);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("TwoPoint");

# Avoid warnings regarding class method overriding
no warnings 'redefine';

# TwoPoint inherits from Crossover::CrossoverStrategy
use Crossover::CrossoverStrategy;
use base qw(CrossoverStrategy);

# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields 'indOne', 'indTwo',    # The two individuals to be mated.
  'cutPoint1', 'cutPoint2',    # The two needed cut points randomly generated.
  'cutPointSet',    # Stores if the manual points have been set or not
  'manualCutPoint1', 'manualCutPoint2';    # Cut points manually set

#===  FUNCTION  ================================================================
#         NAME: new
#      PURPOSE: Creates a newly allocated TwoPoint crossover strategy.
#   PARAMETERS: None.
#      RETURNS: A reference to the instance just created.
#       THROWS: no exceptions
#===============================================================================
sub new {
	my $class =
	  shift;    # Every method of a class passes first argument as class name

	# Anonymous hash to store instance variables (AKA FIELDS)
	my $this = {};

	# When a TwoPoint strategy is created, its cut points are unset
	$this->{cutPointSet} = 0;

	# Connect a class name with a hash is known as blessing an object
	bless $this, $class;
	return $this;
}    ## --- end sub new

#===  CLASS METHOD  ============================================================
#        CLASS: TwoPoint
#       METHOD: setCutPoints
#   PARAMETERS: point1 -> the first cut point.
#   			point2 -> the second cut point.
#      RETURNS: Nothing.
#  DESCRIPTION: Manually sets a cut points to perform the crossover. For
#				testing purposes only.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub setCutPoints {

	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
	my $this = shift;

	# Get the parameters...
	my ( $point1, $point2 ) = @_;

	# And set their respective field values
	$this->{manualCutPoint1} = $point1;
	$this->{manualCutPoint2} = $point2;
	$this->{cutPointSet}     = 1;
}

#===  CLASS METHOD  ============================================================
#        CLASS: TwoPoint
#       METHOD: crossIndividuals
#   PARAMETERS: individualOne -> the first individual to be mated.
#   			individualTwo -> the second individual to be mated.
#      RETURNS: A vector of individuals containing the offspring of those passed
#      			as parameters.
#  DESCRIPTION: Crosses a couple of individuals of the same length following
#  				the two-point technique.
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

	# If cut points are unset, generate them. Otherwise we're testing.
	if ( $this->{cutPointSet} == 0 ) {

		# Select  cutPoint1 and cutPoint2: random numbers between 0
		# and k-1 being k=length of individual. 2 must be subtracted
		# from the genotype length because there are length()-1 cut
		# points and the indexes go from 0 to length()-1
		$this->{cutPoint1} =
		  int( rand( $this->{indOne}->getGenotype()->getLength() - 2 ) );
		$this->{cutPoint2};

		# In the very unlikely case that rand() generates the same
		# index for cutPoint2...
		do {
			$this->{cutPoint2} =
			  int( rand( $this->{indOne}->getGenotype()->getLength() - 2 ) );
		} while ( $this->{cutPoint1} == $this->{cutPoint2} );

		# Make sure that cutPoint1 is the smallest of the two cut
		# points and if not, swap them.
		if ( $this->{cutPoint1} > $this->{cutPoint2} ) {
			my $aux = $this->{cutPoint1};
			$this->{cutPoint2} = $this->{cutPoint1};
			$this->{cutPoint1} = $aux;
		}
	}
	else {
		$this->{cutPoint1} = $this->{manualCutPoint1};
		$this->{cutPoint2} = $this->{manualCutPoint2};
	}
	my $genotypeChild1;
	my $genotypeChild2;
	my $child1;
	my $child2;
	if ( $this->{indOne}->getGenotype()->isa("BitVector") ) {

		# Create temporal genotypes for children...
		$genotypeChild1 =
		  BitVector->new( $this->{indOne}->getGenotype()->getLength() );
		$genotypeChild2 =
		  BitVector->new( $this->{indOne}->getGenotype()->getLength() );
		$child1 = Individual->new( genotype =>
				new BitVector( $this->{indOne}->getGenotype()->getLength() ), );
		$child2 = Individual->new( genotype =>
				new BitVector( $this->{indOne}->getGenotype()->getLength() ), );
	}
	elsif ( $this->{indOne}->getGenotype()->isa("RangeVector") ) {
		$log->logconfess("Unimplemented");
	}
	elsif ( $this->{indOne}->getGenotype()->isa("ListVector") ) {
		$log->logconfess("Unimplemented");
	}
	else {
		$log->logconfess(
				"Trying to perform crossover on an unrecognized genotype type");
	}

	# Child one: from 0 to cutPoint1 individual One, from cutPoint1+1
	# to cutPoint2 individual Two and from cutPoint2+1 individual One
	# Child two: from 0 to cutPoint1 individual two, from cutPoint1+1
	# to cutPoint2 individual One and from cutPoint2+1 individual Two
	# First part of children...
	for ( my $i = 0 ; $i <= $this->{cutPoint1} ; $i++ ) {
		$genotypeChild1->setGen( $i,
								 $this->{indOne}->getGenotype()->getGen($i) );
		$genotypeChild2->setGen( $i,
								 $this->{indTwo}->getGenotype()->getGen($i) );
	}

	# Middle part of children...
	for ( my $j = $this->{cutPoint1} + 1 ; $j <= $this->{cutPoint2} ; $j++ ) {
		$genotypeChild1->setGen( $j,
								 $this->{indTwo}->getGenotype()->getGen($j) );
		$genotypeChild2->setGen( $j,
								 $this->{indOne}->getGenotype()->getGen($j) );
	}

	# And last part of the children
	for ( my $k = $this->{cutPoint2} + 1 ;
		  $k < $this->{indOne}->getGenotype()->getLength() ;
		  $k++ )
	{
		$genotypeChild1->setGen( $k,
								 $this->{indOne}->getGenotype()->getGent($k) );
		$genotypeChild2->setGen( $k,
								 $this->{indTwo}->getGenotype()->getGent($k) );
	}

	# Populate new Individuals to put the calculated genotypes..
	for ( my $k = 0 ; $k < $this->{indOne}->getGenotype()->getLength() ; $k++ )
	{
		$child1->getGenotype()->setGen( $k, $genotypeChild1->getGen($k) );
		$child2->getGenotype()->setGen( $k, $genotypeChild2->getGen($k) );
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
	
}     ## --- end sub crossIndividuals
1;    # Required for all packages in Perl
