#
#===============================================================================
#
#         FILE: Tournament.t
#
#  DESCRIPTION: Basic set of tests that attempt to prove that the basic
#               functionality regarding the representation of a tournament
#				selection strategy.
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
use Test::More;
use Log::Log4perl qw(get_logger);
use Individual;
use diagnostics;
use Selection::Tournament;
use Genotype::BitVector;

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

my $selection2 = Tournament->new();

# battlefieldSize: missing argument. Dies painfully

	dies_ok { $selection2->battlefieldSize() } "battlefieldSize: missing argument. Dies painfully";

# battlefieldSize: number of individuals zero. Dies painfully

	dies_ok { $selection2->battlefieldSize(0) } "battlefieldSize: number of individuals zero. Dies painfully";

# battlefieldSize: number of individuals negative. Dies painfully

	dies_ok { $selection2->battlefieldSize(-4) } "battlefieldSize: number of individuals negative. Dies painfully";

# Population with two elements: one with score 1 and the other with score 0
	
	# Create population and selection strategy
	my @pop;
	my $selection = Tournament->new();
	
	
	# Fill the population with two elements
	my $indOne = Individual->new(
		score =>	1.0,
		genotype => BitVector->new(6)
	);
	
	$indOne->getGenotype()->setGen(0,1);
	$indOne->getGenotype()->setGen(1,1);
	$indOne->getGenotype()->setGen(2,1);
	$indOne->getGenotype()->setGen(3,1);
	$indOne->getGenotype()->setGen(4,1);
	$indOne->getGenotype()->setGen(5,1);
	
	
	
	my $indTwo = Individual->new(
		score => 0,
		genotype => BitVector->new(6)
	);
	
	$indOne->getGenotype()->setGen(0,0);
	$indOne->getGenotype()->setGen(1,0);
	$indOne->getGenotype()->setGen(2,0);
	$indOne->getGenotype()->setGen(3,0);
	$indOne->getGenotype()->setGen(4,0);
	$indOne->getGenotype()->setGen(5,0);
	
	push @pop, $indOne;
	push @pop, $indTwo;

	# If an element have 100% chance of being selected then the result of 
	# the selection will be a list of Individuals with the same score and 
	# genotype. THIS IS NOT TRUE, SINCE THE SELECTION HERE IS PERFORMED
	# WITH REPLACEMENT, NOTHING FORBIDS TO CHOOSE AN INDIVIDUAL WITH A
	# GIVEN SCORE, AND THEN CHOOSE IT AGAIN IMMEDIATELY (obviously this is
	# going to be very unlikely, especially in big populations)
	
	# TEST COMMENTED OBVIOUSLY BECAUSE THE RANDOM NATURE OF ITS RESULTS.
	# JUST USED FOR DEBUGGING PURPOSES.
	
	my @selectedPop = $selection->performSelection(@pop);

	# To prove it we check every single gen and score of every single 
	# individual with the individual with position 0 in pop
#	for ( my $i = 0; $i < @selectedPop; $i++ ){
#
#		my $ind1 = $selectedPop[$i];
#		my $ind2 = $pop[0];
#		
#		ok ( $ind1->getScore() == $ind2->getScore() );
#		
#		my $genotype1 = $ind1->getGenotype();
#		my $genotype2 = $ind2->getGenotype();
#		
#		for ( my $j = 0; $j < $genotype1->getLength(); $j++ ){
#			ok ( $genotype1->getGen($j) == $genotype2->getGen($j) );
#		}
#	}

done_testing;






