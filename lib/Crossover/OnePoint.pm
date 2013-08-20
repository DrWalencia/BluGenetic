#
#===============================================================================
#
#         FILE: OnePoint.pm
#
#  DESCRIPTION: Concrete implementation of the CrossoverStrategy interface
#               comprising the one point crossover technique, which consists on
#               defining a random cut position (which will be the same for
#               both individuals) and split them and put the first half of the
#               first individual with the second half of the other and the
#               other way around.
#
#       AUTHOR: Pablo Valencia González (PVG), valeng.pablo@gmail.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/22/2013 09:25:14 PM
#===============================================================================

package OnePoint;

use strict;
use warnings;
use diagnostics;

use Log::Log4perl qw(get_logger);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("OnePoint");

# Avoid warnings regarding class method overriding
no warnings 'redefine';

# OnePoint inherits from Crossover::CrossoverStrategy
use Crossover::CrossoverStrategy;
use base qw(CrossoverStrategy);

# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields 'indOne', 'indTwo',    # The two individuals to be mated.
  'cutPoint',          # The cut point randomly generated.
  'manualCutPoint',    # Stores cut point manually set.
  'cutPointset';       # Stoes if the manual cut point has been  set or not.

#===  FUNCTION  ================================================================
#         NAME: new
#      PURPOSE: Creates a newly allocated OnePoint crossover strategy.
#   PARAMETERS: None.
#      RETURNS: A reference to the instance just created.
#       THROWS: no exceptions
#===============================================================================
sub new {

    # Every method of a class passes first argument as class name
    my $class = shift;

    # Anonymous hash to store instance variables (AKA FIELDS)
    my $this = {};

    # When a OnePoint strategy is created, its cut point is unset
    $this->{cutPointSet} = 0;

    # Connect a class name with a hash is known as blessing an object
    bless $this, $class;

    $log->info("Newly allocated OnePoint crossover strategy created");

    return $this;
}    ## --- end sub new

#===  CLASS METHOD  ============================================================
#        CLASS: OnePoint
#       METHOD: setCutPoint
#   PARAMETERS: point -> The cut point.
#      RETURNS: Nothing
#  DESCRIPTION: Manually sets the cut point for the crossover operation. For
#               testing purposes only.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub setCutPoint {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
    my $this = shift;

    # Retrieve parameters...
    my ($point) = @_;

    $this->{manualCutPoint} = $point;
    $this->{cutPointSet}    = 1;

    $log->info("Cut point for crossover defined: $point");

    return;
}

#===  CLASS METHOD  ============================================================
#        CLASS: OnePoint
#       METHOD: _getProperGenotype
#   PARAMETERS: this -> The crossover strategy in which the decision of
#               instantiate one type of genotype or another is based on.
#      RETURNS: An instance of the proper Genotype type (BitVector, ListVector
#               or RangeVector)
#  DESCRIPTION: Factory method to instantiate the proper Genotype type based
#               on the type of genotype of the individuals passed to the
#               crossover strategy.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub _getProperGenotype {

    # Get the parameter (THIS IS A PRIVATE METHOD)
    my $this = shift;

    my $genotype;
    my $length    = $this->{indOne}->getGenotype()->getLength();
    my $rangesRef = $this->{indOne}->getGenotype()->getRanges();

    if ( $this->{indOne}->getGenotype()->isa("BitVector") ) {
        $genotype = BitVector->new( $length );
        $log->info("Factory method to get proper genotype called (BitVector)");
    }
    elsif ( $this->{indOne}->getGenotype()->isa("RangeVector") ) {
        $genotype = RangeVector->new( @$rangesRef );
        $log->info(
            "Factory method to get proper genotype called (RangeVector)");
    }
    elsif ( $this->{indOne}->getGenotype()->isa("ListVector") ) {
        $genotype = ListVector->new( @$rangesRef );
        $log->info("Factory method to get proper genotype called (ListVector)");
    }
    else {
        $log->logconfess(
            "Trying to perform crossover on an unrecognized genotype type");
    }

    return $genotype;
}

