#!/usr/bin/env perl
use Moose;
use Data::Dumper;
use File::Slurp;
use File::Path qw( remove_tree);
use Cwd;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
with 'TestHelper';

BEGIN {
    use Test::Most;
    use_ok('Bio::HPS::FastTrack::CommandLine::HPSFastTrack');
}

my $cwd         = getcwd();
my $script_name = 'Bio::HPS::FastTrack::CommandLine::HPSFastTrack';

local $ENV{PATH} = "$ENV{PATH}:./bin";
my %scripts_and_expected_files;


my @params = ('-s', 'Comparative RNA-seq analysis of three bacterial species','-d','pathogen_hpsft_test','-m','test');

my $cmd = "$script_name->new(args => \\\@params, script_name => '$script_name')->run;";
eval($cmd);
my $output = $@;
is($output, "Error: No pipeline was specified through the command line option -p. Usage can be accessed through the -h option.\n", 'No pipeline specified');

@params = ('-s','Comparative RNA-seq analysis of three bacterial species','-d','pathogen_hpsft_test','-p','update','-m','test');
$cmd = "$script_name->new(args => \\\@params, script_name => '$script_name')->run;";
eval($cmd);
$output = $@;
is($output, q(), 'pipeline_runners method not run');


@params = ('-h');
my $expected_usage = <<USAGE;
Usage:
  Specify the study name, the lane or both
  -s|study         <optional: Study name to fast track>
  -l|lane          <optional: Lane name to fast track>
  -d|database      <the tracking database to store the relevant data for the study/lane>
  -p|pipeline      <the pipeline to run>
  -h|help          <print this message>

Utility script to fast track high priority samples through the Pathogen Informatics pipelines


USAGE

$cmd = "$script_name->new(args => \\\@params, script_name => '$script_name','-m','test')->run;";
eval($cmd);
$output = $@;
is($output, $expected_usage, "Usage");


done_testing();
