#
#===============================================================================
#
#         FILE: RangeVector.t
#
#  DESCRIPTION: Basic set of tests that attempt to prove that the basic
#               functionality regarding the RangeVector genotype is working.
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/23/2013 08:12:35 PM
#===============================================================================

use Test::More;
use Log::Log4perl qw(get_logger);
use Genotype::RangeVector;
use diagnostics;

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

# Constructor: memory allocated and correct number of genes
# If it doesn't complain we're okay
{
	ok( RangeVector->new([2,3], [0,4], [1,5]), "Constructor: memory allocated and correct number of genes" );
}

# Constructor: size and genotypes are the same
{
	my $genotype = RangeVector->new([2,3], [-3,4], [1,5]);
	
	my $genRef = $genotype->{genotype};
	my $rangesRef = $genotype->{ranges};
	
	ok ( @$genRef == @$rangesRef, "Constructor: size and genotypes are the same" );
}

# Constructor: check if gen values randomly generated are within range.
{
	my $genotype = RangeVector->new([2,3], [-3,4], [1,5]);

	my $rangesRef = $genotype->{ranges};
	my @ranges = @$rangesRef;
	
	my $genRef = $genotype->{genotype};
	my @genotype = @$genRef;
	
	for ( my $i = 0; $i < @genotype; $i++ ){
		my $element = $genotype[$i];
		ok( (( $element <= $ranges[$i][1]) and ( $element >= $ranges[$i][0] ) ), "$element is within range" );
	}
}

# setGen: Introduce gen in wrong position: over genotype length or below 0. Dies
{
	my $genotype = RangeVector->new([2,3], [-3,4], [1,5]);
	
	dies_ok{$genotype->setGen(-1,3)} "setGen: fails if index below zero inserted";
	dies_ok{$genotype->setGen(5,4)} "setGen: fails if index over length is inserted";
}

# setGen: value out of range: over and below limits. Dies
{
	my $genotype = RangeVector->new([2,3], [-3,4], [1,5]);
	
	dies_ok{$genotype->setGen(0,4)} "setGen: fails if value over limits";
	dies_ok{$genotype->setGen(0,0)} "setGen: fails if value below limits";
}

# setGen: make sure a zero is inserted in gen 0 by inserting it
{
	my $genotype = RangeVector->new([-5,3], [-3,4], [1,5]);
	
	$genotype->setGen(0,0);
	
	my $genRef = $genotype->{genotype};
	my @genotype = @$genRef;

	ok ($genotype[0] == 0, "setGen: make sure a zero is inserted in bit 0 by inserting it");
}

# getGen: check that the gen returned and the one got by breaking
# encapsulation are the same
{
	my $genotype = RangeVector->new([-5,3], [-3,4], [1,5]);
	
	my $element = $genotype->getGen(0);
	
	my $genRef = $genotype->{genotype};
	my @genotype = @$genRef;
	
	ok ($genotype[0] == $element, "getGen: check that the gen returned and the one got by breaking encapsulation are the same");
}

# getLength: check that the length returned an the one got by
# breaking encapsulation are the same
{
	my $genotype = RangeVector->new([-5,3], [-3,4], [1,5]);
	
	my $length = $genotype->getLength();
	
	my $genRef = $genotype->{genotype};
	my @genotype = @$genRef;
	
	ok ($length == @$genRef, "getLength: check that the length returned an the one got by breaking encapsulation are the same");
}

# getType: Create a RangeVector element and check if the type corresponds to RangeVector
{
	my $genotype = RangeVector->new([-5,3], [-3,4], [1,5]);

	ok( $genotype->isa("RangeVector"), "getType: Create a RangeVector element and check if the type corresponds to RangeVector");
}

# changeGen: mutate and check that the values are different.
# COMMENTED -> IT MAY RARELY FAIL BECAUSE OF ITS RANDOM NATURE
#{
#	my $genotype = RangeVector->new([-5,3], [-3,4], [1,5]);
#	
#	my $element = $genotype->getGen(0);
#	$genotype->changeGen(0);
#	my $elementMut = $genotype->getGen(0);
#
#	ok ( $element != $elementMut, "changeGen: mutate and check that the values are different" );	
#}

# getRanges: call the function and check that it contains
# a reference to an array of references to array
{
	my $genotype = RangeVector->new([-5,3], [-3,4], [1,5]);
	
	my $rangesRef = $genotype->getRanges();
	my @ranges = @$rangesRef;

	ok ( @ranges == 3, "getRanges: call the function and check that it contains the right number of elements");
	
	ok ( ref($ranges[0]) eq "ARRAY" , "getRanges: call the function and check that it contains a reference to an array of references to array");
}

done_testing;