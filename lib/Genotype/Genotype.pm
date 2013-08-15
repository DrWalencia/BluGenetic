#
#===============================================================================
#
#         FILE: Genotype.pm
#
#  DESCRIPTION: Common INTERFACE for every genotype wanted to be implemented
#               by the library.
#
#               So far implemented -> RangeVector, ListVector , BitVector
#
#        NOTES: THIS CLASS SHOULD NEVER BE INSTANTIATED
#       AUTHOR: Pablo Valencia González (PVG), valeng.pablo@gmail.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/24/2013 07:43:59 PM
#===============================================================================

package Genotype;

use strict;
use warnings;
use diagnostics;

use Log::Log4perl qw(get_logger);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("Genotype");

#===  CLASS METHOD  ============================================================
#        CLASS: Genotype
#       METHOD: setGen
#
#   PARAMETERS: position -> the position where the gen value is to be modified.
#               value -> the value to be inserted in the gen.
#
#      RETURNS: 1 if the insertion was performed correctly. 0 otherwise.
#
#  DESCRIPTION: Puts the value passed as a parameter in the gen specified
#               by the position parameter.
#
#       THROWS: no exceptions
#     COMMENTS: locus -> value
#===============================================================================
sub setGen {
    $log->logconfess(
        "The function setGen must be implemented in a subclass.\n");
    return;
}    ## --- end sub setGen

#===  CLASS METHOD  ============================================================
#        CLASS: Genotype
#       METHOD: getGen
#
#   PARAMETERS: position -> the position of the gen value wanted to be
#               retrieved.
#
#      RETURNS: The value stored in the gen.
#
#  DESCRIPTION: Returns the gen specified by the position passed as a parameter.
#       THROWS: no exceptions
#     COMMENTS: none
#===============================================================================
sub getGen {
    $log->logconfess(
        "The function getGen must be implemented in a subclass.\n");
    return;
}    ## --- end sub getGen

#===  CLASS METHOD  ============================================================
#        CLASS: Genotype
#       METHOD: getLength
#   PARAMETERS: None
#      RETURNS: The length of the genotype.
#  DESCRIPTION: Asks for the length of the genotype.
#       THROWS: no exceptions
#     COMMENTS: none
#===============================================================================
sub getLength {
    $log->logconfess(
        "The function getLength must be implemented in a subclass.\n");
    return;
}    ## --- end sub getLength

#===  CLASS METHOD  ============================================================
#        CLASS: Genotype
#       METHOD: changeGen
#   PARAMETERS: position -> indicates the position of the gen that will change.
#      RETURNS: 1 if the operation was performed successfully. 0 otherwise.
#  DESCRIPTION: Changes the value of the gen given by the position. Used for
#               mutation purposes only.
#       THROWS: no exceptions
#     COMMENTS: none #     SEE ALSO: n/a
#===============================================================================
sub changeGen {
    $log->logconfess(
        "The function changeGen must be implemented in a subclass.\n");
    return;
}    ## --- end sub changeGen

#===  CLASS METHOD  ============================================================
#        CLASS: Genotype
#       METHOD: getRanges
#   PARAMETERS: ????
#      RETURNS: A list containing the possible values for a gen.
#  DESCRIPTION: Asks for all the possible values for the gens in the genotype.
#       THROWS: no exceptions
#     COMMENTS: none
#===============================================================================
sub getRanges {
    $log->logconfess(
        "The function getRanges must be implemented in a subclass.\n");
    return;
}    ## --- end sub getRanges

1;
