#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use_ok('Bio::HPS::FastTrack::PipelineRun::Assembly');
  }

ok( my $assembly_runner = Bio::HPS::FastTrack::PipelineRun::Assembly->new( study =>  'Comparative RNA seq analysis of three bacterial species', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a Assembly runner object');
isa_ok ( $assembly_runner, 'Bio::HPS::FastTrack::PipelineRun::Assembly' );

done_testing();
