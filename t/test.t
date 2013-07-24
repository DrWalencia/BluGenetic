#
#===============================================================================
#
#         FILE: test.t
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/23/2013 08:12:35 PM
#     REVISION: ---
#===============================================================================

use Test::More tests => 1;                      # last test to print

use CrossoverStrategy::OnePoint;

my $var = OnePoint->new("A","B","C");

ok ($var->crossIndividuals() eq 'C');

