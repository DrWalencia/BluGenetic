#
#===============================================================================
#
#         FILE: Individual.pm
#
#  DESCRIPTION: Class that represents an Individual of a given population. It
#  				is comprised by a genotype and its score.
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/24/2013 07:44:53 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use Log::Log4perl qw(get_logger);
package Individual;

# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields 'score', # FLOAT the score of the individual.
		   'genotype', # REFERENCE the genotype of the individual.
		   'scoreSet'; # BOOLEAN 1 if the score is set, 0 otherwise.

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("Individual");


#=== FUNCTION  =================================================================
#         NAME: new
#      PURPOSE: Creates a newly allocated Individual.
#
# PARAMETERS_1: None (NEITHER SCORE NOR GENOTYPE)
#
# PARAMETERS_2: genotype	-> the genotype of the individual (NO SCORE)
#
# PARAMETERS_3: score		-> the score of the individual 
# 				genotype 	-> the genotype of the individual
#				
#      RETURNS: A reference to the instance just created.
#       THROWS: no exceptions
#===============================================================================
sub new {


	my $class = shift; # Every method of a class passes first argument as class name

	my %args = @_; # After the class name is removed, take the hash of arguments

	# Anonymous hash to store instance variables (AKA FIELDS)
	my $this;


	# Three cases of new are valid, according to the method signature.
	if ( scalar keys %args == 2 ){

		$log->info("Creation of a new individual with two arguments started.");
		$this = {
			score		=> $args{score},
			genotype	=> $args{genotype},
			scoreSet	=> 1
		};

	}elsif ( scalar keys %args == 1 ){

		$log->info("Creation of a new individual with one argument started.");
		$this = {
			genotype	=> $args{genotype},
			scoreSet 	=> 0
		};

	}else{

		$log->info("Creation of a new individual with zero arguments started.");
		$this = {
			scoreSet	=> 0
		};
	}

	# Connect a class name with a hash is known as blessing an object
	bless $this , $class;

	$log->info("Creation of a new individual finished.");

	return $this;
} ## --- end sub new


#===  CLASS METHOD  ============================================================
#        CLASS: Individual
#       METHOD: getScore
#   PARAMETERS: None. 
#      RETURNS: FLOAT the score store in the individual as a field. 
#  DESCRIPTION: Getter for the score of the individual.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getScore {
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;

	# DO STUFF... 

	return;
} ## --- end sub getScore


#===  CLASS METHOD  ============================================================
#        CLASS: Individual
#       METHOD: setScore 
#   PARAMETERS: newScore -> the score to be set. 
#      RETURNS: Nothing. 
#  DESCRIPTION: Setter for the score of the individual.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub setScore {
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;

	# DO STUFF... 

	return;
} ## --- end sub setScore

#===  CLASS METHOD  ============================================================
#        CLASS: Individual
#       METHOD: scoreSet
#   PARAMETERS: None. 
#      RETURNS: 1 if the score has been set, 0 otherwise. 
#  DESCRIPTION: Checks if the score has been calculated.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub scoreSet {
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;

	# DO STUFF... 

	return;
} ## --- end sub scoreSet 

#===  CLASS METHOD  ============================================================
#        CLASS: Individual
#       METHOD: getGenotype 
#   PARAMETERS: None. 
#      RETURNS: REFERENCE the genotype of the individual. 
#  DESCRIPTION: Getter for the genotype.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getGenotype{
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;

	# DO STUFF... 

	return;
} ## --- end sub getGenotype


#=== CLASS METHOD  =============================================================
#        CLASS: Individual
#       METHOD: setGenotype 
#   PARAMETERS: REFERENCE the genotype of the individual. 
#      RETURNS: Nothing. 
#  DESCRIPTION: Setter for the genotype.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub setGenotype{
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;

	# DO STUFF... 

	return;
} ## --- end sub setGenotype 


1;
