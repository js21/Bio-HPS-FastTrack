#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use File::Slurp;
    use_ok('Bio::HPS::FastTrack::PipelineRun::Import');
  }

ok( my $import_runner = Bio::HPS::FastTrack::PipelineRun::Import->new( study =>  'Comparative RNA seq analysis of three bacterial species', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating an Import runner object');
isa_ok ( $import_runner, 'Bio::HPS::FastTrack::PipelineRun::Import' );
ok( $import_runner->command_to_run, 'Building run command' );
ok ( -e $import_runner->config_files->{'low_level'}, 'Low level config file in place' );

my @lines = read_file( $import_runner->config_files->{'low_level'} ) ;

is ($lines[2], qq(            'database' => 'pathogen_hpsft_test',\n), 'Database in place');
is ($lines[21], qq(  'log' => '/nfs/pathnfs05/log/fast_track/import_cram_logfile.log',\n), 'Log in place');
is ($lines[24], qq(                               'Comparative\\ RNA\\ seq\\ analysis\\ of\\ three\\ bacterial\\ species'\n), 'Project in place' );

my $expected_command1 = '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ';
$expected_command1 .= $import_runner->config_files->{'tempdir'};
$expected_command1 .= '/import_cram_pipeline_fast_track.conf -l /nfs/pathnfs05/log/fast_track_import_pipeline.log -o -v -v -L /nfs/pathnfs05/conf/fast_track/.pathogen_hpsft_test.import_cram_pipeline.lock -m 500';

is ( $import_runner->command_to_run, $expected_command1, 'Command to run import pipeline' );

my $dir_to_remove1 = $import_runner->config_files->{'tempdir'};
`rm -rf $dir_to_remove1`;


ok ( my $import_runner2 = Bio::HPS::FastTrack::PipelineRun::Import->new( lane =>  '8405_4#11', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating an Import runner object for importing one lane');

isa_ok ( $import_runner2, 'Bio::HPS::FastTrack::PipelineRun::Import' );
ok( $import_runner2->command_to_run, 'Building run command for importing one lane' );
ok ( -e $import_runner2->config_files->{'low_level'}, 'Low level config file in place for importing one lane' );

my @lines2 = read_file( $import_runner2->config_files->{'low_level'} ) ;

is ($lines2[2], qq(            'database' => 'pathogen_hpsft_test',\n), 'Database in place');
is ($lines2[21], qq(  'log' => '/nfs/pathnfs05/log/fast_track/import_cram_logfile.log',\n), 'Log in place');
is ($lines2[24], qq(                               '8405_4#11'\n), 'Lane in place' );

my $expected_command2 = '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ';
$expected_command2 .= $import_runner2->config_files->{'tempdir'};
$expected_command2 .= '/import_cram_pipeline_fast_track.conf -l /nfs/pathnfs05/log/fast_track_import_pipeline.log -o -v -v -L /nfs/pathnfs05/conf/fast_track/.pathogen_hpsft_test.import_cram_pipeline.lock -m 500';

is ( $import_runner2->command_to_run, $expected_command2, 'Command to run import pipeline for one lane' );

my $dir_to_remove2 = $import_runner2->config_files->{'tempdir'};
`rm -rf $dir_to_remove2`;

done_testing();
