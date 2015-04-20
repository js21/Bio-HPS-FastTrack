#!/usr/bin/env perl
use Moose;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
with 'TestHelper';

BEGIN {
    use Test::Most;
    use_ok('Bio::HPS::FastTrack::SetPipeline');
  }

ok (my $bogus_pipeline = Bio::HPS::FastTrack::SetPipeline->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['blah'], mode => 'test' ), "Bogus object creation");
throws_ok { $bogus_pipeline->pipeline_runners() } qr/Error: The requested pipeline is not supported/ ,
  'Non existent pipeline exception thrown' ;

ok (my $pipeline = Bio::HPS::FastTrack::SetPipeline->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['update','import','qc','mapping','assembly','annotation','snp-calling','rna-seq'], mode => 'test' ), 'Object Creation');
isa_ok ( $pipeline, 'Bio::HPS::FastTrack::SetPipeline', 'SetPipeline module hook' );
is (scalar @{$pipeline->pipeline_runners()}, 8, 'All pipelines will be run');
isa_ok ( $pipeline->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Update');
isa_ok ( $pipeline->pipeline_runners()->[1], 'Bio::HPS::FastTrack::PipelineRun::Import');
isa_ok ( $pipeline->pipeline_runners()->[2], 'Bio::HPS::FastTrack::PipelineRun::QC');
isa_ok ( $pipeline->pipeline_runners()->[3], 'Bio::HPS::FastTrack::PipelineRun::Mapping');
isa_ok ( $pipeline->pipeline_runners()->[4], 'Bio::HPS::FastTrack::PipelineRun::Assembly');
isa_ok ( $pipeline->pipeline_runners()->[5], 'Bio::HPS::FastTrack::PipelineRun::Annotation');
isa_ok ( $pipeline->pipeline_runners()->[6], 'Bio::HPS::FastTrack::PipelineRun::SNPCalling');
isa_ok ( $pipeline->pipeline_runners()->[7], 'Bio::HPS::FastTrack::PipelineRun::RNASeqAnalysis');


done_testing();
