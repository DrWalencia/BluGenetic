#
#===============================================================================
#
#         FILE: BitVector.t
#
#  DESCRIPTION: Basic set of tests that attempt to prove that the basic
#               functionality regarding the BitVector genotype is working.
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/23/2013 08:12:35 PM
#===============================================================================

use Test::More tests => 19;    # last test to print
use Log::Log4perl qw(get_logger);
use Genotype::BitVector;

# Tests for checking if a certain section of code dies
use Test::Exception;

use constant DUMMYVECTORSIZE => 6;

my $conf = q(

############################################################
# A simple root logger with a Log::Log4perl::Appender::File 
# file appender in Perl.
############################################################
log4perl.rootLogger=DEBUG, LOGFILE

log4perl.appender.LOGFILE=Log::Log4perl::Appender::File
log4perl.appender.LOGFILE.filename=./BluGenetic.log
log4perl.appender.LOGFILE.mode=write

log4perl.appender.LOGFILE.layout=PatternLayout
log4perl.appender.LOGFILE.layout.ConversionPattern=[%r] %F %L %c - %m%n

);

# Initialize logging behavior
Log::Log4perl->init( \$conf );

my $genotype = BitVector->new(DUMMYVECTORSIZE);

# Constructor: memory allocated and correct number of genes
# If it doesn't complain we're okay
ok( BitVector->new(1) );

# Constructor: zero or negative genotypeLength
dies_ok { ( BitVector->new(0) ) };
dies_ok { ( BitVector->new(-1) ) };

# setGen: Introduce bit 0 and bit 1 and check if it returns true.
ok( $genotype->setGen( 0, 1 ) );
ok( $genotype->setGen( 0, 0 ) );

# setGen: Introduce something different than a bit e.g=5 and check if it returns false
dies_ok { ( $genotype->setGen( 0, 5 ) ) };
dies_ok { ( $genotype->setGen( 0, -4 ) ) };

# setGen: Introduce an element in a wrong position (over or above genotypeLength)
dies_ok { ( $genotype->setGen( -1, 1 ) ) };
dies_ok { ( $genotype->setGen( 7,  0 ) ) };

# getGen: Retrieve an element from a wrong position (over or above genotypeLength)
dies_ok { ( $genotype->getGen(-1) ) };
dies_ok { ( $genotype->getGen(7) ) };

# getLength: Create with a given size and then test if it retrieves the same
my $genotype2 = BitVector->new(15);
ok( $genotype2->getLength() == 15 );

# getType: Create a BitVector element and check if the type corresponds to BITVECTOR
ok( $genotype2->isa("BitVector") );

# changeGen: create a BitVector element, set its genes manually and flip a given bit
my $genotype3 = BitVector->new(3);
$genotype3->setGen( 0, 0 );
$genotype3->setGen( 1, 0 );
$genotype3->setGen( 2, 1 );
$genotype3->changeGen(1);
ok( $genotype3->getGen(1) == 1 );
$genotype3->changeGen(1);
ok( $genotype3->getGen(1) == 0 );

# changeGen: try to flip bit in wrong position
dies_ok { ( $genotype3->changeGen(-1) ) };
dies_ok { ( $genotype3->changeGen(5) ) };

# getRanges: get the list of ranges
@ranges = $genotype3->getRanges();
ok( $ranges[0] == 0 );
ok( $ranges[1] == 1 );
