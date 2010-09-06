use inc::Module::Install;
name 'Plack-App-MicroTemplate';
all_from 'lib/Plack/App/MicroTemplate.pm';

requires 'Text::MicroTemplate' => 0.18;
requires 'Plack' => '0.99';


readme_markdown_from 'lib/Plack/App/MicroTemplate.pm';
tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t';
test_requires 'Test::More';
test_requires 'YAML';
author_tests('xt');
# use_test_base;
auto_include;
WriteAll;
