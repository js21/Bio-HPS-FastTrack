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

my $expected_usage = <<USAGE;
Usage:
  Specify the study name, the lane or both
  -d|database      <the tracking database to store the relevant data for the study/lane>
  -p|pipeline      <the pipeline to run>
  -s|study         <optional: Study name to fast track>
  -l|lane          <optional: Lane name to fast track>
  -t|sleep_time    <optional: Time in seconds to wait for pipeline to run. Defaults to 120 seconds>
  -h|help          <print this message>

Utility script to fast track high priority samples through the Pathogen Informatics pipelines


USAGE


my @params = ('-s', 'Comparative RNA-seq analysis of three bacterial species','-d','pathogen_hpsft_test','-m','test');

my $cmd = "$script_name->new(args => \\\@params, script_name => '$script_name')->run;";
eval($cmd);
my $output = $@;
is($output, $expected_usage, 'Usage  - No pipeline specified');

my @pipeline = qw(update);
@params = ('-s','Comparative RNA-seq analysis of three bacterial species','-d','pathogen_hpsft_test','-p',@pipeline,'-m','test');
$cmd = "$script_name->new(args => \\\@params, script_name => '$script_name')->run;";
eval($cmd);
$output = $@;
is($output, qq(), 'pipeline_runners method not run');


@params = ('-h');
$cmd = "$script_name->new(args => \\\@params, script_name => '$script_name','-m','test')->run;";
eval($cmd);
$output = $@;
is($output, $expected_usage, "Usage - '-h' option passed");


done_testing();
