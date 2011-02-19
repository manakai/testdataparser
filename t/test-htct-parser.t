package test::Test::HTCT::Parser;
use strict;
use warnings;
use Path::Class;
use lib file (__FILE__)->dir->parent->subdir ('lib')->stringify;
use base qw(Test::Class);
use Test::HTCT::Parser;
use Test::Differences;

my $test_data_f = file (__FILE__)->dir->file ('test-htct-parser-1.dat');

sub _for_each_test : Test(1) {
  my @test;
  for_each_test $test_data_f->stringify, {
    data => {is_prefixed => 1},
    errors => {is_list => 1},
  }, sub ($) {
    my $test = shift;
    push @test, $test;
  };
  eq_or_diff \@test, [
    {data => ['abc', []], errors => [['error1', 'error2'], []]},
    {data => ["xyz\n\nabc\n|def", []],
     errors => [['error3', '| error6'], []],
     field1 => ['', []],
     field2 => ['', []],
     field3 => ['def', ['abc']],
     field4 => ["|abc\n| def", []]},
  ];
}

__PACKAGE__->runtests;

1;

=head1 LICENSE

Copyright 2011 Wakaba <w@suika.fam.cx>.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
