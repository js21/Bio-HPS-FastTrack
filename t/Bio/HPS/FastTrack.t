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



#MAPPING PIPELINE

print "Mapping tests\n";
ok ( my $hps_fast_track_mapping_study =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['mapping'], mode => 'test' ),
     'Creating mapping study HPS::FastTrack object' );
is ( $hps_fast_track_mapping_study->database(), 'pathogen_hpsft_test', 'Database name comparison mapping for study');
is_deeply ( $hps_fast_track_mapping_study->pipeline(), ['mapping'], 'Pipeline types comparison mapping for study');
isa_ok ( $hps_fast_track_mapping_study->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Mapping' );

$hps_fast_track_mapping_study->pipeline_runners()->[0]->root('t/data/conf/');

ok( $hps_fast_track_mapping_study->pipeline_runners()->[0]->command_to_run, 'Building run command for study mapping' );
ok ( -e $hps_fast_track_mapping_study->pipeline_runners()->[0]->config_files->{'high_level'}, 'High level config file in place for study mapping' );

my @lines5 = read_file( $hps_fast_track_mapping_study->pipeline_runners()->[0]->config_files->{'high_level'} ) ;

is ( $lines5[0], "__VRTrack_Mapping__ t/data/conf/fast_track/mapping/mapping_Comparative_RNA_seq_analysis_of_three_bacterial_species_Clostridium_difficil_83.conf\n", '1st line of high level config');
is ( $lines5[1],
     "__VRTrack_Mapping__ t/data/conf/fast_track/mapping/mapping_Comparative_RNA_seq_analysis_of_three_bacterial_species_Streptococcus_pyogenes_Streptococcus_pyogenes_BC2_HKU16_v0.1_bwa.conf\n",
     '2nd line of high level config');

my $expected_command5 = '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ';
$expected_command5 .= $hps_fast_track_mapping_study->pipeline_runners()->[0]->config_files->{'tempdir'};
$expected_command5 .= '/fast_track_mapping_pipeline.conf -l t/data/log/fast_track_mapping_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.mapping_pipeline.lock -m 500';
is ( $hps_fast_track_mapping_study->pipeline_runners()->[0]->command_to_run, $expected_command5, 'Command to run mapping pipeline for study' );

ok ( dir_to_remove($hps_fast_track_mapping_study->pipeline_runners()->[0]->config_files->{'tempdir'}->dirname ), 'Removing temp dir' );

ok ( my $hps_fast_track_mapping_lane =  Bio::HPS::FastTrack->new( lane => '8405_4#7', database => 'pathogen_hpsft_test', pipeline => ['mapping'], mode => 'test' ),
     'Creating mapping lane HPS::FastTrack object' );
is ( $hps_fast_track_mapping_lane->database(), 'pathogen_hpsft_test', 'Database name comparison mapping for one lane');
is_deeply ( $hps_fast_track_mapping_lane->pipeline(), ['mapping'], 'Pipeline types comparison mapping for one lane');
isa_ok ( $hps_fast_track_mapping_lane->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Mapping' );

is ( $hps_fast_track_mapping_lane->pipeline_runners()->[0]->lane_metadata->study_name(), 'Comparative RNA-seq analysis of three bacterial species', 'Study name comparison mapping for one lane');

ok( $hps_fast_track_mapping_lane->pipeline_runners()->[0]->command_to_run, 'Building run command' );
ok ( -e $hps_fast_track_mapping_lane->pipeline_runners()->[0]->config_files->{'high_level'}, 'High level config file in place for mappinging one lane' );

my @lines6= read_file( $hps_fast_track_mapping_lane->pipeline_runners()->[0]->config_files->{'high_level'} ) ;

is ( $lines6[0], "__VRTrack_Mapping__ t/data/conf/fast_track/mapping/mapping_Comparative_RNA_seq_analysis_of_three_bacterial_species_Clostridium_difficil_83.conf\n", '1st line of high level config');
is ( $lines6[1],
     "__VRTrack_Mapping__ t/data/conf/fast_track/mapping/mapping_Comparative_RNA_seq_analysis_of_three_bacterial_species_Streptococcus_pyogenes_Streptococcus_pyogenes_BC2_HKU16_v0.1_bwa.conf\n",
     '2nd line of high level config');

my $expected_command6 = '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ';
$expected_command6 .= $hps_fast_track_mapping_lane->pipeline_runners()->[0]->config_files->{'tempdir'};
$expected_command6 .= '/fast_track_mapping_pipeline.conf -l t/data/log/fast_track_mapping_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.mapping_pipeline.lock -m 500';


is ( $hps_fast_track_mapping_lane->pipeline_runners()->[0]->command_to_run, $expected_command6, 'Command to run mapping pipeline for mappinging one lane' );

ok ( dir_to_remove($hps_fast_track_mapping_lane->pipeline_runners()->[0]->config_files->{'tempdir'}->dirname), 'Removing temp dir' );


#ASSEMBLY PIPELINE

print "Assembly tests\n";
ok ( my $hps_fast_track_assembly_study =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['assembly'], mode => 'test' ),
     'Creating assembly study HPS::FastTrack object' );
is ( $hps_fast_track_assembly_study->database(), 'pathogen_hpsft_test', 'Database name comparison assembly for study');
is_deeply ( $hps_fast_track_assembly_study->pipeline(), ['assembly'], 'Pipeline types comparison assembly for study');
isa_ok ( $hps_fast_track_assembly_study->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Assembly' );

ok( $hps_fast_track_assembly_study->pipeline_runners()->[0]->command_to_run, 'Building run command for study assembly' );
ok ( -e $hps_fast_track_assembly_study->pipeline_runners()->[0]->config_files->{'high_level'}, 'High level config file in place for study assembly' );

my @lines7 = read_file( $hps_fast_track_assembly_study->pipeline_runners()->[0]->config_files->{'high_level'} ) ;

is ( $lines7[0], "__VRTrack_Assembly__ t/data/conf/fast_track/assembly/assembly_Comparative_RNA_seq_analysis_of_three_bacterial_species_velvet.conf\n", '1st line of high level config');

my $expected_command7 = '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ';
$expected_command7 .= $hps_fast_track_assembly_study->pipeline_runners()->[0]->config_files->{'tempdir'};
$expected_command7 .= '/fast_track_assembly_pipeline.conf -l t/data/log/fast_track_assembly_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.assembly_pipeline.lock -m 500';
is ( $hps_fast_track_assembly_study->pipeline_runners()->[0]->command_to_run, $expected_command7, 'Command to run assembly pipeline for study' );

ok ( dir_to_remove($hps_fast_track_assembly_study->pipeline_runners()->[0]->config_files->{'tempdir'}->dirname ), 'Removing temp dir' );

ok ( my $hps_fast_track_assembly_lane =  Bio::HPS::FastTrack->new( lane => '8405_4#7', database => 'pathogen_hpsft_test', pipeline => ['assembly'], mode => 'test' ),
     'Creating assembly lane HPS::FastTrack object' );
is ( $hps_fast_track_assembly_lane->database(), 'pathogen_hpsft_test', 'Database name comparison assembly for one lane');
is_deeply ( $hps_fast_track_assembly_lane->pipeline(), ['assembly'], 'Pipeline types comparison assembly for one lane');
isa_ok ( $hps_fast_track_assembly_lane->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Assembly' );

is ( $hps_fast_track_assembly_lane->pipeline_runners()->[0]->lane_metadata->study_name(), 'Comparative RNA-seq analysis of three bacterial species', 'Study name comparison assembly for one lane');

ok( $hps_fast_track_assembly_lane->pipeline_runners()->[0]->command_to_run, 'Building run command' );
ok ( -e $hps_fast_track_assembly_lane->pipeline_runners()->[0]->config_files->{'high_level'}, 'High level config file in place for assemblying one lane' );

my @lines8 = read_file( $hps_fast_track_assembly_lane->pipeline_runners()->[0]->config_files->{'high_level'} ) ;

is ( $lines8[0], "__VRTrack_Assembly__ t/data/conf/fast_track/assembly/assembly_Comparative_RNA_seq_analysis_of_three_bacterial_species_velvet.conf\n", '1st line of high level config');

my $expected_command8 = '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ';
$expected_command8 .= $hps_fast_track_assembly_lane->pipeline_runners()->[0]->config_files->{'tempdir'};
$expected_command8 .= '/fast_track_assembly_pipeline.conf -l t/data/log/fast_track_assembly_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.assembly_pipeline.lock -m 500';


is ( $hps_fast_track_assembly_lane->pipeline_runners()->[0]->command_to_run, $expected_command8, 'Command to run assembly pipeline for assemblying one lane' );

ok ( dir_to_remove($hps_fast_track_assembly_lane->pipeline_runners()->[0]->config_files->{'tempdir'}->dirname), 'Removing temp dir' );



#ANNOTATION PIPELINE

print "Annotation tests\n";
ok ( my $hps_fast_track_annotation_study =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['annotation'], mode => 'test' ),
     'Creating annotation study HPS::FastTrack object' );
is ( $hps_fast_track_annotation_study->database(), 'pathogen_hpsft_test', 'Database name comparison annotation for study');
is_deeply ( $hps_fast_track_annotation_study->pipeline(), ['annotation'], 'Pipeline types comparison annotation for study');
isa_ok ( $hps_fast_track_annotation_study->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Annotation' );


ok( $hps_fast_track_annotation_study->pipeline_runners()->[0]->command_to_run, 'Building run command for study annotation' );
ok ( -e $hps_fast_track_annotation_study->pipeline_runners()->[0]->config_files->{'high_level'}, 'High level config file in place for study annotation' );

my @lines9 = read_file( $hps_fast_track_annotation_study->pipeline_runners()->[0]->config_files->{'high_level'} ) ;

is ( $lines9[0], "__VRTrack_AnnotateAssembly__ t/data/conf/fast_track/annotate_assembly/annotate_assembly_Comparative_RNA_seq_analysis_of_three_bacterial_species_velvet.conf\n", '1st line of high level config');

my $expected_command9 = '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ';
$expected_command9 .= $hps_fast_track_annotation_study->pipeline_runners()->[0]->config_files->{'tempdir'};
$expected_command9 .= '/fast_track_annotate_assembly_pipeline.conf -l t/data/log/fast_track_annotate_assembly_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.annotate_assembly_pipeline.lock -m 500';
is ( $hps_fast_track_annotation_study->pipeline_runners()->[0]->command_to_run, $expected_command9, 'Command to run annotation pipeline for study' );

ok ( dir_to_remove($hps_fast_track_annotation_study->pipeline_runners()->[0]->config_files->{'tempdir'}->dirname ), 'Removing temp dir' );

ok ( my $hps_fast_track_annotation_lane =  Bio::HPS::FastTrack->new( lane => '8405_4#7', database => 'pathogen_hpsft_test', pipeline => ['annotation'], mode => 'test' ),
     'Creating annotation lane HPS::FastTrack object' );
is ( $hps_fast_track_annotation_lane->database(), 'pathogen_hpsft_test', 'Database name comparison annotation for one lane');
is_deeply ( $hps_fast_track_annotation_lane->pipeline(), ['annotation'], 'Pipeline types comparison annotation for one lane');
isa_ok ( $hps_fast_track_annotation_lane->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Annotation' );

is ( $hps_fast_track_annotation_lane->pipeline_runners()->[0]->lane_metadata->study_name(), 'Comparative RNA-seq analysis of three bacterial species', 'Study name comparison annotation for one lane');

ok( $hps_fast_track_annotation_lane->pipeline_runners()->[0]->command_to_run, 'Building run command' );
ok ( -e $hps_fast_track_annotation_lane->pipeline_runners()->[0]->config_files->{'high_level'}, 'High level config file in place for annotationing one lane' );

my @lines10 = read_file( $hps_fast_track_annotation_lane->pipeline_runners()->[0]->config_files->{'high_level'} ) ;

is ( $lines10[0], "__VRTrack_AnnotateAssembly__ t/data/conf/fast_track/annotate_assembly/annotate_assembly_Comparative_RNA_seq_analysis_of_three_bacterial_species_velvet.conf\n", '1st line of high level config');

my $expected_command10 = '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ';
$expected_command10 .= $hps_fast_track_annotation_lane->pipeline_runners()->[0]->config_files->{'tempdir'};
$expected_command10 .= '/fast_track_annotate_assembly_pipeline.conf -l t/data/log/fast_track_annotate_assembly_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.annotate_assembly_pipeline.lock -m 500';


is ( $hps_fast_track_annotation_lane->pipeline_runners()->[0]->command_to_run, $expected_command10, 'Command to run annotation pipeline for annotationing one lane' );

ok ( dir_to_remove($hps_fast_track_annotation_lane->pipeline_runners()->[0]->config_files->{'tempdir'}->dirname), 'Removing temp dir' );



#SNPCalling PIPELINE

print "SNPCalling tests\n";
ok ( my $hps_fast_track_snps_study =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['snp-calling'], mode => 'test' ),
     'Creating snps study HPS::FastTrack object' );
is ( $hps_fast_track_snps_study->database(), 'pathogen_hpsft_test', 'Database name comparison snps for study');
is_deeply ( $hps_fast_track_snps_study->pipeline(), ['snp-calling'], 'Pipeline types comparison snps for study');
isa_ok ( $hps_fast_track_snps_study->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::SNPCalling' );

ok( $hps_fast_track_snps_study->pipeline_runners()->[0]->command_to_run, 'Building run command for study snps' );
ok ( -e $hps_fast_track_snps_study->pipeline_runners()->[0]->config_files->{'high_level'}, 'High level config file in place for study snps' );

my @lines11 = read_file( $hps_fast_track_snps_study->pipeline_runners()->[0]->config_files->{'high_level'} ) ;

is ( $lines11[0], "__VRTrack_SNPs__ t/data/conf/fast_track/snps/snps_Comparative_RNA_seq_analysis_of_three_bacterial_species_Clostridium_difficil_83.conf\n", '1st line of high level config');

my $expected_command11 = '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ';
$expected_command11 .= $hps_fast_track_snps_study->pipeline_runners()->[0]->config_files->{'tempdir'};
$expected_command11 .= '/fast_track_snps_pipeline.conf -l t/data/log/fast_track_snps_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.snps_pipeline.lock -m 500';
is ( $hps_fast_track_snps_study->pipeline_runners()->[0]->command_to_run, $expected_command11, 'Command to run snps pipeline for study' );

ok ( dir_to_remove($hps_fast_track_snps_study->pipeline_runners()->[0]->config_files->{'tempdir'}->dirname ), 'Removing temp dir' );

ok ( my $hps_fast_track_snps_lane =  Bio::HPS::FastTrack->new( lane => '8405_4#7', database => 'pathogen_hpsft_test', pipeline => ['snp-calling'], mode => 'test' ),
     'Creating snps lane HPS::FastTrack object' );
is ( $hps_fast_track_snps_lane->database(), 'pathogen_hpsft_test', 'Database name comparison snps for one lane');
is_deeply ( $hps_fast_track_snps_lane->pipeline(), ['snp-calling'], 'Pipeline types comparison snps for one lane');
isa_ok ( $hps_fast_track_snps_lane->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::SNPCalling' );

is ( $hps_fast_track_snps_lane->pipeline_runners()->[0]->lane_metadata->study_name(), 'Comparative RNA-seq analysis of three bacterial species', 'Study name comparison snps for one lane');

ok( $hps_fast_track_snps_lane->pipeline_runners()->[0]->command_to_run, 'Building run command' );
ok ( -e $hps_fast_track_snps_lane->pipeline_runners()->[0]->config_files->{'high_level'}, 'High level config file in place for snpsing one lane' );

my @lines12 = read_file( $hps_fast_track_snps_lane->pipeline_runners()->[0]->config_files->{'high_level'} ) ;

is ( $lines12[0], "__VRTrack_SNPs__ t/data/conf/fast_track/snps/snps_Comparative_RNA_seq_analysis_of_three_bacterial_species_Clostridium_difficil_83.conf\n", '1st line of high level config');

my $expected_command12 = '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ';
$expected_command12 .= $hps_fast_track_snps_lane->pipeline_runners()->[0]->config_files->{'tempdir'};
$expected_command12 .= '/fast_track_snps_pipeline.conf -l t/data/log/fast_track_snps_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.snps_pipeline.lock -m 500';


is ( $hps_fast_track_snps_lane->pipeline_runners()->[0]->command_to_run, $expected_command12, 'Command to run snps pipeline for snpsing one lane' );

ok ( dir_to_remove($hps_fast_track_snps_lane->pipeline_runners()->[0]->config_files->{'tempdir'}->dirname), 'Removing temp dir' );


#RNASeq PIPELINE

print "RNASeq tests\n";
ok ( my $hps_fast_track_rna_seq_study =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['rna-seq'], mode => 'test' ),
     'Creating rna_seq study HPS::FastTrack object' );
is ( $hps_fast_track_rna_seq_study->database(), 'pathogen_hpsft_test', 'Database name comparison rna_seq for study');
is_deeply ( $hps_fast_track_rna_seq_study->pipeline(), ['rna-seq'], 'Pipeline types comparison rna_seq for study');
isa_ok ( $hps_fast_track_rna_seq_study->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::RNASeqAnalysis' );

ok( $hps_fast_track_rna_seq_study->pipeline_runners()->[0]->command_to_run, 'Building run command for study rna_seq' );
ok ( -e $hps_fast_track_rna_seq_study->pipeline_runners()->[0]->config_files->{'high_level'}, 'High level config file in place for study rna_seq' );

my @lines13 = read_file( $hps_fast_track_rna_seq_study->pipeline_runners()->[0]->config_files->{'high_level'} ) ;

is ( $lines13[0], "__VRTrack_RNASeqExpression__ t/data/conf/fast_track/rna_seq/rna_seq_Comparative_RNA_seq_analysis_of_three_bacterial_species_Clostridium_difficil_840.conf\n", '1st line of high level config');

my $expected_command13 = '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ';
$expected_command13 .= $hps_fast_track_rna_seq_study->pipeline_runners()->[0]->config_files->{'tempdir'};
$expected_command13 .= '/fast_track_rna_seq_pipeline.conf -l t/data/log/fast_track_rna_seq_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.rna_seq_pipeline.lock -m 500';
is ( $hps_fast_track_rna_seq_study->pipeline_runners()->[0]->command_to_run, $expected_command13, 'Command to run rna_seq pipeline for study' );

ok ( dir_to_remove($hps_fast_track_rna_seq_study->pipeline_runners()->[0]->config_files->{'tempdir'}->dirname ), 'Removing temp dir' );

ok ( my $hps_fast_track_rna_seq_lane =  Bio::HPS::FastTrack->new( lane => '8405_4#7', database => 'pathogen_hpsft_test', pipeline => ['rna-seq'], mode => 'test' ),
     'Creating rna_seq lane HPS::FastTrack object' );
is ( $hps_fast_track_rna_seq_lane->database(), 'pathogen_hpsft_test', 'Database name comparison rna_seq for one lane');
is_deeply ( $hps_fast_track_rna_seq_lane->pipeline(), ['rna-seq'], 'Pipeline types comparison rna_seq for one lane');
isa_ok ( $hps_fast_track_rna_seq_lane->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::RNASeqAnalysis' );

is ( $hps_fast_track_rna_seq_lane->pipeline_runners()->[0]->lane_metadata->study_name(), 'Comparative RNA-seq analysis of three bacterial species', 'Study name comparison rna_seq for one lane');

ok( $hps_fast_track_rna_seq_lane->pipeline_runners()->[0]->command_to_run, 'Building run command' );
ok ( -e $hps_fast_track_rna_seq_lane->pipeline_runners()->[0]->config_files->{'high_level'}, 'High level config file in place for rna_seqing one lane' );

my @lines14 = read_file( $hps_fast_track_rna_seq_lane->pipeline_runners()->[0]->config_files->{'high_level'} ) ;

is ( $lines14[0], "__VRTrack_RNASeqExpression__ t/data/conf/fast_track/rna_seq/rna_seq_Comparative_RNA_seq_analysis_of_three_bacterial_species_Clostridium_difficil_840.conf\n", '1st line of high level config');

my $expected_command14 = '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ';
$expected_command14 .= $hps_fast_track_rna_seq_lane->pipeline_runners()->[0]->config_files->{'tempdir'};
$expected_command14 .= '/fast_track_rna_seq_pipeline.conf -l t/data/log/fast_track_rna_seq_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.rna_seq_pipeline.lock -m 500';


is ( $hps_fast_track_rna_seq_lane->pipeline_runners()->[0]->command_to_run, $expected_command14, 'Command to run rna_seq pipeline for rna_seqing one lane' );

ok ( dir_to_remove($hps_fast_track_rna_seq_lane->pipeline_runners()->[0]->config_files->{'tempdir'}->dirname), 'Removing temp dir' );


#All common PIPELINES

print "All common pipelines tests( qc..rna-seq )\n";
my @pipelines = qw(qc mapping assembly annotation snp-calling rna-seq);
ok ( my $hps_fast_track_all_pipelines =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => \@pipelines, mode => 'test' ),
     'Creating several pipeline HPS::FastTrack objects' );
is ( $hps_fast_track_all_pipelines->database(), 'pathogen_hpsft_test', 'Database name comparison rna_seq for study');
is_deeply ( $hps_fast_track_all_pipelines->pipeline(), ['qc', 'mapping', 'assembly', 'annotation', 'snp-calling', 'rna-seq'], 'Pipeline types comparison rna_seq for study');
isa_ok ( $hps_fast_track_all_pipelines->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::QC' );
isa_ok ( $hps_fast_track_all_pipelines->pipeline_runners()->[1], 'Bio::HPS::FastTrack::PipelineRun::Mapping' );
isa_ok ( $hps_fast_track_all_pipelines->pipeline_runners()->[2], 'Bio::HPS::FastTrack::PipelineRun::Assembly' );
isa_ok ( $hps_fast_track_all_pipelines->pipeline_runners()->[3], 'Bio::HPS::FastTrack::PipelineRun::Annotation' );
isa_ok ( $hps_fast_track_all_pipelines->pipeline_runners()->[4], 'Bio::HPS::FastTrack::PipelineRun::SNPCalling' );
isa_ok ( $hps_fast_track_all_pipelines->pipeline_runners()->[5], 'Bio::HPS::FastTrack::PipelineRun::RNASeqAnalysis' );


done_testing();


sub dir_to_remove {
  my ($dir_to_remove) = @_ ;
  my $output = `rm -rf $dir_to_remove`;
  return 1 if ($output eq q());
}
