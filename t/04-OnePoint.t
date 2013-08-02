#
#===============================================================================
#
#         FILE: OnePoint.t
#
#  DESCRIPTION: Basic set of tests that attempt to prove that the basic
#               functionality regarding the representation of a One Point
#				crossover strategy.
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/29/2013 07:57:29 PM
#     REVISION: ---
#===============================================================================

use Test::More tests => 40;    # last test to print
use Log::Log4perl qw(get_logger);
use Individual;
use diagnostics;
use Genotype::BitVector;
use Crossover::OnePoint;

# Tests for checking if a certain section of code dies
use Test::Exception;

my $conf = q(

############################################################
## A simple root logger with a Log::Log4perl::Appender::File 
## file appender in Perl.
#############################################################
log4perl.rootLogger=DEBUG, LOGFILE

log4perl.appender.LOGFILE=Log::Log4perl::Appender::File
log4perl.appender.LOGFILE.filename=./BluGenetic.log
log4perl.appender.LOGFILE.mode=write

log4perl.appender.LOGFILE.layout=PatternLayout
log4perl.appender.LOGFILE.layout.ConversionPattern=[%d] %F %L %p - %m%n

);

## Initialize logging behavior
Log::Log4perl->init( \$conf );

# Constructor: individual1 without genotype. Dies painfully

	my $ind1 = Individual->new();
	my $ind2 = Individual->new();
	
	dies_ok{ $crossover->crossIndividuals($ind1, $ind2)};

# Constructor: individual2 without genotype. Dies painfully

	my $ind11 = Individual->new();
	my $ind21 = Individual->new();
	
	dies_ok{ $crossover->crossIndividuals($ind11, $ind21)};

# From now on, every test is going to be carried out using 
# manual cut points, and individuals with genotype 111111 
# and 000000 (length 6)

	my $indOneGenotype = BitVector->new(6);
	$indOneGenotype->setGen(0,0);
	$indOneGenotype->setGen(1,0);
	$indOneGenotype->setGen(2,0);
	$indOneGenotype->setGen(3,0);
	$indOneGenotype->setGen(4,0);
	$indOneGenotype->setGen(5,0);

	my $indTwoGenotype = BitVector->new(6);
	$indTwoGenotype->setGen(0,1);
	$indTwoGenotype->setGen(1,1);
	$indTwoGenotype->setGen(2,1);
	$indTwoGenotype->setGen(3,1);
	$indTwoGenotype->setGen(4,1);
	$indTwoGenotype->setGen(5,1);
	
	my $indOne = Individual->new(
		genotype => $indOneGenotype
	);
	
	my $indTwo = Individual->new(
		genotype => $indTwoGenotype
	);
	
	my $crossover = OnePoint->new();

# crossIndividuals: Crossover point in position 0

	$crossover->setCutPoint(0);
	
	my @v = $crossover->crossIndividuals($indOne,$indTwo);

	ok (@v);
	
	# The first child will have a zero in position zero
	ok( $v[0]->getGenotype->getGen(0) == 0);
	
	# And ones in the rest of the positions
	for ( my $j = 1; $j < $v[0]->getGenotype()->getLength(); $j++ ){
		ok( $v[0]->getGenotype->getGen($j) == 1);
	}
	
	# The second child will have a one in position zero
	ok( $v[1]->getGenotype->getGen(0) == 1);
	
	# And zeros in the rest of the positions
	for ( my $j = 1; $j < $v[1]->getGenotype()->getLength(); $j++ ){
		ok( $v[1]->getGenotype->getGen($j) == 0);
	}

# crossIndividuals: Crossover point in last position
# indOne.getGenotype.GetLength()

	# 2 must be subtracted from the genotype length because there are 
	# length()-1 cut points and the indexes go from 0 to length()-1
	$crossover->setCutPoint( $indOne->getGenotype()->getLength() -2 );
	
	my @v1 = $crossover->crossIndividuals($indOne,$indTwo);

	ok (@v1);
	
	# The first child will have zeros in the first five positions
	for ( my $j = 0; $j < $v1[0]->getGenotype()->getLength()-1; $j++ ){
		ok( $v1[0]->getGenotype->getGen($j) == 0);
	}

	# And a one in the last position
	ok( $v1[0]->getGenotype->getGen(5) == 1);
	
	# The second child will have ones in the first five positions
	for ( my $j = 0; $j < $v1[1]->getGenotype()->getLength()-1 ; $j++ ){
		ok( $v1[1]->getGenotype->getGen($j) == 1);
	}

	# And a zero in the last position
	ok( $v1[1]->getGenotype->getGen(5) == 0);

# crossIndividuals: Crossover point in the middle position

	# In a genotype of 6 genes with indexes from 0 to length()-1=5 the 
	# middle position would be position 2
	$crossover->setCutPoint( int( ($indOne->getGenotype()->getLength()-1)/2 ) );
	
	my @v2 = $crossover->crossIndividuals($indOne,$indTwo);
	
	ok ($v2[0]->getGenotype()->getGen(0) == 0);
	ok ($v2[0]->getGenotype()->getGen(1) == 0);
	ok ($v2[0]->getGenotype()->getGen(2) == 0);
	ok ($v2[0]->getGenotype()->getGen(3) == 1);
	ok ($v2[0]->getGenotype()->getGen(4) == 1);
	ok ($v2[0]->getGenotype()->getGen(5) == 1);
	
	ok ($v2[1]->getGenotype()->getGen(0) == 1);
	ok ($v2[1]->getGenotype()->getGen(1) == 1);
	ok ($v2[1]->getGenotype()->getGen(2) == 1);
	ok ($v2[1]->getGenotype()->getGen(3) == 0);
	ok ($v2[1]->getGenotype()->getGen(4) == 0);
	ok ($v2[1]->getGenotype()->getGen(5) == 0);