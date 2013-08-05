#
#===============================================================================
#
#         FILE: Uniform.pm
#
#  DESCRIPTION: Concrete implementation of the CrossStrategy interface
#  				comprising the uniform crossover technique, which consists on
#  				selecting one gen per parent for each one of the offspring.
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
package Uniform;
use strict;
use warnings;
use diagnostics;
use Log::Log4perl qw(get_logger);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("OnePoint");

# Avoid warnings regarding class method overriding
no warnings 'redefine';

# Uniform inherits from Crossover::CrossoverStrategy
use Crossover::CrossoverStrategy;
use base qw(CrossoverStrategy);

# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields 'indOne', 'indTwo';    # The two individuals to be mated.

#===  FUNCTION  ================================================================
#         NAME: new
#      PURPOSE: Creates a newly allocated Uniform crossover strategy.
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

#=== CLASS METHOD  ============================================================
#        CLASS: Uniform
#       METHOD: randomSel
#   PARAMETERS: position -> the position of the gen.
#      RETURNS: the value of the selected gen.
#  DESCRIPTION: For a given position select randomly which parent a given gen
#				is selected from.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub randomSel {

	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
	my $this = shift;

	# Get the argument...
	my ($position) = @_;
	my $seed = int( rand(2) );
	my $returnValue;
	if ( $seed == 0 ) {
		$returnValue = $this->{indOne}->getGenotype()->getGen($position);
	}
	else {
		$returnValue = $this->{indTwo}->getGenotype()->getGen($position);
	}
	return $returnValue;
}

#=== CLASS METHOD  ============================================================
#        CLASS: Uniform
#       METHOD: crossIndividuals
#   PARAMETERS: individualOne -> the first individual to be mated.
#   			individualTwo -> the second individual to be mated.
#      RETURNS: A vector of individuals containing the offspring of those passed
#      			as parameters.
#  DESCRIPTION: Crosses a couple of individuals of the same length following
#  				the uniform technique.
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

		# Create temporal genotypes for children...
		$genotypeChild1 =
		  RangeVector->new( $this->{indOne}->getGenotype()->getLength() );
		$genotypeChild2 =
		  RangeVector->new( $this->{indOne}->getGenotype()->getLength() );
		$child1 = Individual->new( genotype =>
			  new RangeVector( $this->{indOne}->getGenotype()->getLength() ), );
		$child2 = Individual->new( genotype =>
			  new RangeVector( $this->{indOne}->getGenotype()->getLength() ), );
	}
	elsif ( $this->{indOne}->getGenotype()->isa("ListVector") ) {

		# Create temporal genotypes for children...
		$genotypeChild1 =
		  ListVector->new( $this->{indOne}->getGenotype()->getLength() );
		$genotypeChild2 =
		  ListVector->new( $this->{indOne}->getGenotype()->getLength() );
		$child1 = Individual->new( genotype =>
			   new ListVector( $this->{indOne}->getGenotype()->getLength() ), );
		$child2 = Individual->new( genotype =>
			   new ListVector( $this->{indOne}->getGenotype()->getLength() ), );
	}
	else {
		$log->logconfess(
				"Trying to perform crossover on an unrecognized genotype type");
	}

	# Child one: for each gen from i=0 to Length() select randomly if
	# we choose the locus from indOne or indTwo
	# Child two: for each gen from i=0 to Length() select randomly if
	# we choose the locus from indOne or indTwo
	for ( my $i = 0 ; $i < $this->{indOne}->getGenotype()->getLength() ; $i++ )
	{
		$genotypeChild1->setGen( $i, randomSel($i) );
		$genotypeChild2->setGen( $i, randomSel($i) );
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
