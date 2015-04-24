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

#UPDATE PIPELINE
print "Update tests\n";
ok ( my $hps_fast_track_update =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['update'], mode => 'test' ), 'Creating update study HPS::FastTrack object' );
is ( $hps_fast_track_update->database(), 'pathogen_hpsft_test', 'Database name comparison update');
is_deeply ( $hps_fast_track_update->pipeline(), ['update'], 'Pipeline types comparison update');
isa_ok ( $hps_fast_track_update->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Update' );
is ( $hps_fast_track_update->pipeline_runners()->[0]->study_metadata->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Study id comparison update');
is ( $hps_fast_track_update->pipeline_runners()->[0]->command_to_run,
     q(/software/pathogen/projects/update_pipeline/bin/update_pipeline.pl -n 'Comparative RNA-seq analysis of three bacterial species' --database=pathogen_hpsft_test -l t/data/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock -nop -v --file_type cram),
     'Update command');

ok ( my $hps_fast_track_update_lane =  Bio::HPS::FastTrack->new( lane => '8405_4#7', database => 'pathogen_hpsft_test', pipeline => ['update'], mode => 'test' ), 'Creating update_lane HPS::FastTrack object' );
isa_ok ( $hps_fast_track_update_lane->pipeline_runners->[0], 'Bio::HPS::FastTrack::PipelineRun::Update' );
is ( $hps_fast_track_update_lane->pipeline_runners()->[0]->command_to_run(),
     q(/software/pathogen/projects/update_pipeline/bin/update_pipeline.pl -n 'Comparative RNA-seq analysis of three bacterial species' --database=pathogen_hpsft_test -run 8405 -min 8404 -l t/data/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock -nop -v --file_type cram),
     'Update command 2');
is ( $hps_fast_track_update_lane->pipeline_runners->[0]->study, 'Comparative RNA-seq analysis of three bacterial species', 'Study name' );


ok ( my $hps_fast_track_update_study_for_run =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', lane => '8405_4#7', database => 'pathogen_hpsft_test', pipeline => ['update'], mode => 'test' ), 'Creating update study for specific run id HPS::FastTrack object' );
is ( $hps_fast_track_update_study_for_run->database(), 'pathogen_hpsft_test', 'Database name comparison update');
is_deeply ( $hps_fast_track_update_study_for_run->pipeline(), ['update'], 'Pipeline types comparison update');
isa_ok ( $hps_fast_track_update_study_for_run->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Update' );
is ( $hps_fast_track_update_study_for_run->pipeline_runners()->[0]->study_metadata->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Study name comparison update');
is ( $hps_fast_track_update_study_for_run->pipeline_runners()->[0]->command_to_run,
     q(/software/pathogen/projects/update_pipeline/bin/update_pipeline.pl -n 'Comparative RNA-seq analysis of three bacterial species' --database=pathogen_hpsft_test -run 8405 -min 8404 -l t/data/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock -nop -v --file_type cram),
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



#IMPORT PIPELINE
print "Import tests\n";
ok ( my $hps_fast_track_import_study =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['import'], mode => 'test' ),
     'Creating import study HPS::FastTrack object' );
is ( $hps_fast_track_import_study->database(), 'pathogen_hpsft_test', 'Database name comparison import for study');
is_deeply ( $hps_fast_track_import_study->pipeline(), ['import'], 'Pipeline types comparison import for study');
isa_ok ( $hps_fast_track_import_study->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Import' );
$hps_fast_track_import_study->pipeline_runners()->[0]->root('t/data/conf/');
is ( $hps_fast_track_import_study->pipeline_runners()->[0]->study_metadata->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Study name comparison import for study');



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

ok ( dir_to_remove($hps_fast_track_import_study->pipeline_runners()->[0]->config_files->{'tempdir'}->dirname), 'Removing temp dir' );



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

ok ( dir_to_remove($hps_fast_track_import_lane->pipeline_runners()->[0]->config_files->{'tempdir'}->dirname), 'Removing temp dir' );



#QC PIPELINE

print "QC tests\n";
ok ( my $hps_fast_track_qc_study =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['qc'], mode => 'test' ),
     'Creating qc study HPS::FastTrack object' );
is ( $hps_fast_track_qc_study->database(), 'pathogen_hpsft_test', 'Database name comparison qc for study');
is_deeply ( $hps_fast_track_qc_study->pipeline(), ['qc'], 'Pipeline types comparison qc for study');
isa_ok ( $hps_fast_track_qc_study->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::QC' );

$hps_fast_track_qc_study->pipeline_runners()->[0]->root('t/data/conf/');

ok( $hps_fast_track_qc_study->pipeline_runners()->[0]->command_to_run, 'Building run command for study qc' );
ok ( -e $hps_fast_track_qc_study->pipeline_runners()->[0]->config_files->{'high_level'}, 'High level config file in place for study qc' );

my @lines3 = read_file( $hps_fast_track_qc_study->pipeline_runners()->[0]->config_files->{'high_level'} ) ;

is ( $lines3[0], "__VRTrack_QC__ t/data/conf/fast_track/qc/qc_Comparative_RNA_seq_analysis_of_three_bacterial_species_Clostridium_difficile.conf\n", '1st line of high level config');
is ( $lines3[1], "__VRTrack_QC__ t/data/conf/fast_track/qc/qc_Comparative_RNA_seq_analysis_of_three_bacterial_species_Streptococcus_pyogenes.conf\n", '2nd line of high level config');


my $expected_command3 = '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ';
$expected_command3 .= $hps_fast_track_qc_study->pipeline_runners()->[0]->config_files->{'tempdir'};
$expected_command3 .= '/fast_track_qc_pipeline.conf -l t/data/log/fast_track_qc_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.qc_pipeline.lock -m 500';
is ( $hps_fast_track_qc_study->pipeline_runners()->[0]->command_to_run, $expected_command3, 'Command to run qc pipeline for study' );

ok ( dir_to_remove($hps_fast_track_qc_study->pipeline_runners()->[0]->config_files->{'tempdir'}->dirname ), 'Removing temp dir' );

ok ( my $hps_fast_track_qc_lane =  Bio::HPS::FastTrack->new( lane => '8405_4#7', database => 'pathogen_hpsft_test', pipeline => ['qc'], mode => 'test' ),
     'Creating qc lane HPS::FastTrack object' );
is ( $hps_fast_track_qc_lane->database(), 'pathogen_hpsft_test', 'Database name comparison qc for one lane');
is_deeply ( $hps_fast_track_qc_lane->pipeline(), ['qc'], 'Pipeline types comparison qc for one lane');
isa_ok ( $hps_fast_track_qc_lane->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::QC' );

#$hps_fast_track_qc_lane->pipeline_runners()->[0]->root('t/data/conf/');

is ( $hps_fast_track_qc_lane->pipeline_runners()->[0]->lane_metadata->study_name(), 'Comparative RNA-seq analysis of three bacterial species', 'Study name comparison qc for one lane');

ok( $hps_fast_track_qc_lane->pipeline_runners()->[0]->command_to_run, 'Building run command' );
ok ( -e $hps_fast_track_qc_lane->pipeline_runners()->[0]->config_files->{'high_level'}, 'High level config file in place for qcing one lane' );

my @lines4 = read_file( $hps_fast_track_qc_lane->pipeline_runners()->[0]->config_files->{'high_level'} ) ;

is ( $lines4[0], "__VRTrack_QC__ t/data/conf/fast_track/qc/qc_Comparative_RNA_seq_analysis_of_three_bacterial_species_Clostridium_difficile.conf\n", '1st line of high level config');
is ( $lines4[1], "__VRTrack_QC__ t/data/conf/fast_track/qc/qc_Comparative_RNA_seq_analysis_of_three_bacterial_species_Streptococcus_pyogenes.conf\n", '2nd line of high level config');

my $expected_command4 = '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ';
$expected_command4 .= $hps_fast_track_qc_lane->pipeline_runners()->[0]->config_files->{'tempdir'};
$expected_command4 .= '/fast_track_qc_pipeline.conf -l t/data/log/fast_track_qc_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.qc_pipeline.lock -m 500';


is ( $hps_fast_track_qc_lane->pipeline_runners()->[0]->command_to_run, $expected_command4, 'Command to run qc pipeline for qcing one lane' );

ok ( dir_to_remove($hps_fast_track_qc_lane->pipeline_runners()->[0]->config_files->{'tempdir'}->dirname), 'Removing temp dir' );









done_testing();


sub dir_to_remove {
  my ($dir_to_remove) = @_ ;
  my $output = `rm -rf $dir_to_remove`;
  return 1 if ($output eq q());
}
