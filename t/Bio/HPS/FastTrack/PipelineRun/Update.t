#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use_ok('Bio::HPS::FastTrack::PipelineRun::Update');
  }

=head

#ok( my $update_runner = Bio::HPS::FastTrack::PipelineRun::Update->new( study => 'Comparative RNA-seq analysis of three bacterial species', lane => '8405_4#7', database => 'pathogen_hpsft_test', mode => 'prod' ), 'Creating an Update runner object');
#ok( my $update_runner = Bio::HPS::FastTrack::PipelineRun::Update->new( study => 'ILB Global Pneumococcal Sequencing (GPS) study I (JP)', lane => '2874_7#9', database => 'pathogen_hpsft_test', mode => 'prod' ), 'Creating an Update runner object');
ok( my $update_runner = Bio::HPS::FastTrack::PipelineRun::Update->new( study => 'MRSA studies', lane => '15360_1#1', database => 'pathogen_hpsft_test', mode => 'prod' ), 'Creating an Update runner object');
isa_ok ( $update_runner, 'Bio::HPS::FastTrack::PipelineRun::Update' );
$update_runner->run();
print Dumper($update_runner);
exit;
is ( $update_runner->lock_file, '/lustre/scratch108/pathogen/js21/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock', 'Lock file string');
ok( -e $update_runner->lock_file, 'Lock file exists');
print Dumper($update_runner);

=cut

#=head

#ok( my $update_runner2 = Bio::HPS::FastTrack::PipelineRun::Update->new( lane => '15360_1#1', database => 'pathogen_hpsft_test' ), 'Creating an Update runner2 object');
ok( my $update_runner2 = Bio::HPS::FastTrack::PipelineRun::Update->new( lane => '8405_4#7', database => 'pathogen_hpsft_test' ), 'Creating an Update runner2 object');
isa_ok ( $update_runner2, 'Bio::HPS::FastTrack::PipelineRun::Update' );
is ( $update_runner2->update_command(),
     q(/software/pathogen/projects/update_pipeline/bin/update_pipeline.pl -n 'Comparative RNA-seq analysis of three bacterial species' --database=pathogen_hpsft_test -run 8405 -min 8404 -l /lustre/scratch108/pathogen/js21/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock -nop -v --file_type cram),
     'Update command to run');
#$update_runner2->run();
is ( $update_runner2->lock_file, '/lustre/scratch108/pathogen/js21/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock', 'Lock file string');



#=cut

done_testing();
