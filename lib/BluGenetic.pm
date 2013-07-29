#
#===============================================================================
#
#         FILE: BluGenetic.pm
#
#  DESCRIPTION:	STATIC class that works as a Factory, returning one of the
#  				types of genetic algorithms according to the arguments passed
#  				as parameters to its only method.
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
use Log::Log4perl qw(get_logger);
use Algorithm::GABitVector;
use Algorithm::GAListVector;
use Algorithm::GARangeVector;

# Maximum number of arguments to be taken by the Factory
use constant LIMITARGS => 6;

#===  CLASS METHOD  ============================================================
#        CLASS: BluGenetic
#       METHOD: new
#
#   PARAMETERS: popSize 	-> INTEGER size of the population
#   			crossover	-> FLOAT chance of crossover (default 0.95)
#   			mutation 	-> FLOAT chance of mutation (default 0.05)
#   			type		-> STRING type of data e.g: 'bitvector'
#   			fitness		-> FUNCTION POINTER custom fitness function (MUST)
#   			terminate	-> FUNCTION POINTER custom terminate function
#   						   (OPTIONAL)
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

	# Get a logger from the singleton
	my $log = Log::Log4perl::get_logger("BluGenetic");

	$log->info("Factory job to create a Genetic Algorithm started.");
	
	# Take the class name and the arguments passed as a hash
 	my($class, %args) = @_;

	# Check if we get LIMITARGS -1 arguments (default terminate function) or LIMITARGS, otherwise die
	$log->logconfess("Too few arguments for method new()") if scalar keys %args < BluGenetic::LIMITARGS-1;
	$log->logconfess("Too many arguments for method new()") if scalar keys %args > BluGenetic::LIMITARGS;

	# The algorithm that the factory is going to return
	my $algorithm;

	# Now according to what's inside type, the factory decides...
	if ( $args{type} eq 'bitvector' ) {
		delete $args{type};
		$algorithm = GABitVector->new(%args);
		$log->info("Algorithm of type 'bitvector' generated");
	}elsif ( $args{type} eq 'rangevector') {
		delete $args{type};
		$algorithm = GARangeVector->new(%args);
		$log->info("Algorithm of type 'rangevector' generated");
	}elsif ( $args{type} eq 'listvector'){
		delete $args{type};
		$algorithm = GAListVector->new(%args);
		$log->info("Algorithm of type 'listvector' generated");
	}else{
		$log->logconfess("Unknown data type: $args{type}. Arguments case should all be in lowercase.");
	}

	$log->info("Factory job to create a Genetic Algoritm finished.");
		
	return $algorithm; 

} ## --- end sub new


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
