#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use_ok('Bio::HPS::FastTrack::PipelineRun::Update');
  }

ok( my $update_runner = Bio::HPS::FastTrack::PipelineRun::Update->new( study =>  'Comparative RNA-seq analysis of three bacterial species' , database => 'pathogen_hpsft_test', mode => 'prod' ), 'Creating a Mapping runner object');
isa_ok ( $update_runner, 'Bio::HPS::FastTrack::PipelineRun::Update' );
#ok ( $update_runner->study_metadata(), 'Creating study object');
#isa_ok ( $update_runner->study_metadata(), 'Bio::HPS::FastTrack::VRTrackWrapper::Study');
#ok ( $update_runner->study_metadata()->lanes(), 'Collecting lanes');
#ok ( $update_runner->study_metadata()->vrtrack_study(), 'Setting study');
$update_runner->run();

#print Dumper($update_runner);

#isa_ok ($update_runner->study_metadata()->lanes()->{'7153_1#20'}, 'VRTrack::Lane');

#print Dumper($update_runner);



ok( my $update_runner2 = Bio::HPS::FastTrack::PipelineRun::Update->new( study => 'Comparative RNA-seq analysis of three bacterial species', lane => '8405_4#7' , database => 'pathogen_hpsft_test', mode => 'prod' ), 'Creating a Mapping runner object');
isa_ok ( $update_runner2, 'Bio::HPS::FastTrack::PipelineRun::Update' );
$update_runner2->run();
#print Dumper($update_runner2);



#$update_runner2->in_config_file();

ok( my $update_runner3 = Bio::HPS::FastTrack::PipelineRun::Update->new( study => 'Non existent study' , database => 'pathogen_hpsft_test', mode => 'prod' ), 'Creating a Mapping runner object');
isa_ok ( $update_runner3, 'Bio::HPS::FastTrack::PipelineRun::Update' );
$update_runner3->run();
#print Dumper($update_runner3);


ok( my $update_runner4 = Bio::HPS::FastTrack::PipelineRun::Update->new( study => 'Comparative RNA-seq analysis' , database => 'pathogen_hpsft_test', mode => 'prod' ), 'Creating a Mapping runner object');
isa_ok ( $update_runner4, 'Bio::HPS::FastTrack::PipelineRun::Update' );
$update_runner4->run();
print Dumper($update_runner4);

=head

#ok ( $update_runner2->config_data(), 'Creating config object');
#ok ( $update_runner2->config_data->config_root('t/data/conf'), 'Set new root path' );
#is ( $update_runner2->config_data->path_to_high_level_config(), 'pathogen_prok_track_test.ilm.studies.test', 'High level config' );
#is ( $update_runner2->config_data->is_study_in_high_level_config(), 'yes', 'Study ready for metadata update' );

#print Dumper($update_runner2);




#8405_4#6
ok( my $update_runner4 = Bio::HPS::FastTrack::PipelineRun::Update->new( lane => '8405_4#6' , database => 'pathogen_prok_track_test', mode => 'prod' ), 'Creating a Update runner object');
isa_ok ( $update_runner4, 'Bio::HPS::FastTrack::PipelineRun::Update' );
$update_runner4->run();
#print Dumper($update_runner4);

=cut
done_testing();
