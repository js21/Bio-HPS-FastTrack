#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use_ok('Bio::HPS::FastTrack::PipelineRun::Import');
  }

ok( my $import_runner = Bio::HPS::FastTrack::PipelineRun::Import->new( study =>  'Comparative RNA seq analysis of three bacterial species', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating an Import runner object');
isa_ok ( $import_runner, 'Bio::HPS::FastTrack::PipelineRun::Import' );

done_testing();
