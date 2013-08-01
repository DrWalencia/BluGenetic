#
#===============================================================================
#
#         FILE: BitVector.pm
#
#  DESCRIPTION: Concrete implementation of the Genotype::Genotype interface
#               that represents a genotype that only contents binary data,
#               this is, a list of zeros and ones.
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

package BitVector;

use strict;
use warnings;
use diagnostics;
use Log::Log4perl qw(get_logger);

# Avoid warnings regarding class method overriding
no warnings 'redefine';

# BitVector inherits from Genotype::Genotype
use Genotype::Genotype;
use base qw(Genotype);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("BitVector");

# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields
  'genotype';    # list of genes belonging to an individual, e.g: [0,1,0,0]

#===  FUNCTION  ================================================================
#         NAME: new
#      PURPOSE: Creates a newly allocated BitVector genotype.
#   PARAMETERS: lengthGen -> length of the genotype to be created.
#      RETURNS: A reference to the instance just created.
#       THROWS: no exceptions
#===============================================================================
sub new {

    $log->info("Creation of a new BitVector genotype started.");

    # Every method of a class passes first argument as class name
    my $class = shift;

    # Take the first and only argument
    my $lengthGen = shift;

    $log->logconfess("Invalid number of genes for the genotype: $lengthGen")
      if $lengthGen < 1;

    # Genotype to be inserted as a field in the object being created
    my @genotype;
    my $i;

    for ( $i = 0 ; $i < $lengthGen ; $i++ ) {

        # Void rand returns something between 0..1
        push( @genotype, int( rand(2) ) );
    }

    $log->info("Genes randomly generated: (@genotype)");

    # Anonymous hash to store instance variables (AKA FIELDS)
    my $this = { genotype => \@genotype, };

    # Connect a class name with a hash is known as blessing an object
    bless $this, $class;

    $log->info("Creation of a new BitVector genotype finished.");

    return $this;
}    ## --- end sub new

#===  CLASS METHOD  ============================================================
#        CLASS: BitVector
#       METHOD: setGen
#
#   PARAMETERS: position -> the position where the gen value is to be modified.
#               value -> the value to be inserted in the gen.
#
#      RETURNS: 1 if the insertion was performed correctly. 0 otherwise.
#
#	  DESCRIPTION: Puts the value passed as a parameter in the gen specified
#                  by the position parameter.
#
#       THROWS: no exceptions
#     COMMENTS: locus -> value
#===============================================================================
sub setGen {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE HASH OF FIELDS
    my $this = shift;

    # Take the arguments and put them in proper variables
    my ( $position, $value ) = @_;

    # If the value is something different from 0 or 1, die horribly
    $log->logconfess(
        "The value passed as a parameter can only be 0 or 1 ($value inserted)")
      if ( ( $value > 1 ) or ( $value < 0 ) );

    # Get the genotype dereferencing the $this hash
    my %hash        = %$this;
    my $genotypeRef = $hash{genotype};
    my @genotype    = @$genotypeRef;

	my $genotypeMaxPos = scalar(@genotype) - 1;

    # If the position is something lower than 0 or bigger than the genotype
    # size, die horribly.
    $log->logconfess(
    "The position passed as a parameter can only be between 
		0 and $genotypeMaxPos ($position inserted)"
    ) if ( ( $position > $genotypeMaxPos ) or ( $position < 0 ) );

    $genotype[$position] = $value;

    # Modify the field genotype inside the hash that contains it
    $this->{genotype} = \@genotype;

    $log->info(
        "Setting gen in position $position from genotype (@genotype) to $value"
    );

    return 1;
}    ## --- end sub setGen

#===  CLASS METHOD  ============================================================
#        CLASS: BitVector
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

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE HASH OF FIELDS
    my $this = shift;

    # Take the arguments and put them in proper variables
    my ($position) = @_;

    # Get the genotype dereferencing the $this hash
    my %hash        = %$this;
    my $genotypeRef = $hash{genotype};
    my @genotype    = @$genotypeRef;

    my $genotypeMaxPos = scalar(@genotype) - 1;

    # If the position is something lower than 0 or bigger than the genotype
    # size, die horribly.
    $log->logconfess(
    "The position passed as a parameter can only be between 
		0 and $genotypeMaxPos ($position inserted)"
    ) if ( ( $position > $genotypeMaxPos ) or ( $position < 0 ) );

    my $gen = $genotype[$position];

    return $gen;
}    ## --- end sub getGen

#===  CLASS METHOD  ============================================================
#        CLASS: BitVector
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

    # Take the arguments and put them in proper variables
    my ($position) = @_;

    # Get the genotype dereferencing the $this hash
    my %hash        = %$this;
    my $genotypeRef = $hash{genotype};
    my @genotype    = @$genotypeRef;

    return scalar(@genotype);
}    ## --- end sub getLength

#===  CLASS METHOD  ============================================================
#        CLASS: BitVector
#       METHOD: changeGen
#   PARAMETERS: position -> indicates the position of the gen that will change.
#      RETURNS: 1 if the operation was performed successfully. 0 otherwise.
#  DESCRIPTION: Changes the value of the gen given by the position. Used for
#               mutation purposes only.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub changeGen {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE HASH OF FIELDS
    my $this = shift;

    # Take the arguments and put them in proper variables
    my ($position) = @_;

    # Get the genotype dereferencing the $this hash
    my %hash        = %$this;
    my $genotypeRef = $hash{genotype};
    my @genotype    = @$genotypeRef;

    my $genotypeMaxPos = scalar(@genotype) - 1;

    $log->info("Going to flip bit $position on genotype (@genotype)");

    # If the position is something lower than 0 or bigger than the genotype
    # size, die horribly.
    $log->logconfess(
    "The position passed as a parameter can only be between 
		0 and $genotypeMaxPos ($position inserted)"
    ) if ( ( $position > $genotypeMaxPos ) or ( $position < 0 ) );

    if ( $genotype[$position] == 1 ) {
        $genotype[$position] = 0;
    }
    else {
        $genotype[$position] = 1;
    }

    # Modify the field genotype inside the hash that contains it
    $this->{genotype} = \@genotype;

    $log->info("Result of the change: (@genotype)");

    return 1;
}    ## --- end sub changeGen

#===  CLASS METHOD  ============================================================
#        CLASS: BitVector
#       METHOD: getRanges
#   PARAMETERS: None
#      RETURNS: A list containing the possible values for a gen.
#  DESCRIPTION: Asks for all the possible values for the gens in the genotype.
#       THROWS: no exceptions
#     COMMENTS: none
#===============================================================================
sub getRanges {

    my @ranges = (0,1);
    return @ranges;

}    ## --- end sub getRanges

1;
