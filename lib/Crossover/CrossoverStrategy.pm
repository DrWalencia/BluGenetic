#
#===============================================================================
#
#         FILE: CrossoverStrategy.pm
#
#  DESCRIPTION: Common INTERFACE for every crossover strategy wanted to be
#               implemented by the library
#
#               So far implemented -> OnePoint, TwoPoint, Uniform
#
#        NOTES: THIS CLASS SHOULD NEVER BE INSTANTIATED
#       AUTHOR: Pablo Valencia González (PVG), valeng.pablo@gmail.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/12/2013 08:32:05 PM
#===============================================================================

package CrossoverStrategy;

use strict;
use warnings;
use diagnostics;

use Log::Log4perl qw(get_logger);

# Get a logger from the singleton
our $log = Log::Log4perl::get_logger("CrossoverStrategy");

# Avoid warnings regarding class method overriding
no warnings 'redefine';

#===  FUNCTION  ================================================================
#         NAME: crossIndividuals
#      PURPOSE: Performs the crossover between the couple of individuals passed
#               as parameters.
#   PARAMETERS: individualOne -> the first individual
#               individualTwo -> the second individual.
#      RETURNS: An array containing the offspring of the previous individuals.
#===============================================================================
sub crossIndividuals {
    $log->logconfess(
        "The function crossIndividuals() must be defined in a subclass.\n");
    return;
}    ## --- end sub crossIndividuals

__END__

=head1 DESCRIPTION

Common INTERFACE for every crossover strategy wanted to be
implemented by the library. So far implemented -> OnePoint, TwoPoint, Uniform, Custom

=head1 METHODS

    #===  FUNCTION  ================================================================
    #         NAME: crossIndividuals
    #      PURPOSE: Performs the crossover between the couple of individuals passed
    #               as parameters.
    #   PARAMETERS: individualOne -> the first individual
    #               individualTwo -> the second individual.
    #      RETURNS: An array containing the offspring of the previous individuals.
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
