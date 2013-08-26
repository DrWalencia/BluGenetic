#
#===============================================================================
#
#         FILE: UserDefinedS.pm
#
#  DESCRIPTION: Concrete implementation of the selection strategy interface
#               comprising the UserDefinedS selection strategy in which
#               a reference to a custom selection strategy is passed as
#               a parameter in the constructor of the class.
#
#       AUTHOR: Pablo Valencia González (PVG), valeng.pablo@gmail.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/24/2013 12:10:19 AM
#===============================================================================

package UserDefinedS;

use strict;
use warnings;
use diagnostics;

use Log::Log4perl qw(get_logger);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("UserDefinedS");

# Avoid warnings regarding class method overriding
no warnings 'redefine';

# UserDefinedS inherits from Selection::SelectionStrategy
use Selection::SelectionStrategy;
use base qw(SelectionStrategy);

#===  CLASS METHOD  ============================================================
#        CLASS: UserDefinedS
#       METHOD: new
#   PARAMETERS: None.
#      RETURNS: A reference to the instance just created.
#  DESCRIPTION:	Creates a newly allocated UserDefinedS selection strategy.
#===============================================================================
sub new {

    # Every method of a class passes first argument as class name
    my $class = shift;

    # Take the parameters..
    my $ref = shift;

    # Anonymous hash to store instance variables (AKA FIELDS)
    my $this = { strategyRef => $ref };

    # Connect class name with hash is known as blessing an object
    bless $this, $class;

    return $this;
}    ## --- end sub new

#===  CLASS METHOD  ============================================================
#        CLASS: UserDefinedS
#       METHOD: performSelection
#   PARAMETERS: population -> the population on which the selection must be based
#               on.
#      RETURNS: a list containing the result of the selection process.
#  DESCRIPTION: Performs the UserDefinedS selection technique.
#===============================================================================
sub performSelection {

    # EVERY METHOD OF A CLASS PASSES AS THE FIRST ARGUMENT THE FIELDS ARRAY
    my $this = shift;

    # Get the arguments...
    my @population = @_;

    my @returnPopulation = $this->{strategyRef}(@population);

    return @returnPopulation;

}    ## --- end sub performSelection

__END__

=head1 DESCRIPTION

Concrete implementation of the selection strategy interface
comprising the UserDefinedS selection strategy in which
a reference to a custom selection strategy is passed as
a parameter in the constructor of the class.

=head1 METHODS

    #===  CLASS METHOD  ============================================================
    #        CLASS: UserDefinedS
    #       METHOD: new
    #   PARAMETERS: None.
    #      RETURNS: A reference to the instance just created.
    #  DESCRIPTION: Creates a newly allocated UserDefinedS selection strategy.
    #===============================================================================

    #===  CLASS METHOD  ============================================================
    #        CLASS: UserDefinedS
    #       METHOD: performSelection
    #   PARAMETERS: population -> the population on which the selection must be based
    #               on.
    #      RETURNS: a list containing the result of the selection process.
    #  DESCRIPTION: Performs the UserDefinedS selection technique.
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
