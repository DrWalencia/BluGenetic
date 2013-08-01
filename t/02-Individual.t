#
#===============================================================================
#
#         FILE: Individual.t
#
#  DESCRIPTION: Basic set of tests that attempt to prove that the basic
#               functionality regarding the representation of an Individual
#               in the library is working.
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

use Test::More tests => 19;    # last test to print
use Log::Log4perl qw(get_logger);
use Individual;
use diagnostics;

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

# Constructor: correct instantiation (void, with both arguments and with just the genotype)
my $individual = Individual->new();
ok( !$individual->scoreSet() );

my $individual2 = Individual->new(
    score    => 40,
    genotype => BitVector->new(30)
);

ok( $individual2->getScore() == 40 );
ok( $individual2->getGenotype()->getLength() == 30 );
ok( $individual2->scoreSet() );

dies_ok { ( my $individual3 = Individual->new( score => 34 ) ) };

my $individual4 = Individual->new( genotype => BitVector->new(3) );
ok( $individual4->getGenotype()->getLength() == 3 );
ok( !( $individual->scoreSet() ) );

# Constructor: instantiation with a null genotype pointer
dies_ok {
    (
        my $individual5 = Individual->new(
            score    => 23,
            genotype => undef
        )
    );
};

dies_ok {
    (
        my $individual6 = Individual->new(
            genotype => undef
        )
    );
};

# setScore: Negative, zero and positive score
my $individual7 = Individual->new( genotype => BitVector->new(34) );
$individual7->setScore(35);
ok( $individual7->getScore() == 35 );

my $individual8 = Individual->new( genotype => BitVector->new(34) );
dies_ok { ( $individual8->setScore(-1) ) };
$individual8->setScore(0);
ok( $individual8->getScore() == 0 );

# getGenotype: create an individual and check if the returned genotype contains the same info as the one passed in the constructor.
my $genotype = BitVector->new(3);
$genotype->setGen( 0, 0 );
$genotype->setGen( 1, 0 );
$genotype->setGen( 2, 0 );

my $individual9 = Individual->new(
    score    => 32,
    genotype => $genotype
);

my $genotype2 = $individual9->getGenotype();

ok( $genotype->getGen(0) == $genotype2->getGen(0) );
ok( $genotype->getGen(1) == $genotype2->getGen(1) );
ok( $genotype->getGen(2) == $genotype2->getGen(2) );

# setGenotype: try to set it with an null genotype as argument and a proper set too.
my $individual10 = Individual->new();
dies_ok{ ( $individual10->setGenotype(undef) ) };

my $individual11 = Individual->new(
    genotype => BitVector->new(3)
);

my $genotype3 = BitVector->new(3);
$genotype3->setGen(0,0);
$genotype3->setGen(1,0);
$genotype3->setGen(2,0);

$individual11->setGenotype($genotype3);

ok($individual11->getGenotype()->getGen(0) == 0);
ok($individual11->getGenotype()->getGen(1) == 0);
ok($individual11->getGenotype()->getGen(2) == 0);
