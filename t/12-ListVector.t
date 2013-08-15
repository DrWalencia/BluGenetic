#
#===============================================================================
#
#         FILE: ListVector.t
#
#  DESCRIPTION: Basic set of tests that attempt to prove that the basic
#               functionality regarding the ListVector genotype is working.
#
#       AUTHOR: Pablo Valencia González (PVG), valeng.pablo@gmail.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/23/2013 08:12:35 PM
#===============================================================================

use strict;
use warnings;
use diagnostics;

use Test::More;
use Log::Log4perl qw(get_logger);
use Genotype::ListVector;

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
    ok(
        ListVector->new(
            [qw/red blue green/], [qw/big medium small/],
            [qw/very_fat fat fit thin very_thin/]
        ),
        "Constructor: memory allocated and correct number of genes"
    );
}

# Constructor: size and genotypes are the same
{
    my $genotype =
      ListVector->new( [qw/red blue green/], [qw/big medium small/],
        [qw/very_fat fat fit thin very_thin/] );

    my $genRef    = $genotype->{genotype};
    my $rangesRef = $genotype->{ranges};

    ok( @$genRef == @$rangesRef,
        "Constructor: size and genotypes are the same" );
}

# Constructor: check if gen values randomly generated are within set.
{
    my $genotype =
      ListVector->new( [qw/red blue green/], [qw/big medium small/],
        [qw/very_fat fat fit thin very_thin/] );

    my $rangesRef = $genotype->{ranges};
    my @ranges    = @$rangesRef;

    my $genRef   = $genotype->{genotype};
    my @genotype = @$genRef;

    for ( my $i = 0 ; $i < @genotype ; $i++ ) {
        my $element = $genotype[$i];
        my $setRef  = $ranges[$i];
        my @set     = @$setRef;
        my $flag    = 0;

        foreach my $el (@set) {
            if ( $el eq $element ) {
                $flag = 1;
                last;
            }
        }

        ok( $flag, "$element is within set" );
    }
}

# setGen: Introduce gen in wrong position: over genotype length 
# or below 0. Dies
{
    my $genotype =
      ListVector->new( [qw/red blue green/], [qw/big medium small/],
        [qw/very_fat fat fit thin very_thin/] );

    dies_ok { $genotype->setGen( -1, "red" ) }
    "setGen: fails if index below zero inserted";
    dies_ok { $genotype->setGen( 5, "red" ) }
    "setGen: fails if index over length is inserted";
}

# setGen: value not in set of possible values. Dies
{
    my $genotype =
      ListVector->new( [qw/red blue green/], [qw/big medium small/],
        [qw/very_fat fat fit thin very_thin/] );

    dies_ok { $genotype->setGen( 0, "yellow" ) }
    "setGen: fails if value over limits";
    dies_ok { $genotype->setGen( 1, "huge" ) }
    "setGen: fails if value below limits";
    dies_ok { $genotype->setGen( 2, "thinnest" ) }
    "setGen: fails if value below limits";
}

# setGen: make sure a blue is inserted in gen 0 by inserting it
{
    my $genotype =
      ListVector->new( [qw/red blue green/], [qw/big medium small/],
        [qw/very_fat fat fit thin very_thin/] );

    $genotype->setGen( 0, "blue" );

    my $genRef   = $genotype->{genotype};
    my @genotype = @$genRef;

    ok( $genotype[0] eq "blue",
        "setGen: make sure a blue is inserted in gen 0 by inserting it" );
}

# getGen: check that the gen returned and the one got by breaking
# encapsulation are the same
{
    my $genotype =
      ListVector->new( [qw/red blue green/], [qw/big medium small/],
        [qw/very_fat fat fit thin very_thin/] );

    my $element = $genotype->getGen(0);

    my $genRef   = $genotype->{genotype};
    my @genotype = @$genRef;

    ok(
        $genotype[0] eq $element,
"getGen: check that the gen returned and the one got by breaking encapsulation are the same"
    );
}

# getLength: check that the length returned an the one got by
# breaking encapsulation are the same
{
    my $genotype =
      ListVector->new( [qw/red blue green/], [qw/big medium small/],
        [qw/very_fat fat fit thin very_thin/] );

    my $length = $genotype->getLength();

    my $genRef   = $genotype->{genotype};
    my @genotype = @$genRef;

    ok(
        $length == @$genRef,
"getLength: check that the length returned an the one got by breaking encapsulation are the same"
    );
}

# getType: Create a ListVector element and check if the type corresponds 
# to ListVector
{
    my $genotype =
      ListVector->new( [qw/red blue green/], [qw/big medium small/],
        [qw/very_fat fat fit thin very_thin/] );

    ok( $genotype->isa("ListVector"),
"getType: Create a ListVector element and check if the type corresponds to ListVector"
    );
}

# changeGen: mutate and check that the values are different.
# COMMENTED -> IT MAY RARELY FAIL BECAUSE OF ITS RANDOM NATURE
#{
#	my $genotype = ListVector->new([qw/red blue green/],
#               [qw/big medium small/],
#               [qw/very_fat fat fit thin very_thin/]);
#
#	my $element = $genotype->getGen(0);
#	$genotype->changeGen(0);
#	my $elementMut = $genotype->getGen(0);
#
#	ok ( $element ne $elementMut, "changeGen: mutate and check that the values are different" );
#}

# getRanges: call the function and check that it contains
# a reference to an array of references to array
{
    my $genotype =
      ListVector->new( [qw/red blue green/], [qw/big medium small/],
        [qw/very_fat fat fit thin very_thin/] );

    my $rangesRef = $genotype->getRanges();
    my @ranges    = @$rangesRef;

    ok(
        @ranges == 3,
"getRanges: call the function and check that it contains the right number of elements"
    );

    ok(
        ref( $ranges[0] ) eq "ARRAY",
"getRanges: call the function and check that it contains a reference to an array of references to array"
    );
}

done_testing;
