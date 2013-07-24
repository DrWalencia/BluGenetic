use 5.006;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'BluGenetic',
    license             => 'perl',
    dist_author         => q{Pablo Valencia Gonzalez <hybrid-rollert@lavabit.com>},
    dist_version_from   => 'lib/BluGenetic.pm',
    release_status      => 'unstable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    add_to_cleanup     => [ 'BluGenetic-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
