#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use_ok('Bio::HPS::FastTrack::PipelineRun::SNPCalling');
  }

ok( my $snp_calling_runner = Bio::HPS::FastTrack::PipelineRun::SNPCalling->new( study =>  'Comparative RNA seq analysis of three bacterial species', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a SNPCalling runner object');
isa_ok ( $snp_calling_runner, 'Bio::HPS::FastTrack::PipelineRun::SNPCalling' );


done_testing();
