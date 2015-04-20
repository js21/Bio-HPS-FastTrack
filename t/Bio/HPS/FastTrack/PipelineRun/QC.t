#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use_ok('Bio::HPS::FastTrack::PipelineRun::QC');
  }

ok( my $qc_runner = Bio::HPS::FastTrack::PipelineRun::QC->new( study =>  'Comparative RNA seq analysis of three bacterial species', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a QC runner object');
isa_ok ( $qc_runner, 'Bio::HPS::FastTrack::PipelineRun::QC' );

done_testing();
