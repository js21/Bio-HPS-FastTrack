#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use_ok('Bio::HPS::FastTrack::PipelineRun::Annotation');
  }

ok( my $annotation_runner = Bio::HPS::FastTrack::PipelineRun::Annotation->new( study => 'Comparative RNA seq analysis of three bacterial species', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating a Annotation runner object');
isa_ok ( $annotation_runner, 'Bio::HPS::FastTrack::PipelineRun::Annotation' );


done_testing();
