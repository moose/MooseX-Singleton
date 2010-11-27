use strict;
use warnings;
use inc::Module::Install;

name 'MooseX-Singleton';
all_from 'lib/MooseX/Singleton.pm';

requires 'Moose' => '1.10';
requires 'Scalar::Util';

test_requires 'Test::More' => '0.88';
test_requires 'Test::Fatal';
test_requires 'Test::Requires';

license 'Perl';

extra_tests();

WriteAll();
