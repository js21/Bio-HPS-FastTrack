#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use File::Slurp;
    use_ok('Bio::HPS::FastTrack::PipelineRun::Assembly');
  }

ok( my $assembly_runner = Bio::HPS::FastTrack::PipelineRun::Assembly->new( study =>  'Comparative RNA seq analysis of three bacterial species', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a Assembly runner object');
isa_ok ( $assembly_runner, 'Bio::HPS::FastTrack::PipelineRun::Assembly' );
ok ( $assembly_runner->command_to_run, 'Build command to run for Assembly pipeline');
is ( $assembly_runner->command_to_run, '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ' . $assembly_runner->temp_dir . '/fast_track_assembly_pipeline.conf -l t/data/log/fast_track_assembly_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.assembly_pipeline.lock -m 500 -s 2', 'Building run command');
ok ( -e $assembly_runner->config_files->{'high_level'}, 'High level config file in place' );
my @lines = read_file($assembly_runner->config_files->{'high_level'});
is ( $lines[0], "__VRTrack_Assembly__ t/data/conf/fast_track/assembly/assembly_Comparative_RNA_seq_analysis_of_three_bacterial_species_velvet.conf\n", '1st line of high level config');
ok ( dir_to_remove($assembly_runner->config_files->{'tempdir'}->dirname), 'Removed temp dir' );


ok( my $assembly_runner2 = Bio::HPS::FastTrack::PipelineRun::Assembly->new( study =>  'Comparative RNA seq analysis of three bacterial species', lane =>  '8405_4#11', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a Assembly runner object');
isa_ok ( $assembly_runner2, 'Bio::HPS::FastTrack::PipelineRun::Assembly' );
ok ( $assembly_runner2->command_to_run, 'Build command to run for Assembly pipeline');
is ( $assembly_runner2->command_to_run, '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ' . $assembly_runner2->temp_dir . '/fast_track_assembly_pipeline.conf -l t/data/log/fast_track_assembly_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.assembly_pipeline.lock -m 500 -s 2', 'Building run command');
ok ( -e $assembly_runner2->config_files->{'high_level'}, 'High level config file in place' );
my @lines2 = read_file($assembly_runner2->config_files->{'high_level'});
is ( $lines2[0], "__VRTrack_Assembly__ t/data/conf/fast_track/assembly/assembly_Comparative_RNA_seq_analysis_of_three_bacterial_species_velvet.conf\n", '1st line of high level config');
ok ( dir_to_remove($assembly_runner2->config_files->{'tempdir'}->dirname), 'Removed temp dir' );

ok( my $assembly_runner3 = Bio::HPS::FastTrack::PipelineRun::Assembly->new( study =>  'Study Not registered', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a Assembly runner object');
isa_ok ( $assembly_runner3, 'Bio::HPS::FastTrack::PipelineRun::Assembly' );
throws_ok { $assembly_runner3->command_to_run } qr/Study/, 'Study not present in high_level_config';

ok( my $assembly_runner4 = Bio::HPS::FastTrack::PipelineRun::Assembly->new( lane =>  '8405_4#11', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a Assembly runner object');
isa_ok ( $assembly_runner4, 'Bio::HPS::FastTrack::PipelineRun::Assembly' );
throws_ok { $assembly_runner4->command_to_run } qr/Fast tracking Assembly for a specific lane is not yet possible/, 'Lane fast tracking feature not yet implemented';

done_testing();

sub dir_to_remove {
  my ($dir_to_remove) = @_ ;
  my $output = `rm -rf $dir_to_remove`;
  return 1 if ($output eq q());
}

