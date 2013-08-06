#
#===============================================================================
#
#         FILE: BluGenetic.pm
#
#  DESCRIPTION:	STATIC class that works as a Factory, returning one of the
#  		types of genetic algorithms according to the arguments passed
#  		as parameters to its only method.
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Pablo Valencia González (PVG), hybrid-rollert@lavabit.com
# ORGANIZATION: Universidad de León
#      VERSION: 1.0
#      CREATED: 07/22/2013 09:25:14 PM
#     REVISION: ---
#===============================================================================

package BluGenetic;

use 5.006;
use strict;
use warnings FATAL => 'all';
use diagnostics;
use Log::Log4perl qw(get_logger);
use Algorithm::GABitVector;
use Algorithm::GAListVector;
use Algorithm::GARangeVector;

# Get a logger from the singleton
my $log = Log::Log4perl::get_logger("BluGenetic");

use constant DEF_CROSS_CHANCE => 0.95;
use constant DEF_MUT_CHANCE => 0.05;

#===  CLASS METHOD  ============================================================
#        CLASS: BluGenetic
#       METHOD: new
#
#   PARAMETERS: popSize	-> INTEGER size of the population
#   		crossover-> FLOAT chance of crossover (default 0.95)
#   		mutation -> FLOAT chance of mutation (default 0.05)
#		TODO IF CROSSOVER AND MUTATION HAVE DEFAULT VALUES, THEN THEY
#		ARE OPTIONAL. MUST CHANGE THE NEW() METHOD ACCORDINGLY.
#   		type	-> STRING type of data e.g: 'bitvector'
#   		fitness	-> FUNCTION POINTER custom fitness function (MUST)
#   		terminate-> FUNCTION POINTER custom terminate function
#   			 (OPTIONAL)
#
#      RETURNS: A reference to the proper GA.
#  DESCRIPTION:	Returns one of the three types of Genetic Algorithm according
#  				to the arguments passed.
#       THROWS: no exceptions
#     COMMENTS: THIS METHOD IS NOT A CONSTRUCTOR EVEN THOUGH ITS NAME IS NEW
#     SEE ALSO: n/a
#===============================================================================
sub new {

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

	$log->info("Factory job to create a Genetic Algorithm started.");
	
	# Take the class name and the arguments passed as a hash
 	my($class, %args) = @_;
 	
 	# If any of the three mandatory arguments is missing, die painfully
 	if (!(defined $args{popSize})){
 		$log->logconfess("popSize argument undefined.");
 	}
 	
 	if (!(defined $args{type})){
 		$log->logconfess("type argument undefined.");
 	}
 	
 	if (!(defined $args{fitness})){
 		$log->logconfess("fitness function undefined.");
 	}
 	
 	# For optional values, check if they're defined 
 	# If not, check their ranges
 	if (!(defined $args{crossover})){
 		$args{crossover} = DEF_CROSS_CHANCE;
 	}elsif (($args{crossover} < 0) or ($args{crossover} > 1)){
 		$log->confess("Wrong value for crossover: ", $args{crossover});
 	}
 	
 	if (!(defined $args{mutation})){
 		$args{mutation} = DEF_MUT_CHANCE;
 	}elsif (($args{mutation} < 0) or ($args{mutation} > 1)){
 		$log->confess("Wrong value for mutation: ", $args{mutation});
 	}
 	
 	# Terminate is managed by GeneticAlgorithm

	# The algorithm that the factory is going to return
	my $algorithm = _getProperAlgorithm(%args);

	$log->info("Factory job to create a Genetic Algoritm finished.");
		
	return $algorithm; 

} ## --- end sub new

#===  CLASS METHOD  ============================================================
#        CLASS: BluGenetic
#       METHOD: _getProperAlgorithm
#   PARAMETERS: args -> a hash containing the needed arguments.
#      RETURNS: The needed instance of Genetic Algorithm.
#  DESCRIPTION:	Factory method that instantiates the proper GA and returns it.
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub _getProperAlgorithm{
	
	# Retrieve the arguments...
	my %args = @_;
	
	my $algorithm;
	
	my $type = lc($args{type});
	delete $args{type};
	
	# Now according to what's inside type, the factory decides...
	if ( $type eq 'bitvector' ) {
		$algorithm = GABitVector->new(%args);
		$log->info("Algorithm of type 'bitvector' generated");
	}elsif ( $type eq 'rangevector'){ 
		$algorithm = GARangeVector->new(%args);
		$log->info("Algorithm of type 'rangevector' generated");
	}elsif ( $type eq 'listvector'){
		$algorithm = GAListVector->new(%args);
		$log->info("Algorithm of type 'listvector' generated");
	}else{
		$log->logconfess("Unknown data type: $args{type}. Arguments case should all be in lowercase.");
	}
	
	return $algorithm;
}



=head1 NAME

BluGenetic - The great new BluGenetic!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use BluGenetic;

    my $foo = BluGenetic->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

Pablo Valencia Gonzalez, C<< <hybrid-rollert at lavabit.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-blugenetic at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=BluGenetic>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc BluGenetic


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=BluGenetic>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/BluGenetic>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/BluGenetic>

=item * Search CPAN

L<http://search.cpan.org/dist/BluGenetic/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Pablo Valencia Gonzalez.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.


=cut

1; # End of BluGenetic