#===  CLASS METHOD  ============================================================
#        CLASS: OnePoint
#       METHOD: _getProperIndividual
#   PARAMETERS: this -> The crossover strategy in which the decision of
#               instantiate one type of genotype or another is based on.
#      RETURNS: An instance of the an individual with the proper genotype
#               type (BitVector, ListVector or RangeVector)
#  DESCRIPTION: Factory method to instantiate the proper Genotype type based
#               on the type of genotype of the individuals passed to the
#               crossover strategy.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub _getProperIndividual {

    # Get the parameter (THIS IS A PRIVATE METHOD)
    my $this = shift;

    my $individual;

    my $length    = $this->{indOne}->getGenotype()->getLength();
    my $rangesRef = $this->{indOne}->getGenotype()->getRanges();

    if ( $this->{indOne}->getGenotype()->isa("BitVector") ) {
        $individual = Individual->new( genotype => BitVector->new($length) );
        $log->info(
            "Factory method to get proper individual called (BitVector)");
    }
    elsif ( $this->{indOne}->getGenotype()->isa("RangeVector") ) {
        $individual =
          Individual->new( genotype => RangeVector->new(@$rangesRef) );
        $log->info(
            "Factory method to get proper individual called (RangeVector)");
    }
    elsif ( $this->{indOne}->getGenotype()->isa("ListVector") ) {
        $individual =
          Individual->new( genotype => ListVector->new(@$rangesRef) );
        $log->info(
            "Factory method to get proper individual called (ListVector)");
    }
    else {
        $log->logconfess(
            "Trying to perform crossover on an unrecognized genotype type");
    }

    return $individual;
}

#===  CLASS METHOD  ============================================================
#        CLASS: OnePoint
#       METHOD: crossIndividuals
#   PARAMETERS: individualOne -> The first individual to be mated
#               individualTwo -> The second individual to be mated
#      RETURNS: A vector of individuals containing the offspring of those
#               passed as parameters.
#  DESCRIPTION: Crosses a couple of individuals of the same length following
#               the one-point techniques
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub crossIndividuals {

    # EVERY METHOD OF A 
    my $this = shift;

    # Retrieve parameters...
    my ( $individualOne, $individualTwo ) = @_;

    # Die horribly if any of them is undefined
    $log->logconfess("First individual undefined")
      if ( !( defined $individualOne ) );
    $log->logconfess("Second individual undefined")
      if ( !( defined $individualTwo ) );

    # Also die if any of them do not have a proper genotype to operate with
    $log->logconfess("Genotype of first individual undefined")
      if ( !( defined $individualOne->getGenotype() ) );
    $log->logconfess("Genotype of second individual undefined")
      if ( !( defined $individualTwo->getGenotype() ) );

    # If everything is in order, proceed...
    $this->{indOne} = $individualOne;
    $this->{indTwo} = $individualTwo;

    # If the length of the genotype is less than two, nothing has to
    # be done
    if ( $this->{indOne}->getGenotype()->getLength() < 2 ) {
        my @v;
        push @v, $this->{indOne};
        push @v, $this->{indTwo};
        return @v;
    }

    # Set cut point...
    if ( $this->{cutPointSet} == 0 ) {

        # Select  cutPoint=random number between 0 and k-1 being
        # k=length of individual. 2 must be subtracted from the
        # genotype length because there are length()-1 cut points
        # and the indexes go from 0 to length()-1
        $this->{cutPoint} =
          int( rand( $this->{indOne}->getGenotype()->getLength() - 2 ) );
    }
    else {
        # Manual cut point set up for testing purposes
        $this->{cutPoint} = $this->{manualCutPoint};
    }

    # Instantiate the needed genotypes...
    my $genotypeChild1 = _getProperGenotype($this);
    my $genotypeChild2 = _getProperGenotype($this);

    # Instantiate the needed individuals..
    my $child1 = _getProperIndividual($this);
    my $child2 = _getProperIndividual($this);

    # Child one: from 0 to cutPoint individual one, from cutPoint+1 to
    # k individual two
    # Child two: from 0 to cutPoint individual two, from cutPoint+1 to
    # k individual one

    # First part of the children...
    for ( my $i = 0 ; $i <= $this->{cutPoint} ; $i++ ) {
        $genotypeChild1->setGen( $i,
            $this->{indOne}->getGenotype()->getGen($i) );
        $genotypeChild2->setGen( $i,
            $this->{indTwo}->getGenotype()->getGen($i) );
    }

    # And second...
    for (
        my $j = $this->{cutPoint} + 1 ;
        $j < $this->{indOne}->getGenotype()->getLength() ;
        $j++
      )
    {
        $genotypeChild1->setGen( $j,
            $this->{indTwo}->getGenotype()->getGen($j) );
        $genotypeChild2->setGen( $j,
            $this->{indOne}->getGenotype()->getGen($j) );
    }

    # Populate new Individuals to put the calculated genotypes..
    for ( my $k = 0 ; $k < $this->{indOne}->getGenotype()->getLength() ; $k++ )
    {
        $child1->getGenotype()->setGen( $k, $genotypeChild1->getGen($k) );
        $child2->getGenotype()->setGen( $k, $genotypeChild2->getGen($k) );
    }

    # Put their respective scores to zero. SCORE FOR THIS TWO MUST
    # BE RECALCULATED AGAIN
    $child1->setScore(0);
    $child2->setScore(0);

    # Create a vector of individuals and return the children
    # using it
    my @v;
    push @v, $child1;
    push @v, $child2;
    return @v;

}    ## --- end sub crossIndividuals

