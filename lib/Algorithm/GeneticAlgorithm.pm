#
#===============================================================================
#
#         FILE: GeneticAlgoritm.pm
#
#  DESCRIPTION: Abstract class that represents the common interface shared by
#  				the different genotype types to be used. Some of the methods
#  				implementation are going to be the same for all of them, that's
#  				why it's an Abstract class.
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/24/2013 07:47:51 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

package GeneticAlgorithm;
 
# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields	'population', # LIST of individuals comprising the population.
			'lengthGenotype', # INT the length of the Genotype.
			'selectionStr', # REFERENCE to the selection strategy to be used.
			'crossStr', # REFERENCE to the crossover strategy to be used.
			'pMutation', # FLOAT chance of mutation 0..1
			'pCross', # FLOAT chance of crossover 0..1
			'popSize', # INT size of the population
			'currentGeneration'; # INT indicates the current generation



#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: _quickSort
#
#   PARAMETERS: i -> index of the last element of the population to be sorted
#   			by fitness function value. Usually population_size() - 1
#
#   			JULIAN PASSED ALWAYS ZERO AS THE FIRST PARAMETER (OMG!!)
#   			I IN THIS CASE IS THE SECOND PARAMETER
#
#      RETURNS: NOTHING.
#  DESCRIPTION: The first function to sort the population by the score. Side by
#  				side with _place() implement the quicksort algorithm.
#       THROWS: no exceptions
#     COMMENTS: PRIVATE METHOD 
#     SEE ALSO: n/a
#===============================================================================
sub _quickSort {

	# TO BE IMPLEMENTED IN THE ABSTRACT CLASS 
	
	return ;
} ## --- end sub _quickSort



#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: _place
#
#   PARAMETERS: j -> index of the last element of the population to be sorted
#   			by fitness function value. Usually the i from _quickSort()
#
#      RETURNS: The pivot
#  DESCRIPTION: The second part of the quicksort algorithm.
#       THROWS: no exceptions
#     COMMENTS: PRIVATE METHOD 
#     SEE ALSO: n/a
#===============================================================================
sub _place {
	
	# TO BE IMPLEMENTED IN THE ABSTRACT CLASS

	return ;
} ## --- end sub _place



#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: evolve
#
#   PARAMETERS: numGenerations -> maximum number of generations.
#           	DEFAULT VALUE IF NO PARAMETER IS PASSED: 1
#
#      RETURNS: NOTHING
#  DESCRIPTION: Makes the population evolve until the terminate() function 
# 				returns TRUE or the limit of generations is reached.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub evolve {
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;	

	# TO BE IMPLEMENTED IN THE ABSTRACT CLASS

	return ;
} ## --- end sub evolve



#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: getFittest
#
#   PARAMETERS: N -> the number of fittest individuals wanted to be retrieved.
#   			DEFAULT VALUE IF NO PARAMETER IS PASSED: 1
#
#      RETURNS: A list containing as much as N individuals
#  DESCRIPTION: Returns the N fittest individuals of the population
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getFittest {
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;	

	# TO BE IMPLEMENTED IN THE ABSTRACT CLASS

	return ;
} ## --- end sub getFittest

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: getPopulation 
#   PARAMETERS: None.
#      RETURNS: A list containing as many individuals as the population have
#  DESCRIPTION: Returns all the individuals in the population
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getPopulation{
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;	

	# TO BE IMPLEMENTED IN THE ABSTRACT CLASS

	return ;
} ## --- end sub getPopulation


#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: getPopSize
#   PARAMETERS: None.
#      RETURNS: The size of the population
#  DESCRIPTION: Getter for the population size
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getPopSize{
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;	

	# TO BE IMPLEMENTED IN THE ABSTRACT CLASS

	return ;
} ## --- end sub getPopSize

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: getCrossProb
#   PARAMETERS: None.
#      RETURNS: FLOAT the crossover chance
#  DESCRIPTION: Getter for the crossover chance 0..1
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getCrossProb{
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;	

	# TO BE IMPLEMENTED IN THE ABSTRACT CLASS

	return ;
} ## --- end sub getCrossProb

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: getMutProb
#   PARAMETERS: None.
#      RETURNS: FLOAT the mutation chance
#  DESCRIPTION: Getter for the mutation chance 0..1
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getMutProb{
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;	

	# TO BE IMPLEMENTED IN THE ABSTRACT CLASS

	return ;
} ## --- end sub getMutProb

#===  CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: getCurrentGeneration
#   PARAMETERS: None.
#      RETURNS: The current generation 
#  DESCRIPTION: Getter for the current generation of the Genetic Algorithm
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getCurrentGeneration{
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;	

	# TO BE IMPLEMENTED IN THE ABSTRACT CLASS

	return ;
} ## --- end sub getCurrentGeneration



#=== CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: sortIndividuals
#   PARAMETERS: None.
#      RETURNS: Nothing.
#  DESCRIPTION: Sorts the population of the current Genetic Algorithm
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub sortIndividuals{
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;	

	# TO BE IMPLEMENTED IN THE ABSTRACT CLASS

	return ;
} ## --- end sub sortIndividuals

#=== CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: initialize
#   PARAMETERS: None.
#      RETURNS: TRUE if the initialization was performed correctly. FALSE 
#				otherwise.
#  DESCRIPTION: Fills the populations with individuals whose genotype is
#				randomly generated.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub initialize{
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;	

	# TO BE IMPLEMENTED IN THE ABSTRACT CLASS

	return ;
} ## --- end sub initialize


#=== CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: insertIndividual
#
#   PARAMETERS: individual -> the individual to be inserted.
#				index 		-> the position where the individual will be placed.

#      RETURNS: TRUE if the insertion was performed correctly. FALSE 
#				otherwise.

#  DESCRIPTION: Inserts an individual in the population on the position given
#				by index.

#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub insertIndividual{
	# EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE CLASS NAME
	my $this = shift;	

	# TO BE IMPLEMENTED IN THE ABSTRACT CLASS

	return ;
} ## --- end sub insertIndividual

#=== CLASS METHOD  ============================================================
#        CLASS: GeneticAlgorithm
#       METHOD: deleteIndividual
#
#   PARAMETERS: index -> the position of the individual to be deleted.
#
#      RETURNS: TRUE if the deletion was performed correctly. FALSE 
#				otherwise.
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

	# TO BE IMPLEMENTED IN THE ABSTRACT CLASS

	return ;
} ## --- end sub deleteIndividuas

//TODO ¿DEFAULT IMPLEMENTATION FOR FITNESSFUNC?
//TODO DEFAULT IMPLEMENTATION FOR TERMINATEFUNC



1;
