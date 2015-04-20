#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use_ok('Bio::HPS::FastTrack::PipelineRun::Update');
  }


ok( my $update_runner = Bio::HPS::FastTrack::PipelineRun::Update->new( study => 'MRSA studies', lane => '15360_1#1', database => 'pathogen_hpsft_test', mode => 'prod' ), 'Creating an Update runner object');
isa_ok ( $update_runner, 'Bio::HPS::FastTrack::PipelineRun::Update' );
is ( $update_runner->command_to_run(),
     q(/software/pathogen/projects/update_pipeline/bin/update_pipeline.pl -n 'MRSA studies' --database=pathogen_hpsft_test -run 15360 -min 15359 -l /nfs/pathnfs05/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock -nop -v --file_type cram),
     'Update command to run');
is ( $update_runner->lock_file, '/nfs/pathnfs05/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock', 'Lock file string');

ok( my $update_runner2 = Bio::HPS::FastTrack::PipelineRun::Update->new( lane => '8405_4#7', database => 'pathogen_hpsft_test', mode => 'test' ), 'Creating an Update runner2 object');
isa_ok ( $update_runner2, 'Bio::HPS::FastTrack::PipelineRun::Update' );
is ( $update_runner2->command_to_run(),
     q(/software/pathogen/projects/update_pipeline/bin/update_pipeline.pl -n 'Comparative RNA-seq analysis of three bacterial species' --database=pathogen_hpsft_test -run 8405 -min 8404 -l /nfs/pathnfs05/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock -nop -v --file_type cram),
     'Update command to run');

is ( $update_runner2->lock_file, '/nfs/pathnfs05/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock', 'Lock file string');

done_testing();
