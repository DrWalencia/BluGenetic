#
#===============================================================================
#
#         FILE: GABitVector.pm
#
#  DESCRIPTION: Represents a GeneticAlgorithm implementation that works with
#  				genotypes of the class BitVector, implementing the methods 
#  				that are custom for such data type.
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/24/2013 07:48:17 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use Individual;
use Genotype::BitVector;
use Log::Log4perl qw(get_logger);
	
# Avoid warnings regarding class method overriding
no warnings 'redefine';

package GABitVector;

# GABitVector inherits from Algorithm::GeneticAlgorithm 
use Algorithm::GeneticAlgorithm;
our @ISA = qw(GeneticAlgorithm);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("GABitVector");


#===  FUNCTION  ================================================================
#         NAME: new
#      PURPOSE: Creates a newly allocated GABitVector genetic algorithm.
#
#   PARAMETERS: popSize 	-> size of the population (fixed)
#
#   			
#      RETURNS: A reference to the instance just created.
#       THROWS: no exceptions
#===============================================================================
sub new {
	$log->info("Creation of new GABitVector started.");
	
	my $class = shift; # Every method of a class passes first argument as class name

	my %args = @_; # After the class name is removed, take the hash of arguments

	# Reference to anonymous hash to store instance variables (AKA FIELDS)
	my $this = {
		popSize		=> $args{popSize},
		crossover	=> $args{crossover},
		mutation	=> $args{mutation},
		fitness		=> $args{fitness},
		terminate	=> $args{terminate}, # no function defined: terminate: undef
	};

	# Connect a class name with a hash is known as blessing an object
	bless $this , $class;

	$log->info("Creation of a new GABitVector ended.");

	return $this;
} ## --- end sub new

# ===  CLASS METHOD  ===========================================================
#        CLASS: GABitVector
#       METHOD: initialize
#
#   PARAMETERS: genotypeLength -> length of the genotype to be generated
#
#      RETURNS: 1 if the initialization was performed correctly. 0 
#				otherwise.
#  DESCRIPTION: Fills the populations with individuals whose genotype is
#				randomly generated.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub initialize{
	
	# Retrieve fields as reference to a hash and the parameter
	my ($this, $genotypeLength) = @_;

	# Dereference hash leaving it ready to be used
	my %fields = %$this;

	# Declare counter and population to be filled
	my $i;
	my $pop;

	# And fill the population with individuals of type BitVector
	# randomly generated (such action takes part in the new() method)
	for ( $i=0; $i < $fields{popSize}; $i++ ){
		my $individualTemp = Individual->new();	
		#	$individualTemp->setGenotype( BitVector->new($genotypeLength) );
		#   $individualTemp->setScore( $fields{fitnessFunc}($individualTemp) );
	}
	


	return ;
} ## --- end sub initialize
#=== CLASS METHOD  ============================================================= #        CLASS: GABitVector
#       METHOD: insertIndividual
#
#   PARAMETERS: individual -> the individual to be inserted.
#				index 		-> the position where the individual will be placed.

#      RETURNS: 1 if the insertion was performed correctly. 0 otherwise.

#  DESCRIPTION: Inserts an individual in the population on the position given
#				by index.

#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub insertIndividual{
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;	

	# DO STUFF

	return ;
} ## --- end sub insertIndividual

#=== CLASS METHOD  ============================================================
#        CLASS: GABitVector
#       METHOD: deleteIndividual
#
#   PARAMETERS: index -> the position of the individual to be deleted.
#
#      RETURNS: 1 if the deletion was performed correctly. 0 otherwise.
#
#  DESCRIPTION: Deletes the individual given by index and inserts another
#				individual randomly generated in the same position.
#
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub deleteIndividual{
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;	

	# DO STUFF

	return ;
} ## --- end sub deleteIndividual

1;
