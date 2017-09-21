use strict;
use warnings;
use Path::Class;
use lib file (__FILE__)->dir->parent->subdir ('lib')->stringify;
use lib glob file (__FILE__)->dir->parent->subdir ('t_deps', 'modules', '*', 'lib')->stringify;
use Test::X1;
use Test::HTCT::Parser;
use Test::Differences;

my $test_data_f = file (__FILE__)->dir->file ('test-htct-parser-1.dat');

test {
  my $c = shift;
  my @test;
  my @line;
  for_each_test $test_data_f->stringify, {
    data => {is_prefixed => 1},
    errors => {is_list => 1},
    multiple1 => {multiple => 1},
    multiple2 => {multiple => 1, is_list => 1},
    multiple3 => {multiple => 1, is_prefixed => 1},
  }, sub ($) {
    my $test = shift;
    my $opts = shift;
    push @test, $test;
    push @line, $opts->{line_number};
  };
  eq_or_diff \@test, [
    {data => ['abc', []], errors => [['error1', 'error2'], []]},
    {data => ["xyz\n\nabc\n|def", []],
     errors => [['error3', '| error6'], []],
     field1 => ['', []],
     field2 => ['', []],
     field3 => ['def', ['abc']],
     field4 => ["|abc\n| def", []]},
    {data => ['hoge', []], multiple1 => [['fuga', []], ['foo', []]],
     multiple2 => [[['a', 'b'], []], [['c', 'd'], []]],
     multiple3 => [['hoge', []]]},
  ];
  eq_or_diff \@line, [
    1, 7, 23,
  ];
  done $c;
} n => 2;

run_tests;

=head1 LICENSE

Copyright 2011-2017 Wakaba <wakaba@suikawiki.org>.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
