#
#===============================================================================
#
#         FILE: Individual.pm
#
#  DESCRIPTION: Class that represents an Individual of a given population. It
#               is comprised by a genotype and its score.
#
#       AUTHOR: Pablo Valencia González (PVG), valeng.pablo@gmail.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/24/2013 07:44:53 PM
#===============================================================================

package Individual;

use strict;
use warnings;
use diagnostics;

use Log::Log4perl qw(get_logger);

# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields 'score',    # FLOAT the score of the individual.
  'genotype',          # REFERENCE the genotype of the individual.
  'scoreSet';          # BOOLEAN 1 if the score is set, 0 otherwise.

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("Individual");

#=== FUNCTION  =================================================================
#         NAME: new
#      PURPOSE: Creates a newly allocated Individual.
#
# PARAMETERS_1: None (NEITHER SCORE NOR GENOTYPE)
#
# PARAMETERS_2: genotype    -> the genotype of the individual (NO SCORE)
#
# PARAMETERS_3: score       -> the score of the individual
#               genotype    -> the genotype of the individual
#
#      RETURNS: A reference to the instance just created.
#     COMMENTS: PARAMETERS INTRODUCED VIA ANONYMOUS HASH
#===============================================================================
sub new {

    my ( $class, %args ) = @_
      ; # Every method of a class passes as the first argument the hash of fields.

    # Anonymous hash to store instance variables (AKA FIELDS)
    my $this;

    my $numberOfKeys = scalar keys %args;

    $log->info("Arguments passed inside a hash: $numberOfKeys");

    # Three cases of new are valid, according to the method signature.
    if ( $numberOfKeys == 2 ) {
        $log->logconfess("Cannot create an individual with undefined genotype")
          if ( !( defined $args{genotype} ) );

        $log->info("Creation of a new individual with two arguments started.");
        $this = {
            score    => $args{score},
            genotype => $args{genotype},
            scoreSet => 1
        };

    }
    elsif ( $numberOfKeys == 1 ) {

        $log->logconfess("Cannot create an individual with undefined genotype")
          if ( !( defined $args{genotype} ) );

        $log->logconfess("Cannot create an individual just with the score")
          if ( !( exists $args{genotype} ) );

        $log->info("Creation of a new individual with one argument started.");
        $this = {
            genotype => $args{genotype},
            scoreSet => 0
        };

    }
    else {

        $log->info("Creation of a new individual with zero arguments started.");
        $this = { scoreSet => 0 };
    }

    # Connect a class name with a hash is known as blessing an object
    bless $this, $class;

    $log->info("Creation of a new individual finished.");

    return $this;
}    ## --- end sub new

#===  CLASS METHOD  ============================================================
#        CLASS: Individual
#       METHOD: getScore
#   PARAMETERS: None.
#      RETURNS: FLOAT the score store in the individual as a field.
#  DESCRIPTION: Getter for the score of the individual.
#===============================================================================
sub getScore {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE HASH OF FIELDS
    my $this = shift;

    # Get the genotype dereferencing the $this hash
    my %hash  = %$this;
    my $score = $hash{score};

    # Careful! the genotype is an object too, so its info must be dereferenced
    # too.
    my $genotype        = $hash{genotype};
    my $genotypeListRef = $genotype->{genotype};

    $log->info("Score returned for individual (@$genotypeListRef): $score");

    return $score;
}    ## --- end sub getScore

#===  CLASS METHOD  ============================================================
#        CLASS: Individual
#       METHOD: setScore
#   PARAMETERS: newScore -> the score to be set.
#      RETURNS: Nothing.
#  DESCRIPTION: Setter for the score of the individual.
#     COMMENTS: NEGATIVE SCORES ARE NOT ACCEPTED
#===============================================================================
sub setScore {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE HASH OF FIELDS
    my $this = shift;

    # Take the score passed as a parameter
    my $score = shift;

    $log->logconfess("Cannot set a negative score on an individual")
      if ( $score < 0 );

    my %hash = %$this;

    # Careful! the genotype is an object too, so its info must be dereferenced
    # too.
    my $genotype        = $hash{genotype};
    my $genotypeListRef = $genotype->{genotype};

    $log->info(
        "Score set ($score) on individual with genotype (@$genotypeListRef)");

    # Set the score
    $this->{score} = $score;

    return 1;
}    ## --- end sub setScore

#===  CLASS METHOD  ============================================================
#        CLASS: Individual
#       METHOD: scoreSet
#   PARAMETERS: None.
#      RETURNS: 1 if the score has been set, 0 otherwise.
#  DESCRIPTION: Checks if the score has been calculated.
#===============================================================================
sub scoreSet {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE HASH OF FIELDS
    my $this = shift;

    # Get the genotype dereferencing the $this hash
    my %hash     = %$this;
    my $scoreSet = $hash{scoreSet};

    $log->info(
        "Checked if the score was set for an individual 
        . Result: $scoreSet"
    );

    return $scoreSet;

}    ## --- end sub scoreSet

