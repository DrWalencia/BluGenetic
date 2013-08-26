#
#===============================================================================
#
#         FILE: SelectionStrategy.pm
#
#  DESCRIPTION: Common INTERFACE for every selection strategy wanted to be
#               implemented by the library.
#
#       AUTHOR: Pablo Valencia González (PVG), valeng.pablo@gmail.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/23/2013 11:37:31 PM
#===============================================================================

package SelectionStrategy;

use strict;
use warnings;
use diagnostics;

use Log::Log4perl qw(get_logger);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("SelectionStrategy");

#===  FUNCTION  ================================================================
#         NAME: performSelection
#      PURPOSE: Runs the selection algorithm over the population passed as a
#               parameter.
#   PARAMETERS: population -> the set of individuals from where the selection
#               is performed.
#      RETURNS: An array of individuals of size popSize
#  DESCRIPTION: Performs the selection process
#===============================================================================
sub performSelection {
    $log->logconfess(
        "The function performSelection() must be implemented in a subclass.\n");
    return;
}    ## --- end sub performSelection

__END__

=head1 DESCRIPTION

Common INTERFACE for every selection strategy wanted to be
implemented by the library.

=head1 METHODS

    #===  FUNCTION  ================================================================
    #         NAME: performSelection
    #      PURPOSE: Runs the selection algorithm over the population passed as a
    #               parameter.
    #   PARAMETERS: population -> the set of individuals from where the selection
    #               is performed.
    #      RETURNS: An array of individuals of size popSize
    #  DESCRIPTION: Performs the selection process
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
