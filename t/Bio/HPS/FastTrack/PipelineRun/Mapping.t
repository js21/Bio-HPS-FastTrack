#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use File::Slurp;
    use_ok('Bio::HPS::FastTrack::PipelineRun::Mapping');
  }

ok( my $mapping_runner = Bio::HPS::FastTrack::PipelineRun::Mapping->new( study =>  'Comparative RNA seq analysis of three bacterial species', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a Mapping runner object');
isa_ok ( $mapping_runner, 'Bio::HPS::FastTrack::PipelineRun::Mapping' );
ok ( $mapping_runner->command_to_run, 'Build command to run for Mapping pipeline');
is ( $mapping_runner->command_to_run, '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ' . $mapping_runner->temp_dir . '/fast_track_mapping_pipeline.conf -l t/data/log/fast_track_mapping_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.mapping_pipeline.lock -m 500 -s 2', 'Building run command');
ok ( -e $mapping_runner->config_files->{'high_level'}, 'High level config file in place' );
my @lines = read_file($mapping_runner->config_files->{'high_level'});
is ( $lines[0], "__VRTrack_Mapping__ t/data/conf/fast_track/mapping/mapping_Comparative_RNA_seq_analysis_of_three_bacterial_species_Clostridium_difficil_83.conf\n", '1st line of high level config');
is ( $lines[1], "__VRTrack_Mapping__ t/data/conf/fast_track/mapping/mapping_Comparative_RNA_seq_analysis_of_three_bacterial_species_Streptococcus_pyogenes_Streptococcus_pyogenes_BC2_HKU16_v0.1_bwa.conf\n", '2nd line of high level config');
ok ( dir_to_remove($mapping_runner->config_files->{'tempdir'}->dirname), 'Removed temp dir' );


ok( my $mapping_runner2 = Bio::HPS::FastTrack::PipelineRun::Mapping->new( study =>  'Comparative RNA seq analysis of three bacterial species', lane =>  '8405_4#11', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a Mapping runner object');
isa_ok ( $mapping_runner2, 'Bio::HPS::FastTrack::PipelineRun::Mapping' );
ok ( $mapping_runner2->command_to_run, 'Build command to run for Mapping pipeline');
is ( $mapping_runner2->command_to_run, '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ' . $mapping_runner2->temp_dir . '/fast_track_mapping_pipeline.conf -l t/data/log/fast_track_mapping_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.mapping_pipeline.lock -m 500 -s 2', 'Building run command');
ok ( -e $mapping_runner2->config_files->{'high_level'}, 'High level config file in place' );
my @lines2 = read_file($mapping_runner2->config_files->{'high_level'});
is ( $lines2[0], "__VRTrack_Mapping__ t/data/conf/fast_track/mapping/mapping_Comparative_RNA_seq_analysis_of_three_bacterial_species_Clostridium_difficil_83.conf\n", '1st line of high level config');
is ( $lines2[1], "__VRTrack_Mapping__ t/data/conf/fast_track/mapping/mapping_Comparative_RNA_seq_analysis_of_three_bacterial_species_Streptococcus_pyogenes_Streptococcus_pyogenes_BC2_HKU16_v0.1_bwa.conf\n", '2nd line of high level config');
ok ( dir_to_remove($mapping_runner2->config_files->{'tempdir'}->dirname), 'Removed temp dir' );

ok( my $mapping_runner3 = Bio::HPS::FastTrack::PipelineRun::Mapping->new( study =>  'Study Not registered', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a Mapping runner object');
isa_ok ( $mapping_runner3, 'Bio::HPS::FastTrack::PipelineRun::Mapping' );
throws_ok { $mapping_runner3->command_to_run } qr/Study/, 'Study not present in high_level_config';

ok( my $mapping_runner4 = Bio::HPS::FastTrack::PipelineRun::Mapping->new( lane =>  '8405_4#11', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a Mapping runner object');
isa_ok ( $mapping_runner4, 'Bio::HPS::FastTrack::PipelineRun::Mapping' );
throws_ok { $mapping_runner4->command_to_run } qr/Fast tracking Mapping for a specific lane is not yet possible/, 'Lane fast tracking feature not yet implemented';

done_testing();

sub dir_to_remove {
  my ($dir_to_remove) = @_ ;
  my $output = `rm -rf $dir_to_remove`;
  return 1 if ($output eq q());
}

