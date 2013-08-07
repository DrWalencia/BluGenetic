#
#===============================================================================
#
#         FILE: Roulette.t
#
#  DESCRIPTION: Basic set of tests that attempt to prove that the basic
#               functionality regarding the representation of a roulette
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
use Selection::Roulette;
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
# Initialize logging behavior
Log::Log4perl->init( \$conf );

# performSelection: over an empty population. Dies painfully
{
	my @population = undef;
	my $selection = Roulette->new();
	
	dies_ok{ $selection->performSelection(@population)} "performSelection: over an empty population. Dies painfully";
}

# Check if the population is returned properly
# performSelection: Population with two elements: one with score 
# 1 and the other with score 0. The returned population must be 
# filled only with copies of the first element
{
	# Create population and roulette
	my @pop;
	my $selection = Roulette->new();
	
	# Fill the population with a couple of elements
	push @pop, Individual->new(
			score 		=> 1.0,
			genotype	=> BitVector->new(6)
	);
	
	push @pop, Individual->new(
			score		=> 0,
			genotype	=> BitVector->new(6)
	);
	
	# If an element have 100% chance of being selected then the 
	# result of the selection will be a list of Individuals 
	# with the same score and genotype
	my @selectedPop = $selection->performSelection(@pop);
	
	# Check that selectedPop is not empty
	ok ( @selectedPop, "Population result of the selection strategy is not empty" );
	
	# To prove it we check every single gen and score of every 
	# single individual with the individual with position 0 in pop
	for ( my $i = 0; $i < @selectedPop; $i++ ){
		
		my $ind1 = $selectedPop[$i];
		my $ind2 = $selectedPop[0];
		
		ok ( $ind1->getScore() == $ind2->getScore(), "Check that element 0 and element $i have the same score" );
	
		my $genotype1 = $ind1->getGenotype();
		my $genotype2 = $ind2->getGenotype();
		
		for ( my $j = 0; $j < $genotype1->getLength(); $j++ ){
			ok ( $genotype1->getGen($j) == $genotype2->getGen($j), "Gen $j of both elements have the same value");
		}
	}
	
}


# Check if the normalization is performed properly
# performSelection: Population with two elements with the same 
# score. The accumulated normalized scores must be 0.5 and 1
{
	# Create population and roulette
	my @population;
	my $selection = Roulette->new();
	
	my $genotype1 = BitVector->new(6);
	my $genotype2 = BitVector->new(6);
	
	for (my $i = 0; $i < $genotype1->getLength(); $i++ ){
		$genotype1->setGen($i,0);
		$genotype2->setGen($i,1);
	}
	
	# Fill the population with the two elements of the same 
	# score but different genotype, which is how they are 
	# going to be separated later.
	push @population, Individual->new(
		score 		=> 99,
		genotype	=> $genotype1
	);
	
	push @population, Individual->new(
		score 		=> 99,
		genotype	=> $genotype2
	);
	
	# Nobody gives a shit about what the selection returns
	$selection->performSelection(@population);
	
	# The important thing here is to check what the hell is 
	# inside of the sorted normalized population which should 
	# be a couple of different elements in genotype (111111) 
	# and (000000) and with accumulated scores of 0.5 for 
	# the first and 1.0 for the second
	
	my @sortedNormalizedPop = $selection->getSortedNormalizedPop();
	
	# Check that normalization was performed correctly
	ok ( $sortedNormalizedPop[@sortedNormalizedPop - 1]->getScore() == 1, "Score as expected for last individual as a product of selection strategy");
	ok ( $sortedNormalizedPop[0]->getScore() == 0.5, "Score as expected for first individual as a product of selection strategy" );
	
	ok ( $sortedNormalizedPop[0]->getGenotype()->getGen(0) != $sortedNormalizedPop[@sortedNormalizedPop - 1]->getGenotype()->getGen(0), "The individuals are different in genotype");
}


# Check if the sorting is performed properly
# Population with two elements with scores 3 and 1
# The accumulated normalized values must be 0.25 and 1
{
	# Create population and roulette
	my @population;
	my $selection = Roulette->new();
		
	my $genotype1 = BitVector->new(6);
	my $genotype2 = BitVector->new(6);
	
	for (my $i = 0; $i < $genotype1->getLength(); $i++ ){
		$genotype1->setGen($i,0);
		$genotype2->setGen($i,1);
	}
	
	# Fill the population with the two elements. The given 
	# scores guarantee accumulated scores of 0.75 for the 
	# second and 1 for the first, if everything is OK.
	push @population, Individual->new(
		score 		=> 3,
		genotype	=> $genotype1
	);
	
	push @population, Individual->new(
		score 		=> 1,
		genotype	=> $genotype2
	);
	
	# Nobody gives a shit about what the selection returns
	$selection->performSelection(@population);
	
	# The important thing here is to check what the hell is 
	# inside of the sorted normalized population which should 
	# be a couple of different elements in genotype (111111) 
	# and (000000) and with accumulated scores of 0.75 for 
	# the first and 1.0 for the second
	
	my @sortedNormalizedPop = $selection->getSortedNormalizedPop();
	
	# Check that normalization was performed correctly
	ok ( $sortedNormalizedPop[@sortedNormalizedPop - 1]->getScore() == 1, "Score as expected for last individual as a product of selection strategy");
	ok ( $sortedNormalizedPop[0]->getScore() == 0.75, "Score as expected for first individual as a product of selection strategy" );
	
	ok ( $sortedNormalizedPop[0]->getGenotype()->getGen(0) != $sortedNormalizedPop[@sortedNormalizedPop - 1]->getGenotype()->getGen(0), "The individuals are different in genotype");
}

done_testing;