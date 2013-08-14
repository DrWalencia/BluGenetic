#
#===============================================================================
#
#         FILE: ListVector.pm
#
#  DESCRIPTION: Concrete implementation of the Genotype::Genotype interface
#  				that represents a genotype that only contents strings among the 
#  				ones given by the ranges set.
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

package ListVector;

use strict;
use warnings;
use diagnostics;
use Log::Log4perl qw(get_logger);

# Avoid warnings regarding class method overriding
no warnings 'redefine';



# ListVector inherits from Genotype::Genotype
use Genotype::Genotype;
use base qw(Genotype);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("ListVector");


# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields 'genotype', # list of genes belonging to an individual, e.g:['hola','que','tal']
		   'ranges'; # Set of possible values for each gen.


#===  FUNCTION  ================================================================
#         NAME: new
#      PURPOSE: Creates a newly allocated ListVector genotype. As much genes as
#				limits passed are going to be created.
#   PARAMETERS: ranges -> set of possible values for each gen.
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
	
	# Generate random genes between from the set of allowed values
	for ( my $i = 0; $i < @ranges; $i++ ){
		
		my $rangeGenRef = $ranges[$i];
		my @rangeGen = @$rangeGenRef;
		
		# Produce a random index inside the limits of rangeGen
		my $index = int( rand( @rangeGen ) );
		
		# And push to the genotype the element pointed by seed
		push @genotype, $rangeGen[$index];
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
#        CLASS: ListVector 
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
	my ($position, $element) = @_;
	
	# If the position is incorrect, die painfully
	$log->logconfess("Incorrect position: $position")
		if ( ($position <0) or ($position >$this->getLength()) );
		
	# If the value is not in ranges, die painfully
	my $rangesRef = $this->getRanges();
	my @ranges = @$rangesRef;
	my $myRangeRef = $ranges[$position];
	my @myRange = @$myRangeRef;
	my $flag = 0;
	
	foreach my $el (@myRange){
		if ($el eq $element){
			$flag = 1;
			last;
		};
	}

	$log->logconfess("Value not present in set: $element [", @myRange, "]")
		if (!($flag));
		
	my $genotypeRef = $this->{genotype};
	my @genotype = @$genotypeRef;
	
	$genotype[$position] = $element;
	
	$this->{genotype} = \@genotype;

	return;

} ## --- end sub setGen



#===  CLASS METHOD  ============================================================
#        CLASS: ListVector
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
#        CLASS: ListVector
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
#        CLASS: ListVector 
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
	
	# Get ranges and generate a random index inside the limits of myRange
	my $rangesRef = $this->{ranges};
	my @ranges = @$rangesRef;
	my @myRange = $ranges[$position];
	my $index = int( rand( @myRange ) );
	
	# Take the element pointed by index
	my $element = $ranges[$position][$index];
	
	# And redefine the genotype
	my $genotypeRef = $this->{genotype};
	my @genotype = @$genotypeRef;
	
	$genotype[$position] = $element;
	
	$this->{genotype} = \@genotype;

	return;
	
} ## --- end sub changeGen


#===  CLASS METHOD  ============================================================
#        CLASS: ListVector
#       METHOD: getRanges
#   PARAMETERS: ????
#      RETURNS: A list containing the possible values for a gen.
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
