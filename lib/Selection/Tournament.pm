#
#===============================================================================
#
#         FILE: Tournament.pm
#
#  DESCRIPTION: Concrete implementation of the selection strategy Interface
#               comprising comprising the Tournament selection technique
#               which consists on selecting small subsets of individuals and
#               among them the fittest of each one will become part of the
#               selected group.
#
#       AUTHOR: Pablo Valencia González (PVG), valeng.pablo@gmail.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/24/2013 12:10:19 AM
#===============================================================================

package Tournament;

use strict;
use warnings;
use diagnostics;

use Log::Log4perl qw(get_logger);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("Tournament");

# Avoid warnings regarding class method overriding
no warnings 'redefine';

# Tournament inherits from Selection::SelectionStrategy
use Selection::SelectionStrategy;
use base qw(SelectionStrategy);

# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields
  'numberOfIndividuals';    # Number of individuals that are going to fight
                            # till death.

#===  CLASS METHOD  ============================================================
#        CLASS: Tournament
#       METHOD: battlefieldSize
#   PARAMETERS: numOfInd -> the amount of individuals that will fight
#               till death.
#      RETURNS: A reference to the instance just created.
#  DESCRIPTION:	Sets size of the battlefield (other than 2)
#===============================================================================
sub battlefieldSize {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
    my ( $this, $numOfInd ) = @_;

    # If numOfInd is undefined, die painfully
    $log->logconfess("Undefined amount of individuals")
      if ( !( defined $numOfInd ) );

    # If the number of individuals is 0 or negative, die painfully.
    $log->logconfess(
        "Incorrect number of individuals for Tournament: $numOfInd")
      if ( $numOfInd <= 0 );

    $this->{numberOfIndividuals} = $numOfInd;

    return;
}

#===  CLASS METHOD  ============================================================
#        CLASS: Tournament
#       METHOD: new
#   PARAMETERS: numOfInd -> the amount of individuals that will fight
#               till death.
#      RETURNS: A reference to the instance just created.
#  DESCRIPTION:	Creates a newly allocated Tournament selection strategy.
#===============================================================================
sub new {

    $log->info("Creation of a new Tournament selection strategy started.");

    # Every method of a class passes first argument as class name
    my $class = shift;

    # Take the argument (number of individuals on each round)
    my $numOfInd = shift;

    # Anonymous hash to store instance variables (AKA FIELDS)
    # Set default value for numberOfIndividuals. If wanted to be
    # changed, use the battlefieldSize method.
    my $this = { numberOfIndividuals => 2 };

    # Connect class name with hash is known as blessing an object
    bless $this, $class;

    $log->info("Creation of a new Tournament selection strategy finished.");

    return $this;
}    ## --- end sub new

#===  CLASS METHOD  ============================================================
#        CLASS: Tournament
#       METHOD: _fetchWinner
#   PARAMETERS: battlefield -> the set of individuals that'll fight till death.
#      RETURNS: An individual who is the winner of the tournament.
#  DESCRIPTION: Given a battlefield, act as a referee and decide who won.
#     COMMENTS: THIS IS A PRIVATE METHOD
#===============================================================================
sub _fetchWinner {

    # Take the arguments..
    my (@battlefield) = shift;

    my $winner = pop @battlefield;

    # While the battlefield is not empty...
    while (@battlefield) {

        my $ind = pop @battlefield;

        if ( $ind->getScore() > $winner->getScore() ) {
            $winner = $ind;
        }
    }

    return $winner;
}    ## --- end sub fetchWinner

#===  CLASS METHOD  ============================================================
#        CLASS: Tournament
#       METHOD: performSelection
#   PARAMETERS: population -> the population on which the selection must be based
#               on.
#      RETURNS: a list containing the result of the selection process.
#  DESCRIPTION: Performs the Tournament selection technique.
#===============================================================================
sub performSelection {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
    my ( $this, @population ) = @_;

    # Vector of individuals to be returned
    my @returnPopulation;

    # Place where the individuals are going to fight till death
    my @battlefield;

    # Now let's PLAY...
    while ( @returnPopulation < @population ) {

        # Throw a subset of individuals into the battlefield
        while ( @battlefield < $this->{numberOfIndividuals} ) {
            push @battlefield, $population[ int( rand(@population) ) ];
        }

        # Take the only survivior and put it into the population to
        # be returned.
        my $winner = _fetchWinner(@battlefield);

        # Remove dead bodies from the battlefield
        undef @battlefield;

        # And give to the winner a passport to the next level
        push @returnPopulation, $winner;
    }

    return @returnPopulation;
}    ## --- end sub performSelection

__END__

=head1 DESCRIPTION

Concrete implementation of the selection strategy Interface
comprising comprising the Tournament selection technique
which consists on selecting small subsets of individuals and
among them the fittest of each one will become part of the
selected group.

=head1 METHODS

    #===  CLASS METHOD  ============================================================
    #        CLASS: Tournament
    #       METHOD: battlefieldSize
    #   PARAMETERS: numOfInd -> the amount of individuals that will fight
    #               till death.
    #      RETURNS: A reference to the instance just created.
    #  DESCRIPTION: Sets size of the battlefield (other than 2)
    #===============================================================================

    #===  CLASS METHOD  ============================================================
    #        CLASS: Tournament
    #       METHOD: new
    #   PARAMETERS: numOfInd -> the amount of individuals that will fight
    #               till death.
    #      RETURNS: A reference to the instance just created.
    #  DESCRIPTION: Creates a newly allocated Tournament selection strategy.
    #===============================================================================

    #===  CLASS METHOD  ============================================================
    #        CLASS: Tournament
    #       METHOD: _fetchWinner
    #   PARAMETERS: battlefield -> the set of individuals that'll fight till death.
    #      RETURNS: An individual who is the winner of the tournament.
    #  DESCRIPTION: Given a battlefield, act as a referee and decide who won.
    #     COMMENTS: THIS IS A PRIVATE METHOD
    #===============================================================================

    #===  CLASS METHOD  ============================================================
    #        CLASS: Tournament
    #       METHOD: performSelection
    #   PARAMETERS: population -> the population on which the selection must be based
    #               on.
    #      RETURNS: a list containing the result of the selection process.
    #  DESCRIPTION: Performs the Tournament selection technique.
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

1;   # Required for all packages in Perl
