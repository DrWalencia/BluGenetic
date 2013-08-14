#
#===============================================================================
#
#         FILE: RangeVector.pm
#
#  DESCRIPTION: Concrete implementation of the Genotype::Genotype interface
#  				that represents a genotype that only contents integers between
#  				limits given by the ranges set.
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/24/2013 07:44:10 PM
#     REVISION: ---
#===============================================================================

package RangeVector;

use strict;
use warnings;
use diagnostics;
use Log::Log4perl qw(get_logger);

# Avoid warnings regarding class method overriding
no warnings 'redefine';


# RangeVector inherits from Genotype::Genotype
use Genotype::Genotype;
use base qw(Genotype);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("RangeVector");

# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields 'genotype',		# Array of genes belonging to an individual, e.g:[3,-2,4]
		   'ranges';		# List of references to arrays of possible values for 
							# each gen. In this case it will contain the minimum 
		   				    # and the maximum values.

#===  FUNCTION  ================================================================
#         NAME: new
#
#      PURPOSE: Creates a newly allocated RangeVector genotype randomly
#				initializing its genes.
#
#   PARAMETERS: ranges -> Array of references to arrays containing
#				the maximum and minimum limits for each gen. As much genes as
#				limits passed are going to be created.
#
#      RETURNS: A reference to the instance just created.
#       THROWS: no exceptions
#===============================================================================
sub new {
	
	$log->info("Creation of a new RangeVector genotype started.");
	
    # Every method of a class passes first argument as class name
    my $class = shift;
 
 	# Take the arguments...
 	my @ranges = @_;
	
	# Generate genotype...
	my @genotype;
	
	# Generate random genes between limits
	for ( my $i = 0; $i < @ranges; $i++ ){
		
		my $rangeGenRef = $ranges[$i];
		my @rangeGen = @$rangeGenRef;
		
		# Sum one to the rand seed because it generates
		# numbers from 0 to n-1
		my $seed = $rangeGen[1] - $rangeGen[0] + 1;
		
		$seed = abs($seed);
		
		my $value = int( rand( $seed )) + $rangeGen[0];
		push @genotype, $value;
	}

	# Anonymous hash to store instance variables (AKA FIELDS)
	my $this = {
		genotype	=> \@genotype,
		ranges		=> \@ranges
	};

	# Connect a class name with a hash is known as blessing an object
	bless $this , $class;

    $log->info("Creation of a new BitVector genotype finished.");

	return $this;
	
} ## --- end sub new

#===  CLASS METHOD  ============================================================
#        CLASS: RangeVector
#       METHOD: setGen
#       
#   PARAMETERS: position -> the position where the gen value is to be modified.  
#   			value -> the value to be inserted in the gen.
#   			
#      RETURNS: 1 if the insertion was performed correctly. 0 otherwise.
#
#  DESCRIPTION: Puts the value passed as a parameter in the gen specified 
#  				by the position parameter.
#
#       THROWS: no exceptions
#     COMMENTS: locus -> value
#===============================================================================
sub setGen {
	
    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE HASH OF FIELDS
	my $this = shift;
	
	# Take the arguments
	my ($position, $value) = @_;
	
	# If the position is incorrect, die painfully
	$log->logconfess("Incorrect position: $position")
		if ( ($position <0) or ($position >$this->getLength()) );
		
	# If the value is out of ranges, die painfully
	my $rangesRef = $this->{ranges};
	my @ranges = @$rangesRef;
	
	my $myRangeRef = $ranges[$position];
	my @myRange = @$myRangeRef;

	$log->logconfess("Value out of ranges: $value (Ranges: [", $myRange[0], ",", $myRange[1], "])")
		if ( ($value > $myRange[1]) or ($value < $myRange[0]) );
		
	my $genotypeRef = $this->{genotype};
	my @genotype = @$genotypeRef;
	
	$genotype[$position] = $value;
	
	$this->{genotype} = \@genotype;

	return;
	
} ## --- end sub setGen

#===  CLASS METHOD  ============================================================
#        CLASS: RangeVector
#       METHOD: getGen
#
#   PARAMETERS: position -> the position of the gen value wanted to be 
#   			retrieved.
#
#      RETURNS: The value stored in the gen.
#
#  DESCRIPTION: Returns the gen specified by the position passed as a parameter.
#       THROWS: no exceptions
#     COMMENTS: none
#===============================================================================
sub getGen {
	
    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE HASH OF FIELDS
	my $this = shift;
	
	# Take the arguments
	my $position = shift;
	
	# If the position is incorrect, die painfully
	$log->logconfess("Incorrect position: $position")
		if ( ($position <0) or ($position >$this->getLength()) ); 

	return $this->{genotype}[$position];
	
} ## --- end sub getGen

#===  CLASS METHOD  ============================================================
#        CLASS: RangeVector
#       METHOD: getLength
#   PARAMETERS: None
#      RETURNS: The length of the genotype.
#  DESCRIPTION: Asks for the length of the genotype.
#       THROWS: no exceptions
#     COMMENTS: none
#===============================================================================
sub getLength {
	
    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE HASH OF FIELDS
    my $this = shift;

    # Get the genotype dereferencing the $this hash
    my $genotypeRef = $this->{genotype};
    my @genotype    = @$genotypeRef;

    return scalar (@genotype);
    
} ## --- end sub getLength

#===  CLASS METHOD  ============================================================
#        CLASS: RangeVector
#       METHOD: changeGen
#   PARAMETERS: position -> indicates the position of the gen that will change.
#      RETURNS: Nothing	
#  DESCRIPTION: Changes the value of the gen given by the position. Used for
#  				mutation purposes only.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub changeGen {
	
    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE HASH OF FIELDS
	my $this = shift;

	# Take the arguments...
	my $position = shift;
	
	# If the position is incorrect, die painfully
	$log->logconfess("Incorrect position: $position")
		if ( ($position <0) or ($position >$this->getLength()) ); 
	
	# Get ranges and generate a random number inside them	
	my $rangesRef = $this->{ranges};
	my @ranges = @$rangesRef;
	my $myRangeRef = $ranges[$position];
	my @myRange = @$myRangeRef;

	my $value = int( rand( abs( $myRange[1] - $myRange[0] + 1))) + $myRange[0];
	
	my $genotypeRef = $this->{genotype};
	my @genotype = @$genotypeRef;
	
	$genotype[$position] = $value;
	
	$this->{genotype} = \@genotype;

	return;
	
} ## --- end sub changeGen


#===  CLASS METHOD  ============================================================
#        CLASS: RangeVector 
#       METHOD: getRanges
#   PARAMETERS: None
#      RETURNS: A reference to a list containing the possible values for a gen.
#  DESCRIPTION: Asks for all the possible values for the gens in the genotype.
#       THROWS: no exceptions
#     COMMENTS: none
#===============================================================================
sub getRanges {
	
    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE HASH OF FIELDS
	my $this = shift;

	return $this->{ranges};

} ## --- end sub getRanges

1;
