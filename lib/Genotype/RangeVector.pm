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

# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields 'genotype', # Array of genes belonging to an individual, e.g:[3,-2,4]
		   'actualRanges'; # Hash of possible values for each gen. In this case
		   				   # it will contain the minimum and the maximum values.

#===  FUNCTION  ================================================================
#         NAME: new
#      PURPOSE: Creates a newly allocated RangeVector genotype.
#   PARAMETERS: lengthGen    -> length of the genotype to be created.
#   			actualRanges -> set of possible values for each gen.
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
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;

	# DO STUFF... 

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
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;

	# DO STUFF... 

	return;
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
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;

	# DO STUFF... 

	return;
} ## --- end sub getLength

#===  CLASS METHOD  ============================================================
#        CLASS: RangeVector
#       METHOD: changeGen
#   PARAMETERS: position -> indicates the position of the gen that will change.
#      RETURNS: 1 if the operation was performed successfully. 0 otherwise.
#  DESCRIPTION: Changes the value of the gen given by the position. Used for
#  				mutation purposes only.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub changeGen {
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;

	# DO STUFF... 

	return;
} ## --- end sub changeGen


#===  CLASS METHOD  ============================================================
#        CLASS: RangeVector 
#       METHOD: getRanges
#   PARAMETERS: ????
#      RETURNS: A list containing the possible values for a gen.
#  DESCRIPTION: Asks for all the possible values for the gens in the genotype.
#       THROWS: no exceptions
#     COMMENTS: none
#===============================================================================
sub getRanges {
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;

	# DO STUFF... 

	return;
} ## --- end sub getRanges



1;
