#
#===============================================================================
#
#         FILE: 08-Uniform.t
#
#  DESCRIPTION: Basic set of tests that attempt to prove the basic
#               functionality regarding the representation of a Uniform
#               crossover strategy.
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 08/05/2013 11:08:57 PM
#     REVISION: ---
#===============================================================================
use Test::More tests => 3;    # last test to print
use Log::Log4perl qw(get_logger);
use Individual;
use diagnostics;
use Genotype::BitVector;
use Crossover::Uniform;

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
    
    my $crossover = Uniform->new();

# Just check that what the crossover strategy returns
# is an array with two Individuals, since the result
# of the crossover is going to be totally random.

    my @offspring = $crossover->crossIndividuals($indOne,$indTwo);

#    my $genotype1 = $offspring[0]->getGenotype()->{genotype};
#    my $genotype2 = $offspring[1]->getGenotype()->{genotype};

#    print @$genotype1; 
#    print "\n";
#    print @$genotype2; 
#    print "\n";

    ok (@offspring);
