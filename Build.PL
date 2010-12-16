use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'HPC::Scheduler',
    license             => 'gpl',
    dist_author         => q{Henning Glawe <glawe@web.de>},
    dist_version_from   => 'lib/HPC/Scheduler.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'HPC-Scheduler-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
