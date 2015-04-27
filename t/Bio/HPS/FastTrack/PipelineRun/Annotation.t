#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use File::Slurp;
    use_ok('Bio::HPS::FastTrack::PipelineRun::Annotation');
  }

ok( my $annotation_runner = Bio::HPS::FastTrack::PipelineRun::Annotation->new( study =>  'Comparative RNA seq analysis of three bacterial species', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a Annotation runner object');
isa_ok ( $annotation_runner, 'Bio::HPS::FastTrack::PipelineRun::Annotation' );
ok ( $annotation_runner->command_to_run, 'Build command to run for Annotation pipeline');
is ( $annotation_runner->command_to_run, '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ' . $annotation_runner->temp_dir . '/fast_track_annotate_assembly_pipeline.conf -l t/data/log/fast_track_annotate_assembly_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.annotate_assembly_pipeline.lock -m 500', 'Building run command');
ok ( -e $annotation_runner->config_files->{'high_level'}, 'High level config file in place' );
my @lines = read_file($annotation_runner->config_files->{'high_level'});
is ( $lines[0], "__VRTrack_AnnotateAssembly__ t/data/conf/fast_track/annotate_assembly/annotate_assembly_Comparative_RNA_seq_analysis_of_three_bacterial_species_velvet.conf\n", '1st line of high level config');
ok ( dir_to_remove($annotation_runner->config_files->{'tempdir'}->dirname), 'Removed temp dir' );


ok( my $annotation_runner2 = Bio::HPS::FastTrack::PipelineRun::Annotation->new( study =>  'Comparative RNA seq analysis of three bacterial species', lane =>  '8405_4#11', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a Annotation runner object');
isa_ok ( $annotation_runner2, 'Bio::HPS::FastTrack::PipelineRun::Annotation' );
ok ( $annotation_runner2->command_to_run, 'Build command to run for Annotation pipeline');
is ( $annotation_runner2->command_to_run, '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline -c ' . $annotation_runner2->temp_dir . '/fast_track_annotate_assembly_pipeline.conf -l t/data/log/fast_track_annotate_assembly_pipeline.log -v -v -L t/data/conf/fast_track/.pathogen_hpsft_test.annotate_assembly_pipeline.lock -m 500', 'Building run command');
ok ( -e $annotation_runner2->config_files->{'high_level'}, 'High level config file in place' );
my @lines2 = read_file($annotation_runner2->config_files->{'high_level'});
is ( $lines2[0], "__VRTrack_AnnotateAssembly__ t/data/conf/fast_track/annotate_assembly/annotate_assembly_Comparative_RNA_seq_analysis_of_three_bacterial_species_velvet.conf\n", '1st line of high level config');
ok ( dir_to_remove($annotation_runner2->config_files->{'tempdir'}->dirname), 'Removed temp dir' );

ok( my $annotation_runner3 = Bio::HPS::FastTrack::PipelineRun::Annotation->new( study =>  'Study Not registered', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a Annotation runner object');
isa_ok ( $annotation_runner3, 'Bio::HPS::FastTrack::PipelineRun::Annotation' );
throws_ok { $annotation_runner3->command_to_run } qr/Study/, 'Study not present in high_level_config';

ok( my $annotation_runner4 = Bio::HPS::FastTrack::PipelineRun::Annotation->new( lane =>  '8405_4#11', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a Annotation runner object');
isa_ok ( $annotation_runner4, 'Bio::HPS::FastTrack::PipelineRun::Annotation' );
throws_ok { $annotation_runner4->command_to_run } qr/Fast tracking Annotation for a specific lane is not yet possible/, 'Lane fast tracking feature not yet implemented';

done_testing();

sub dir_to_remove {
  my ($dir_to_remove) = @_ ;
  my $output = `rm -rf $dir_to_remove`;
  return 1 if ($output eq q());
}


