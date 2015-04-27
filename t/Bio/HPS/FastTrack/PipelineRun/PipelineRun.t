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

done_testing();