__END__

=head1 DESCRIPTION

Concrete implementation of the CrossoverStrategy interface
comprising the one point crossover technique, which consists on
defining a random cut position (which will be the same for
both individuals) and split them and put the first half of the
first individual with the second half of the other and the
other way around.

=head1 METHODS

    #===  FUNCTION  ================================================================
    #         NAME: new
    #      PURPOSE: Creates a newly allocated OnePoint crossover strategy.
    #   PARAMETERS: None.
    #      RETURNS: A reference to the instance just created.
    #       THROWS: no exceptions
    #===============================================================================

    #===  CLASS METHOD  ============================================================
    #        CLASS: OnePoint
    #       METHOD: setCutPoint
    #   PARAMETERS: point -> The cut point.
    #      RETURNS: Nothing
    #  DESCRIPTION: Manually sets the cut point for the crossover operation. For
    #               testing purposes only.
    #       THROWS: no exceptions
    #     COMMENTS: none
    #     SEE ALSO: n/a
    #===============================================================================

    #===  CLASS METHOD  ============================================================
    #        CLASS: OnePoint
    #       METHOD: _getProperGenotype
    #   PARAMETERS: this -> The crossover strategy in which the decision of
    #               instantiate one type of genotype or another is based on.
    #      RETURNS: An instance of the proper Genotype type (BitVector, ListVector
    #               or RangeVector)
    #  DESCRIPTION: Factory method to instantiate the proper Genotype type based
    #               on the type of genotype of the individuals passed to the
    #               crossover strategy.
    #       THROWS: no exceptions
    #     COMMENTS: none
    #     SEE ALSO: n/a
    #===============================================================================

    #===  CLASS METHOD  ============================================================
    #        CLASS: OnePoint
    #       METHOD: _getProperIndividual
    #   PARAMETERS: this -> The crossover strategy in which the decision of
    #               instantiate one type of genotype or another is based on.
    #      RETURNS: An instance of the an individual with the proper genotype
    #               type (BitVector, ListVector or RangeVector)
    #  DESCRIPTION: Factory method to instantiate the proper Genotype type based
    #               on the type of genotype of the individuals passed to the
    #               crossover strategy.
    #       THROWS: no exceptions
    #     COMMENTS: none
    #     SEE ALSO: n/a
    #===============================================================================

    #===  CLASS METHOD  ============================================================
    #        CLASS: OnePoint
    #       METHOD: crossIndividuals
    #   PARAMETERS: individualOne -> The first individual to be mated
    #               individualTwo -> The second individual to be mated
    #      RETURNS: A vector of individuals containing the offspring of those
    #               passed as parameters.
    #  DESCRIPTION: Crosses a couple of individuals of the same length following
    #               the one-point techniques
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

1;   # Required for all packages in Perl
