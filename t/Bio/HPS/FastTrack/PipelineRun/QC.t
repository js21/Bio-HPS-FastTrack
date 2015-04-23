#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use File::Slurp;
    use_ok('Bio::HPS::FastTrack::PipelineRun::QC');
  }

ok( my $qc_runner = Bio::HPS::FastTrack::PipelineRun::QC->new( study =>  'Comparative RNA seq analysis of three bacterial species', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a QC runner object');
$qc_runner->root('t/data/conf/');
isa_ok ( $qc_runner, 'Bio::HPS::FastTrack::PipelineRun::QC' );
ok ( $qc_runner->command_to_run, 'Build command to run for QC pipeline');
ok ( -e $qc_runner->config_files->{'high_level'}, 'High level config file in place' );
my @lines = read_file($qc_runner->config_files->{'high_level'});
is ( $lines[0], "__VRTrack_QC__ t/data/conf/fast_track/qc/qc_Comparative_RNA_seq_analysis_of_three_bacterial_species_Clostridium_difficile.conf\n", '1st line of high level config');
is ( $lines[1], "__VRTrack_QC__ t/data/conf/fast_track/qc/qc_Comparative_RNA_seq_analysis_of_three_bacterial_species_Streptococcus_pyogenes.conf\n", '2nd line of high level config');
ok ( dir_to_remove($qc_runner->config_files->{'tempdir'}->dirname), 'Removed temp dir' );


ok( my $qc_runner2 = Bio::HPS::FastTrack::PipelineRun::QC->new( study =>  'Comparative RNA seq analysis of three bacterial species', lane =>  '8405_4#11', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a QC runner object');
$qc_runner2->root('t/data/conf/');
isa_ok ( $qc_runner2, 'Bio::HPS::FastTrack::PipelineRun::QC' );
ok ( $qc_runner2->command_to_run, 'Build command to run for QC pipeline');
ok ( -e $qc_runner2->config_files->{'high_level'}, 'High level config file in place' );
my @lines2 = read_file($qc_runner2->config_files->{'high_level'});
is ( $lines2[0], "__VRTrack_QC__ t/data/conf/fast_track/qc/qc_Comparative_RNA_seq_analysis_of_three_bacterial_species_Clostridium_difficile.conf\n", '1st line of high level config');
is ( $lines2[1], "__VRTrack_QC__ t/data/conf/fast_track/qc/qc_Comparative_RNA_seq_analysis_of_three_bacterial_species_Streptococcus_pyogenes.conf\n", '2nd line of high level config');
ok ( dir_to_remove($qc_runner2->config_files->{'tempdir'}->dirname), 'Removed temp dir' );

ok( my $qc_runner3 = Bio::HPS::FastTrack::PipelineRun::QC->new( study =>  'Study Not registered', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a QC runner object');
$qc_runner3->root('t/data/conf/');
isa_ok ( $qc_runner3, 'Bio::HPS::FastTrack::PipelineRun::QC' );
throws_ok { $qc_runner3->command_to_run } qr/Study/, 'Study not present in high_level_config';

ok( my $qc_runner4 = Bio::HPS::FastTrack::PipelineRun::QC->new( lane =>  '8405_4#11', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a QC runner object');
$qc_runner4->root('t/data/conf/');
isa_ok ( $qc_runner4, 'Bio::HPS::FastTrack::PipelineRun::QC' );
throws_ok { $qc_runner4->command_to_run } qr/Fast tracking QC for a specific lane is not yet possible/, 'Lane fast tracking feature not yet implemented';

done_testing();

sub dir_to_remove {
  my ($dir_to_remove) = @_ ;
  my $output = `rm -rf $dir_to_remove`;
  return 1 if ($output eq q());
}
