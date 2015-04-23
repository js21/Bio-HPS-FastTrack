#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
  use Test::Most;
  use Test::Exception;
  use File::Slurp;
  use_ok('Bio::HPS::FastTrack');
}


ok ( my $hps_fast_track_update =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['update'], mode => 'test' ), 'Creating update study HPS::FastTrack object' );
is ( $hps_fast_track_update->database(), 'pathogen_hpsft_test', 'Database name comparison update');
is_deeply ( $hps_fast_track_update->pipeline(), ['update'], 'Pipeline types comparison update');
isa_ok ( $hps_fast_track_update->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Update' );
is ( $hps_fast_track_update->pipeline_runners()->[0]->study_metadata->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Study id comparison update');
is ( $hps_fast_track_update->pipeline_runners()->[0]->command_to_run,
     q(/software/pathogen/projects/update_pipeline/bin/update_pipeline.pl -n 'Comparative RNA-seq analysis of three bacterial species' --database=pathogen_hpsft_test -l /nfs/pathnfs05/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock -nop -v --file_type cram),
     'Update command');

ok ( my $hps_fast_track_update_lane =  Bio::HPS::FastTrack->new( lane => '8405_4#7', database => 'pathogen_hpsft_test', pipeline => ['update'], mode => 'test' ), 'Creating update_lane HPS::FastTrack object' );
isa_ok ( $hps_fast_track_update_lane->pipeline_runners->[0], 'Bio::HPS::FastTrack::PipelineRun::Update' );
is ( $hps_fast_track_update_lane->pipeline_runners()->[0]->command_to_run(),
     q(/software/pathogen/projects/update_pipeline/bin/update_pipeline.pl -n 'Comparative RNA-seq analysis of three bacterial species' --database=pathogen_hpsft_test -run 8405 -min 8404 -l /nfs/pathnfs05/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock -nop -v --file_type cram),
     'Update command 2');
is ( $hps_fast_track_update_lane->pipeline_runners->[0]->study, 'Comparative RNA-seq analysis of three bacterial species', 'Study name' );


ok ( my $hps_fast_track_update_study_for_run =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', lane => '8405_4#7', database => 'pathogen_hpsft_test', pipeline => ['update'], mode => 'test' ), 'Creating update study for specific run id HPS::FastTrack object' );
is ( $hps_fast_track_update_study_for_run->database(), 'pathogen_hpsft_test', 'Database name comparison update');
is_deeply ( $hps_fast_track_update_study_for_run->pipeline(), ['update'], 'Pipeline types comparison update');
isa_ok ( $hps_fast_track_update_study_for_run->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Update' );
is ( $hps_fast_track_update_study_for_run->pipeline_runners()->[0]->study_metadata->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Study name comparison update');
is ( $hps_fast_track_update_study_for_run->pipeline_runners()->[0]->command_to_run,
     q(/software/pathogen/projects/update_pipeline/bin/update_pipeline.pl -n 'Comparative RNA-seq analysis of three bacterial species' --database=pathogen_hpsft_test -run 8405 -min 8404 -l /nfs/pathnfs05/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock -nop -v --file_type cram),
     'Update command 3');

ok ( my $hps_fast_track_update_without_lane_or_study =  Bio::HPS::FastTrack->new( database => 'pathogen_hpsft_test', pipeline => ['update'], mode => 'test' ), 'Creating update HPS::FastTrack object without lane or study' );
is ( $hps_fast_track_update_without_lane_or_study->database(), 'pathogen_hpsft_test', 'Database name comparison update without lane or study');
is_deeply ( $hps_fast_track_update_without_lane_or_study->pipeline(), ['update'], 'Pipeline types comparison update without lane or study');
throws_ok { $hps_fast_track_update_without_lane_or_study->pipeline_runners()->[0]} qr/Specify a lane or a study or both/, 'No study or lane specified';

throws_ok { my $hps_fast_track_update_without_database_with_lane = Bio::HPS::FastTrack->new( lane => '8405_4#7', pipeline => ['update'], mode => 'test' )
	  } qr/Attribute \(database\) is required/, 'Database requirement 1';

throws_ok { my $hps_fast_track_update_without_database_with_study = Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', pipeline => ['update'], mode => 'test' )
	  } qr/Attribute \(database\) is required/, 'Database requirement 2';

throws_ok { my $hps_fast_track_update_without_pipeline_with_lane = Bio::HPS::FastTrack->new( lane => '8405_4#7', database => 'pathogen_hpsft_test', mode => 'test' )
	  } qr/Attribute \(pipeline\) is required/, 'Pipeline requirement 1';

throws_ok { my $hps_fast_track_update_without_pipeline_with_study = Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', mode => 'test' )
	  } qr/Attribute \(pipeline\) is required/, 'Pipeline requirement 2';


ok ( my $hps_fast_track_import_study =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['import'], mode => 'test' ),
     'Creating import study HPS::FastTrack object' );
is ( $hps_fast_track_import_study->database(), 'pathogen_hpsft_test', 'Database name comparison import for study');
is_deeply ( $hps_fast_track_import_study->pipeline(), ['import'], 'Pipeline types comparison import for study');
isa_ok ( $hps_fast_track_import_study->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Import' );
$hps_fast_track_import_study->pipeline_runners()->[0]->root('t/data/conf/');
is ( $hps_fast_track_import_study->pipeline_runners()->[0]->study_metadata->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Study name comparison import for study');

#print Dumper($hps_fast_track_import_study);

ok( $hps_fast_track_import_study->pipeline_runners()->[0]->command_to_run, 'Building run command for study import' );
ok ( -e $hps_fast_track_import_study->pipeline_runners()->[0]->config_files->{'low_level'}, 'Low level config file in place for study import' );

my @lines1 = read_file( $hps_fast_track_import_study->pipeline_runners()->[0]->config_files->{'low_level'} ) ;

is ($lines1[2], qq(            'database' => 'pathogen_hpsft_test',\n), 'Database in place for study import');
is ($lines1[21], qq(  'log' => 't/data/log/import_cram_logfile.log',\n), 'Log in place for study import');
is ($lines1[24], qq(                               'Comparative\\ RNA-seq\\ analysis\\ of\\ three\\ bacterial\\ species'\n), 'Project in place for study' );

my $expected_command1 = '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ';
$expected_command1 .= $hps_fast_track_import_study->pipeline_runners()->[0]->config_files->{'tempdir'};
$expected_command1 .= '/import_cram_pipeline_fast_track.conf -l t/data/log/fast_track_import_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.import_cram_pipeline.lock -m 500';

is ( $hps_fast_track_import_study->pipeline_runners()->[0]->command_to_run, $expected_command1, 'Command to run import pipeline for study' );

my $dir_to_remove1 = $hps_fast_track_import_study->pipeline_runners()->[0]->config_files->{'tempdir'};
`rm -rf $dir_to_remove1`;


ok ( my $hps_fast_track_import_lane =  Bio::HPS::FastTrack->new( lane => '8405_4#7', database => 'pathogen_hpsft_test', pipeline => ['import'], mode => 'test' ),
     'Creating import lane HPS::FastTrack object' );
is ( $hps_fast_track_import_lane->database(), 'pathogen_hpsft_test', 'Database name comparison import for one lane');
is_deeply ( $hps_fast_track_import_lane->pipeline(), ['import'], 'Pipeline types comparison import for one lane');
isa_ok ( $hps_fast_track_import_lane->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Import' );
$hps_fast_track_import_lane->pipeline_runners()->[0]->root('t/data/conf/');
is ( $hps_fast_track_import_lane->pipeline_runners()->[0]->lane_metadata->study_name(), 'Comparative RNA-seq analysis of three bacterial species', 'Study name comparison import for one lane');

ok( $hps_fast_track_import_lane->pipeline_runners()->[0]->command_to_run, 'Building run command' );
ok ( -e $hps_fast_track_import_lane->pipeline_runners()->[0]->config_files->{'low_level'}, 'Low level config file in place for importing one lane' );

my @lines2 = read_file( $hps_fast_track_import_lane->pipeline_runners()->[0]->config_files->{'low_level'} ) ;

is ($lines2[2], qq(            'database' => 'pathogen_hpsft_test',\n), 'Database in place for lane');
is ($lines2[21], qq(  'log' => 't/data/log/import_cram_logfile.log',\n), 'Log in place for lane');
is ($lines2[24], qq(                               '8405_4#7'\n), 'Lane id in place for lane' );

my $expected_command2 = '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ';
$expected_command2 .= $hps_fast_track_import_lane->pipeline_runners()->[0]->config_files->{'tempdir'};
$expected_command2 .= '/import_cram_pipeline_fast_track.conf -l t/data/log/fast_track_import_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.import_cram_pipeline.lock -m 500';

is ( $hps_fast_track_import_lane->pipeline_runners()->[0]->command_to_run, $expected_command2, 'Command to run import pipeline for importing one lane' );

my $dir_to_remove2 = $hps_fast_track_import_lane->pipeline_runners()->[0]->config_files->{'tempdir'};
`rm -rf $dir_to_remove2`;

done_testing();

