#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use_ok('Bio::HPS::FastTrack::PipelineRun::Mapping');
  }

ok( my $mapping_runner = Bio::HPS::FastTrack::PipelineRun::Mapping->new( study =>  'Comparative RNA seq analysis of three bacterial species', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a Mapping runner object');
isa_ok ( $mapping_runner, 'Bio::HPS::FastTrack::PipelineRun::Mapping' );


done_testing();
