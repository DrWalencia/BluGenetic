#
#===============================================================================
#
#         FILE: Uniform.pm
#
#  DESCRIPTION: Concrete implementation of the CrossStrategy interface
#               comprising the uniform crossover technique, which consists on
#               selecting one gen per parent for each one of the offspring.
#
#       AUTHOR: Pablo Valencia González (PVG), valeng.pablo@gmail.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/22/2013 09:25:14 PM
#===============================================================================

package Uniform;

use strict;
use warnings;
use diagnostics;

use Log::Log4perl qw(get_logger);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("OnePoint");

# Avoid warnings regarding class method overriding
no warnings 'redefine';

# Uniform inherits from Crossover::CrossoverStrategy
use Crossover::CrossoverStrategy;
use base qw(CrossoverStrategy);

# List of ALLOWED fields for this class. If other files are tried to be used,
# the program will horribly crash.
use fields 'indOne', 'indTwo';    # The two individuals to be mated.

#===  FUNCTION  ================================================================
#         NAME: new
#      PURPOSE: Creates a newly allocated Uniform crossover strategy.
#   PARAMETERS: None.
#      RETURNS: A reference to the instance just created.
#       THROWS: no exceptions
#===============================================================================
sub new {

    # Every method of a class passes first argument as class name
    my $class = shift;

    # Anonymous hash to store instance variables (AKA FIELDS)
    my $this = {};

    # Connect a class name with a hash is known as blessing an object
    bless $this, $class;

    $log->info("Newly created Uniform crossover strategy created");

    return $this;
}    ## --- end sub new

#=== CLASS METHOD  ============================================================
#        CLASS: Uniform
#       METHOD: _randomSel
#   PARAMETERS: position -> the position of the gen.
#      RETURNS: the value of the selected gen.
#  DESCRIPTION: For a given position select randomly which parent a given gen
#               is selected from.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub _randomSel {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
    my $this = shift;

    # Get the argument...
    my $position = shift;

    my $seed = int( rand(2) );

    my $returnValue;

    if ( $seed == 0 ) {
        $returnValue = $this->{indOne}->getGenotype()->getGen($position);
        $log->info( "Selected bit ", $position, " from individual One" );
    }
    else {
        $returnValue = $this->{indTwo}->getGenotype()->getGen($position);
        $log->info( "Selected bit ", $position, " from individual Two" );
    }
    return $returnValue;
}

#=== CLASS METHOD  ============================================================
#        CLASS: Uniform
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

    if ( $this->{indOne}->getGenotype()->isa("BitVector") ) {
        $genotype =
          BitVector->new( $this->{indOne}->getGenotype()->getLength() );
        $log->info("Factory method to get proper genotype called (BitVector)");
    }
    elsif ( $this->{indOne}->getGenotype()->isa("RangeVector") ) {
        $genotype =
          RangeVector->new( $this->{indOne}->getGenotype()->getRanges() );
        $log->info(
            "Factory method to get proper genotype called (RangeVector)");
    }
    elsif ( $this->{indOne}->getGenotype()->isa("ListVector") ) {
        $genotype =
          ListVector->new( $this->{indOne}->getGenotype()->getRanges() );
        $log->info("Factory method to get proper genotype called (ListVector)");
    }
    else {
        $log->logconfess(
            "Trying to perform crossover on an unrecognized genotype type");
    }

    return $genotype;
}

#===  CLASS METHOD  ============================================================
#        CLASS: Uniform
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

    if ( $this->{indOne}->getGenotype()->isa("BitVector") ) {
        $individual =
          Individual->new( genotype =>
              BitVector->new( $this->{indOne}->getGenotype()->getLength() ) );
        $log->info(
            "Factory method to get proper individual called (BitVector)");
    }
    elsif ( $this->{indOne}->getGenotype()->isa("RangeVector") ) {
        $individual =
          Individual->new( genotype =>
              RangeVector->new( $this->{indOne}->getGenotype()->getRanges() ) );
        $log->info(
            "Factory method to get proper individual called (RangeVector)");
    }
    elsif ( $this->{indOne}->getGenotype()->isa("ListVector") ) {
        $individual =
          Individual->new( genotype =>
              ListVector->new( $this->{indOne}->getGenotype()->getRanges() ) );
        $log->info(
            "Factory method to get proper individual called (ListVector)");
    }
    else {
        $log->logconfess(
            "Trying to perform crossover on an unrecognized genotype type");
    }

    return $individual;
}

#=== CLASS METHOD  ============================================================
#        CLASS: Uniform
#       METHOD: crossIndividuals
#   PARAMETERS: individualOne -> the first individual to be mated.
#               individualTwo -> the second individual to be mated.
#      RETURNS: A vector of individuals containing the offspring of those passed
#               as parameters.
#  DESCRIPTION: Crosses a couple of individuals of the same length following
#               the uniform technique.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub crossIndividuals {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS HASH
    my $this = shift;

    # Retrieve parameters..
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

    # Instantiate the needed genotypes...
    my $genotypeChild1 = _getProperGenotype($this);
    my $genotypeChild2 = _getProperGenotype($this);

    # Instantiate the needed individuals...
    my $child1 = _getProperIndividual($this);
    my $child2 = _getProperIndividual($this);

    # Child one: for each gen from i=0 to Length() select randomly if
    # we choose the locus from indOne or indTwo
    # Child two: for each gen from i=0 to Length() select randomly if
    # we choose the locus from indOne or indTwo
    for ( my $i = 0 ; $i < $this->{indOne}->getGenotype()->getLength() ; $i++ )
    {
        $genotypeChild1->setGen( $i, _randomSel( $this, $i ) );
        $genotypeChild2->setGen( $i, _randomSel( $this, $i ) );
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
}     ## --- end sub crossIndividuals

__END__

=head1 DESCRIPTION

Concrete implementation of the CrossStrategy interface
comprising the uniform crossover technique, which consists on
selecting one gen per parent for each one of the offspring.

=head1 METHODS

    #===  FUNCTION  ================================================================
    #         NAME: new
    #      PURPOSE: Creates a newly allocated Uniform crossover strategy.
    #   PARAMETERS: None.
    #      RETURNS: A reference to the instance just created.
    #       THROWS: no exceptions
    #===============================================================================

    #=== CLASS METHOD  ============================================================
    #        CLASS: Uniform
    #       METHOD: _randomSel
    #   PARAMETERS: position -> the position of the gen.
    #      RETURNS: the value of the selected gen.
    #  DESCRIPTION: For a given position select randomly which parent a given gen
    #               is selected from.
    #       THROWS: no exceptions
    #     COMMENTS: none
    #     SEE ALSO: n/a
    #===============================================================================

    #=== CLASS METHOD  ============================================================
    #        CLASS: Uniform
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
    #        CLASS: Uniform
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

    #=== CLASS METHOD  ============================================================
    #        CLASS: Uniform
    #       METHOD: crossIndividuals
    #   PARAMETERS: individualOne -> the first individual to be mated.
    #               individualTwo -> the second individual to be mated.
    #      RETURNS: A vector of individuals containing the offspring of those passed
    #               as parameters.
    #  DESCRIPTION: Crosses a couple of individuals of the same length following
    #               the uniform technique.
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
