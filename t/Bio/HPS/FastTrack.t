#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
  use Test::Most;
  use Test::Exception;
  use_ok('Bio::HPS::FastTrack');
}


ok ( my $hps_fast_track_update =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['update'], mode => 'test' ), 'Creating update HPS::FastTrack object' );
is ( $hps_fast_track_update->database(), 'pathogen_hpsft_test', 'Database name comparison mapping');
is_deeply ( $hps_fast_track_update->pipeline(), ['update'], 'Pipeline types comparison mapping');
isa_ok ( $hps_fast_track_update->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Update' );
is ( $hps_fast_track_update->pipeline_runners()->[0]->study_metadata->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Study id comparison mapping');
is ( $hps_fast_track_update->pipeline_runners()->[0]->command_to_run,
     q(/software/pathogen/projects/update_pipeline/bin/update_pipeline.pl -n 'Comparative RNA-seq analysis of three bacterial species' --database=pathogen_hpsft_test -l /nfs/pathnfs05/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock -nop -v --file_type cram),
     'Update command');

ok ( my $hps_fast_track_update_lane =  Bio::HPS::FastTrack->new( lane => '8405_4#7', database => 'pathogen_hpsft_test', pipeline => ['update'], mode => 'test' ), 'Creating update_lane HPS::FastTrack object' );
isa_ok ( $hps_fast_track_update_lane->pipeline_runners->[0], 'Bio::HPS::FastTrack::PipelineRun::Update' );
is ( $hps_fast_track_update_lane->pipeline_runners()->[0]->command_to_run(),
     q(/software/pathogen/projects/update_pipeline/bin/update_pipeline.pl -n 'Comparative RNA-seq analysis of three bacterial species' --database=pathogen_hpsft_test -run 8405 -min 8404 -l /nfs/pathnfs05/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock -nop -v --file_type cram),
     'Update command');
is ( $hps_fast_track_update_lane->pipeline_runners->[0]->study, 'Comparative RNA-seq analysis of three bacterial species', 'Study name' );


ok ( my $hps_fast_track_update_study_for_run =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', lane => '8405_4#7', database => 'pathogen_hpsft_test', pipeline => ['update'], mode => 'test' ), 'Creating update HPS::FastTrack object' );
is ( $hps_fast_track_update_study_for_run->database(), 'pathogen_hpsft_test', 'Database name comparison mapping');
is_deeply ( $hps_fast_track_update_study_for_run->pipeline(), ['update'], 'Pipeline types comparison mapping');
isa_ok ( $hps_fast_track_update_study_for_run->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Update' );
is ( $hps_fast_track_update_study_for_run->pipeline_runners()->[0]->study_metadata->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Study id comparison mapping');
is ( $hps_fast_track_update_study_for_run->pipeline_runners()->[0]->command_to_run,
     q(/software/pathogen/projects/update_pipeline/bin/update_pipeline.pl -n 'Comparative RNA-seq analysis of three bacterial species' --database=pathogen_hpsft_test -run 8405 -min 8404 -l /nfs/pathnfs05/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock -nop -v --file_type cram),
     'Update command');

ok ( my $hps_fast_track_update_without_lane_or_study =  Bio::HPS::FastTrack->new( database => 'pathogen_hpsft_test', pipeline => ['update'], mode => 'test' ), 'Creating update HPS::FastTrack object' );
is ( $hps_fast_track_update_without_lane_or_study->database(), 'pathogen_hpsft_test', 'Database name comparison mapping');
is_deeply ( $hps_fast_track_update_without_lane_or_study->pipeline(), ['update'], 'Pipeline types comparison mapping');
throws_ok { $hps_fast_track_update_without_lane_or_study->pipeline_runners()->[0]} qr/Specify a lane or a study or both/, 'No study or lane specified';


throws_ok { my $hps_fast_track_update_without_database_with_lane = Bio::HPS::FastTrack->new( lane => '8405_4#7', pipeline => ['update'], mode => 'test' )
	  } qr/Attribute \(database\) is required/, 'Database requirement 1';

throws_ok { my $hps_fast_track_update_without_database_with_study = Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', pipeline => ['update'], mode => 'test' )
	  } qr/Attribute \(database\) is required/, 'Database requirement 2';

throws_ok { my $hps_fast_track_update_without_pipeline_with_lane = Bio::HPS::FastTrack->new( lane => '8405_4#7', database => 'pathogen_hpsft_test', mode => 'test' )
	  } qr/Attribute \(pipeline\) is required/, 'Pipeline requirement 1';

throws_ok { my $hps_fast_track_update_without_pipeline_with_study = Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', mode => 'test' )
	  } qr/Attribute \(pipeline\) is required/, 'Pipeline requirement 2';


done_testing();

=head


ok ( my $hps_fast_track_run_mode1 =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['mapping'], mode => 'prod' ), 'Creating mapping HPS::FastTrack object' );
is ( $hps_fast_track_run_mode1->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Study id comparison mapping');
is ( $hps_fast_track_run_mode1->mode(), 'prod', 'Run mode');

#ok ( my $hps_fast_track_run_mode2 =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['mapping'], mode => 'test' ), 'Creating mapping HPS::FastTrack object' );
#is ( $hps_fast_track_run_mode2->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Test study id comparison mapping');
#is ( $hps_fast_track_run_mode2->mode(), 'test', 'Test run mode');

throws_ok { my $hps_fast_track_run_mode3 =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['mapping'], mode => 'blah' ) } qr/Invalid run mode -/, 'Invalid run mode';


# ok ( my $hps_fast_track =  Bio::HPS::FastTrack->new( study => '2465', database => 'bacteria' ), 'Creating HPS::FastTrack object' );
# is ( $hps_fast_track->study(), '2465', 'Study id comparison');
# is ( $hps_fast_track->database(), 'bacteria', 'Database name comparison');
# is_deeply ( $hps_fast_track->pipeline(), [], 'Pipeline types comparison');
# isa_ok ( $hps_fast_track->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::PipelineRun' );
ok ( my $hps_fast_track_non_existant_database = Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'clown_database', pipeline => ['mapping'], mode => 'prod' ), 'Creating HPS::FastTrack object' );
throws_ok { $hps_fast_track_non_existant_database->run() } qr/Could not connect to database/ , 'Non existent database exception thrown' ;

ok ( my $hps_fast_track_mapping =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['mapping'], mode => 'prod' ), 'Creating mapping HPS::FastTrack object' );
is ( $hps_fast_track_mapping->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Study id comparison mapping');
is ( $hps_fast_track_mapping->database(), 'pathogen_hpsft_test', 'Database name comparison mapping');
is_deeply ( $hps_fast_track_mapping->pipeline(), ['mapping'], 'Pipeline types comparison mapping');
isa_ok ( $hps_fast_track_mapping->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Mapping' );
ok ( $hps_fast_track_mapping->pipeline_runners()->[0]->config_data()->config_root('blah/data/conf'), 'Setting false conf root path' );
is ( $hps_fast_track_mapping->pipeline_runners()->[0]->config_data()->config_root(), 'blah/data/conf', 'Inexistent path now' );
#throws_ok { $hps_fast_track_mapping->run() } qr/sysopen: No such file or directory at/ , 'Non existent config root exception thrown' ;



ok ( my $hps_fast_track_mapping2 =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['mapping'], mode => 'prod' ), 'Creating mapping HPS::FastTrack object' );
is ( $hps_fast_track_mapping2->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Study id comparison mapping');
is ( $hps_fast_track_mapping2->database(), 'pathogen_hpsft_test', 'Database name comparison mapping');
is_deeply ( $hps_fast_track_mapping2->pipeline(), ['mapping'], 'Pipeline types comparison mapping');
isa_ok ( $hps_fast_track_mapping2->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Mapping' );
ok ( $hps_fast_track_mapping2->pipeline_runners()->[0]->config_data()->config_root('t/data/conf'), 'Setting the test conf root path' );
is ( $hps_fast_track_mapping2->pipeline_runners()->[0]->config_data()->config_root(), 't/data/conf', 'Proper path now' );

$hps_fast_track_mapping2->run();
is ( $hps_fast_track_mapping2->pipeline_runners()->[0]->config_data()->path_to_high_level_config(), 't/data/conf/pathogen_hpsft_test/pathogen_hpsft_test_mapping_pipeline.conf', 'High level config' );
is ( $hps_fast_track_mapping2->pipeline_runners()->[0]->config_data()->path_to_low_level_config(),
     't/data/conf/pathogen_hpsft_test/mapping/mapping_Comparative_RNA_seq_analysis_of_three_bacterial_species_Streptococcus_pyogenes_Streptococcus_pyogenes_BC2_HKU16_v0.1_bwa.conf', 'Low level config' );



ok ( my $hps_fast_track_assembly_annotation =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['assembly','annotation'], mode => 'prod' ), 'Creating assembly and annotation HPS::FastTrack object' );
is ( $hps_fast_track_assembly_annotation->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Study id comparison assembly and annotation');
is ( $hps_fast_track_assembly_annotation->database(), 'pathogen_hpsft_test', 'Database name comparison assembly and annotation');
is_deeply ( $hps_fast_track_assembly_annotation->pipeline(), ['assembly','annotation'], 'Pipeline types comparison assembly and annotation');
isa_ok ( $hps_fast_track_assembly_annotation->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Assembly' );
isa_ok ( $hps_fast_track_assembly_annotation->pipeline_runners()->[1], 'Bio::HPS::FastTrack::PipelineRun::Annotation' );
ok ( $hps_fast_track_assembly_annotation->pipeline_runners()->[0]->config_data()->config_root('t/data/conf'), 'Setting the test conf root path for assembly runner');
is ( $hps_fast_track_assembly_annotation->pipeline_runners()->[0]->config_data()->config_root(), 't/data/conf', 'Proper conf root path for assembly runner');
ok ( $hps_fast_track_assembly_annotation->pipeline_runners()->[1]->config_data()->config_root('t/data/conf'), 'Setting the test conf root path for annotation runner');
is ( $hps_fast_track_assembly_annotation->pipeline_runners()->[1]->config_data()->config_root(), 't/data/conf', 'Proper conf root path for annotation runner');

$hps_fast_track_assembly_annotation->run();
is ( $hps_fast_track_assembly_annotation->pipeline_runners()->[0]->config_data()->path_to_high_level_config(), 't/data/conf/pathogen_hpsft_test/pathogen_hpsft_test_assembly_pipeline.conf', 'High level config' );
is ( $hps_fast_track_assembly_annotation->pipeline_runners()->[0]->config_data()->path_to_low_level_config(),
     't/data/conf/pathogen_hpsft_test/assembly/assembly_Comparative_RNA_seq_analysis_of_three_bacterial_species_velvet.conf', 'Low level config' );
is ( $hps_fast_track_assembly_annotation->pipeline_runners()->[1]->config_data()->path_to_high_level_config(), 't/data/conf/pathogen_hpsft_test/pathogen_hpsft_test_annotate_assembly_pipeline.conf', 'High level config' );
is ( $hps_fast_track_assembly_annotation->pipeline_runners()->[1]->config_data()->path_to_low_level_config(),
     't/data/conf/pathogen_hpsft_test/annotation/annotate_assembly_Comparative_RNA_seq_analysis_of_three_bacterial_species_Streptococcus_pyogenes_Streptococcus_pyogenes_BC2_HKU16_v0.1_bwa.conf', 'Low level config' );



ok ( my $hps_fast_track_snp_calling =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['snp-calling'], mode => 'prod' ), 'Creating snp-calling HPS::FastTrack object' );
is ( $hps_fast_track_snp_calling->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Study id comparison snp-calling');
is ( $hps_fast_track_snp_calling->database(), 'pathogen_hpsft_test', 'Database name comparison snp-calling');
is_deeply ( $hps_fast_track_snp_calling->pipeline(), ['snp-calling'], 'Pipeline types comparison snp-calling');
isa_ok ( $hps_fast_track_snp_calling->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::SNPCalling' );
ok ( $hps_fast_track_snp_calling->pipeline_runners()->[0]->config_data()->config_root('t/data/conf'), 'Setting the test conf root path for snp-calling runner');
is (  $hps_fast_track_snp_calling->pipeline_runners()->[0]->config_data()->config_root(), 't/data/conf', 'Proper conf root path for snp-calling runner');

$hps_fast_track_snp_calling->run();
is (  $hps_fast_track_snp_calling->pipeline_runners()->[0]->config_data()->path_to_high_level_config(), 't/data/conf/pathogen_hpsft_test/pathogen_hpsft_test_snps_pipeline.conf', 'High level config' );
is (  $hps_fast_track_snp_calling->pipeline_runners()->[0]->config_data()->path_to_low_level_config(),
      't/data/conf/pathogen_hpsft_test/snps/snps_Comparative_RNA_seq_analysis_of_three_bacterial_species_Streptococcus_pyogenes_Streptococcus_pyogenes_BC2_HKU16_v0.1_bwa.conf', 'Low level config' );



ok ( my $hps_fast_track_rna_seq =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['rna-seq'], mode => 'prod' ), 'Creating rna-seq HPS::FastTrack object' );
is ( $hps_fast_track_rna_seq->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Study id comparison rna-seq');
is ( $hps_fast_track_rna_seq->database(), 'pathogen_hpsft_test', 'Database name comparison rna-seq');
is_deeply ( $hps_fast_track_rna_seq->pipeline(), ['rna-seq'], 'Pipeline types comparison rna-seq');
isa_ok ( $hps_fast_track_rna_seq->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::RNASeqAnalysis' );
ok ( $hps_fast_track_rna_seq->pipeline_runners()->[0]->config_data()->config_root('t/data/conf'), 'Setting the test conf root path for rna-seq runner' );
is ( $hps_fast_track_rna_seq->pipeline_runners()->[0]->config_data()->config_root(), 't/data/conf', 'Proper conf root path for rna-seq runner' );

$hps_fast_track_rna_seq->run();
is ( $hps_fast_track_rna_seq->pipeline_runners()->[0]->config_data()->path_to_high_level_config(), 't/data/conf/pathogen_hpsft_test/pathogen_hpsft_test_rna_seq_pipeline.conf', 'High level config' );
is ( $hps_fast_track_rna_seq->pipeline_runners()->[0]->config_data()->path_to_low_level_config(),
    't/data/conf/pathogen_hpsft_test/rna_seq/rna_seq_Comparative_RNA_seq_analysis_of_three_bacterial_species_Streptococcus_pyogenes_Streptococcus_pyogenes_BC2_HKU16_v0.1_bwa.conf', 'Low level config' );


ok ( my $hps_fast_track_mapping_assembly_annotation =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['mapping','assembly','annotation'], mode => 'prod' ), 'Creating mapping, assembly and annotation HPS::FastTrack object' );
is ( $hps_fast_track_mapping_assembly_annotation->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Study id comparison mapping, assembly and annotation');
is ( $hps_fast_track_mapping_assembly_annotation->database(), 'pathogen_hpsft_test', 'Database name comparison mapping, assembly and annotation');
is_deeply ( $hps_fast_track_mapping_assembly_annotation->pipeline(), ['mapping','assembly','annotation'], 'Pipeline types comparison mapping, assembly and annotation');
isa_ok ( $hps_fast_track_mapping_assembly_annotation->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Mapping' );
isa_ok ( $hps_fast_track_mapping_assembly_annotation->pipeline_runners()->[1], 'Bio::HPS::FastTrack::PipelineRun::Assembly' );
isa_ok ( $hps_fast_track_mapping_assembly_annotation->pipeline_runners()->[2], 'Bio::HPS::FastTrack::PipelineRun::Annotation' );

ok ( my $hps_fast_track_all =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['all'], mode => 'prod' ), 'Creating all pipelines HPS::FastTrack object' );
throws_ok { $hps_fast_track_all->pipeline_runners() } qr/The requested pipeline is not supported/, 'Throws exception if pipeline is not supported';

=cut