#===  CLASS METHOD  ============================================================
#        CLASS: Individual
#       METHOD: getGenotype
#   PARAMETERS: None.
#      RETURNS: REFERENCE the genotype of the individual.
#  DESCRIPTION: Getter for the genotype.
#       THROWS: no exceptions
#     COMMENTS: WARNING: The actual genotype is returned. Changes will be
#               reflected in the algorithm.
#===============================================================================
sub getGenotype {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE HASH OF FIELDS
    my $this = shift;

    # Get the genotype dereferencing the $this hash
    my %hash = %$this;

    # Careful! the genotype is an object too, so its info must be dereferenced
    # too.
    my $genotype        = $hash{genotype};
    my $genotypeListRef = $genotype->{genotype};

    $log->info(
        "Returned a REFERENCE to the genotype of the individual with
        genotype (@$genotypeListRef) "
    );

    return $this->{genotype};

}    ## --- end sub getGenotype

#=== CLASS METHOD  =============================================================
#        CLASS: Individual
#       METHOD: setGenotype
#   PARAMETERS: REFERENCE the genotype of the individual.
#      RETURNS: Nothing.
#  DESCRIPTION: Setter for the genotype.
#     COMMENTS: none
#===============================================================================
sub setGenotype {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE HASH OF FIELDS
    my $this = shift;

    # Get the argument
    my $genotype = shift;

    $log->logconfess("Cannot set an undefined genotype")
      if ( !( defined $genotype ) );

    $this->{genotype} = $genotype;

    return 1;
}    ## --- end sub setGenotype

__END__

=head1 DESCRIPTION

Class that represents an Individual of a given population. It
is comprised by a genotype and its score.

=head1 METHODS

    #=== FUNCTION  =================================================================
    #         NAME: new
    #      PURPOSE: Creates a newly allocated Individual.
    #
    # PARAMETERS_1: None (NEITHER SCORE NOR GENOTYPE)
    #
    # PARAMETERS_2: genotype    -> the genotype of the individual (NO SCORE)
    #
    # PARAMETERS_3: score       -> the score of the individual
    #               genotype    -> the genotype of the individual
    #
    #      RETURNS: A reference to the instance just created.
    #     COMMENTS: PARAMETERS INTRODUCED VIA ANONYMOUS HASH
    #===============================================================================

    #===  CLASS METHOD  ============================================================
    #        CLASS: Individual
    #       METHOD: getScore
    #   PARAMETERS: None.
    #      RETURNS: FLOAT the score store in the individual as a field.
    #  DESCRIPTION: Getter for the score of the individual.
    #===============================================================================

    #===  CLASS METHOD  ============================================================
    #        CLASS: Individual
    #       METHOD: setScore
    #   PARAMETERS: newScore -> the score to be set.
    #      RETURNS: Nothing.
    #  DESCRIPTION: Setter for the score of the individual.
    #     COMMENTS: NEGATIVE SCORES ARE NOT ACCEPTED
    #===============================================================================

    #===  CLASS METHOD  ============================================================
    #        CLASS: Individual
    #       METHOD: scoreSet
    #   PARAMETERS: None.
    #      RETURNS: 1 if the score has been set, 0 otherwise.
    #  DESCRIPTION: Checks if the score has been calculated.
    #===============================================================================

    #===  CLASS METHOD  ============================================================
    #        CLASS: Individual
    #       METHOD: getGenotype
    #   PARAMETERS: None.
    #      RETURNS: REFERENCE the genotype of the individual.
    #  DESCRIPTION: Getter for the genotype.
    #     COMMENTS: WARNING: The actual genotype is returned. Changes will be 
    #               reflected in the algorithm.
    #===============================================================================

    #=== CLASS METHOD  =============================================================
    #        CLASS: Individual
    #       METHOD: setGenotype
    #   PARAMETERS: REFERENCE the genotype of the individual.
    #      RETURNS: Nothing.
    #  DESCRIPTION: Setter for the genotype.
    #===============================================================================

=head1 AUTHOR

Pablo Valencia Gonzalez, C<< <valeng.pablo at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<valeng.pablo at gmail.com>.

=head1 ACKNOWLEDGEMENTS

Special thanks to Julian Orfo and Hector Diez. The former because its 
collaboration on an early version written in other language and the latter
for stimulating discussion and provide good suggestions.

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Pablo Valencia Gonzalez.

This module is distributed under the same terms as Perl itself.

=cut

1;
