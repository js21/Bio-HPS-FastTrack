#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use_ok('Bio::HPS::FastTrack::PipelineRun::RNASeqAnalysis');
  }

ok( my $rna_seq_analysis_runner = Bio::HPS::FastTrack::PipelineRun::RNASeqAnalysis->new( study =>  'Comparative RNA seq analysis of three bacterial species', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a RNASeqAnalysis runner object');
isa_ok ( $rna_seq_analysis_runner, 'Bio::HPS::FastTrack::PipelineRun::RNASeqAnalysis' );

done_testing();
