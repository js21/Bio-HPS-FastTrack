#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use_ok('Bio::HPS::FastTrack::PipelineRun::PipelineRun');
  }

ok( my $pipeline_runner = Bio::HPS::FastTrack::PipelineRun::PipelineRun->new( study =>  'Comparative RNA-seq analysis of three bacterial species', lane => '7138_6#17', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a Pipeline runner object');
$pipeline_runner->study_metadata();
$pipeline_runner->lane_metadata();
isa_ok ( $pipeline_runner, 'Bio::HPS::FastTrack::PipelineRun::PipelineRun' );
is( $pipeline_runner->db_alias, 'fast_track', 'Test database' );


=head



ok ( my $study = $pipeline_runner->study_metadata(), 'Creating study object');
isa_ok ( $study, 'Bio::HPS::FastTrack::VRTrackWrapper::Study');
ok ( $study->lanes(), 'Collecting lanes');

isa_ok ($study->lanes()->{'7138_6#17'}, 'VRTrack::Lane');
is( $study->vrtrack_study->hierarchy_name(), 'Comparative_RNA_seq_analysis_of_three_bacterial_species', 'Study name');
is( $study->lanes()->{'7138_6#17'}->processed(), 15, 'Processed flag');
is( $study->lanes()->{'7138_6#17'}->hierarchy_name(), '7138_6#17', 'Lane name');



ok( my $pipeline_runner2 = Bio::HPS::FastTrack::PipelineRun::PipelineRun->new( study =>  2027, database => 'pathogen_prok_track', mode => 'prod' ), 'Creating a Pipeline runner object');
is( $pipeline_runner2->db_alias, 'prokaryotes', 'Non standard database' );

ok( my $pipeline_runner3 = Bio::HPS::FastTrack::PipelineRun::PipelineRun->new( lane => '7138_6#17' , database => 'pathogen_prok_track_test', mode => 'prod' ), 'Creating a Pipeline runner object');

=cut

done_testing();
