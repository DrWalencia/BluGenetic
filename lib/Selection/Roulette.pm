#
#===============================================================================
#
#         FILE: Roulette.pm
#
#  DESCRIPTION: Concrete implementation of the selection strategy Interface
#               comprising the Roulette selection technique, which consists
#               on giving to each individual a chance of being selected
#               proportional to its fitness value. This way fitter individuals
#               are more prone to be selected.
#
#       AUTHOR: Pablo Valencia González (PVG), valeng.pablo@gmail.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/24/2013 12:10:19 AM
#===============================================================================

package Roulette;

use strict;
use warnings;
use diagnostics;

use Log::Log4perl qw(get_logger);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("Roulette");

# Avoid warnings regarding class method overriding
no warnings 'redefine';

# Roulette inherits from Selection::SelectionStrategy
use Selection::SelectionStrategy;
use base qw(SelectionStrategy);

# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields 'population',    # population passed as a parameter
  'returnPopulation',       # population to be returned
  'sortedNormalizedPop';    # stored for debugging purposes

#===  CLASS METHOD  ============================================================
#        CLASS: Roulette
#       METHOD: new
#   PARAMETERS: None.
#      RETURNS: A reference to the instance just created.
#  DESCRIPTION:	Creates a newly allocated Roulette selection strategy.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub new {

    # Every method of a class passes first argument as class name
    my $class = shift;

    # Anonymous hash to store instance variables (AKA FIELDS)
    my $this = {};

    # Connect class name with hash is known as blessing an object
    bless $this, $class;

    return $this;
}    ## --- end sub new

#===  CLASS METHOD  ============================================================
#        CLASS: Roulette
#       METHOD: performSelection
#   PARAMETERS: population -> the population on which the selection must be based
#               on.
#      RETURNS: a list containing the result of the selection process.
#  DESCRIPTION: Performs the Roulette selection technique.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub performSelection {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
    my $this = shift;

    # Get the parameters...
    my @population = @_;

    undef $this->{sortedNormalizedPop};

    $log->logconfess("Trying to perform selection over an empty population.")
      if ( !(@population) );

    # Let's make a copy of the current population into a new vector of
    # individuals
    my @normalizedPop       = @population;
    my @toBeSelectedFromPop = @population;
    my @sortedNormalizedPop;

    # Normalize fitness values, which is to make the scores fall into a
    # range from 0 to 1

    # Sum of all fitness values...
    my $accSumFitness = 0;
    for ( my $i = 0 ; $i < @normalizedPop ; $i++ ) {
        $accSumFitness += $normalizedPop[$i]->getScore();
    }

    # And set them to their respective individuals...
    for ( my $i = 0 ; $i < @normalizedPop ; $i++ ) {
        my $oldScore        = $normalizedPop[$i]->getScore();
        my $normalizedScore = $oldScore / $accSumFitness;

        $normalizedPop[$i]->setScore($normalizedScore);
    }

    # Sort the population to be selected from by DESCENDING
    # fitness values
    @toBeSelectedFromPop =
      sort { $b->getScore() <=> $a->getScore() } @toBeSelectedFromPop;

    # Sort the normalized population by DESCENDING fitness
    # values
    @normalizedPop = sort { $b->getScore() <=> $a->getScore() } @normalizedPop;

    my $accumulated;

    # Calculate accumulated fitness values (the accumulated fitness value
    # of a given individual is the sum of its own fitness value plus the
    # fitness values of all the previous individuals). Obviously, the
    # accumulated fitness value of the last element must be 1 (otherwise
    # a mistake was made while normalizing scores)

    for ( my $m = 0 ; $m < @normalizedPop ; $m++ ) {

        $accumulated = 0;

        for ( my $n = $m ; $n >= 0 ; $n-- ) {
            $accumulated += $normalizedPop[$n]->getScore();
        }

        my $aux = $normalizedPop[$m];
        $aux->setScore($accumulated);

        push @sortedNormalizedPop, $aux;

    }

    $this->{sortedNormalizedPop} = \@sortedNormalizedPop;

    # Set of individuals returned as a product of the selection algorithm
    my @returnPop;

    # Now we repeat the following till we fill the new population.
    # Note that elements are to be taken from sortedPop rather than
    # from sortedNormalizedPop

    for ( my $o = 0 ; $o < @sortedNormalizedPop ; $o++ ) {

        # Choose a random value between 0 and 1 (technically 0.99)
        my $seed   = int( rand(100) );
        my $random = $seed / 100;

        # The selected individual is the first one whose accumulated
        # normalized score value is greater than the previous
        # random number.
        my $index = 0;

        while ( $sortedNormalizedPop[$index]->getScore() < $random ) {
            $index++;
        }

        push @returnPop, $toBeSelectedFromPop[$index];
    }

    return @returnPop;
}    ## --- end sub performSelection

#===  CLASS METHOD  ============================================================
#        CLASS: Roulette
#       METHOD: getSortedNormalizedPop
#   PARAMETERS: none
#      RETURNS: The sorted normalized population generated by the algorithm.
#  DESCRIPTION: Returns an internal data structure of the Roulette Selection
#               algorithm. For debugging purposes only.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getSortedNormalizedPop {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
    my $this      = shift;
    my $reference = $this->{sortedNormalizedPop};

    return @$reference;
}

__END__

=head1 DESCRIPTION

Concrete implementation of the selection strategy Interface
comprising the Roulette selection technique, which consists
on giving to each individual a chance of being selected
proportional to its fitness value. This way fitter individuals
are more prone to be selected.

=head1 METHODS

    #===  CLASS METHOD  ============================================================
    #        CLASS: Roulette
    #       METHOD: new
    #   PARAMETERS: None.
    #      RETURNS: A reference to the instance just created.
    #  DESCRIPTION: Creates a newly allocated Roulette selection strategy.
    #       THROWS: no exceptions
    #     COMMENTS: none
    #     SEE ALSO: n/a
    #===============================================================================

    #===  CLASS METHOD  ============================================================
    #        CLASS: Roulette
    #       METHOD: performSelection
    #   PARAMETERS: population -> the population on which the selection must be based
    #               on.
    #      RETURNS: a list containing the result of the selection process.
    #  DESCRIPTION: Performs the Roulette selection technique.
    #       THROWS: no exceptions
    #     COMMENTS: none
    #     SEE ALSO: n/a
    #===============================================================================

    #===  CLASS METHOD  ============================================================
    #        CLASS: Roulette
    #       METHOD: getSortedNormalizedPop
    #   PARAMETERS: none
    #      RETURNS: The sorted normalized population generated by the algorithm.
    #  DESCRIPTION: Returns an internal data structure of the Roulette Selection
    #               algorithm. For debugging purposes only.
    #       THROWS: no exceptions
    #     COMMENTS: none
    #     SEE ALSO: n/a
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

1;    # Required for all packages in Perl
