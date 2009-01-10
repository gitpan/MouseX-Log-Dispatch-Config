use inc::Module::Install;
name 'MouseX-Log-Dispatch-Config';
all_from 'lib/MouseX/Log/Dispatch/Config.pm';

requires 'Mouse' => '0.14';
requires 'namespace::clean';
requires 'Log::Dispatch::Config';

tests 't/*.t';
test_requires 'Test::More';
test_requires 'ok';
test_requires 'IO::Scalar';
author_tests 'xt';
use_test_base;

auto_include_deps;
WriteAll;
