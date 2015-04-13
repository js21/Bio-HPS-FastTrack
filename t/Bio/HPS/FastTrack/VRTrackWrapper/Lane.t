#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
  use Test::Most;
  use Test::Exception;
  use_ok('Bio::HPS::FastTrack::VRTrackWrapper::Lane');
}


isa_ok ( my $hps_lane = Bio::HPS::FastTrack::VRTrackWrapper::Lane->new(
							     database => 'pathogen_prok_track_test',
							     mode => 'prod',
							     lane_name => '7229_2#35',
							    ),
   'Bio::HPS::FastTrack::VRTrackWrapper::Lane');

isa_ok ( $hps_lane->vrlane(), 'VRTrack::Lane');
#print Dumper($hps_lane);



isa_ok ( my $hps_lane2 = Bio::HPS::FastTrack::VRTrackWrapper::Lane->new(
							     database => 'pathogen_prok_track_test',
							     mode => 'prod',
							     lane_name => '8405_4#7',
							    ),
   'Bio::HPS::FastTrack::VRTrackWrapper::Lane');

isa_ok ( $hps_lane2->vrlane(), 'VRLane');
print Dumper($hps_lane2);

=head


ok( my $hps_lane = Bio::HPS::FastTrack::VRTrackObject::Lane->new(
								 database => 'pathogen_prok_track_test',
								 mode => 'prod',
								 study_name => 'Comparative_RNA_seq_analysis_of_three_bacterial_species',
								 sample_id => '19',
								 processed => '1',
								 lane_name => '7229_2#35',
								 storage_path => '/nfs/pathnfs02/hashed_lanes/pathogen_prok_track/f/6/3/b/7229_2#35'
								),
    'Lane object creation' );

isa_ok($hps_lane, 'Bio::HPS::FastTrack::VRTrackObject::Lane', 'Lane object');
is( $hps_lane->study_name(), 'Comparative_RNA_seq_analysis_of_three_bacterial_species', 'Study name');
is( $hps_lane->sample_id(), 19, 'Sample ID');
is( $hps_lane->processed(), 1, 'Processed flag');
is( $hps_lane->lane_name(), '7229_2#35', 'Lane name');
is( $hps_lane->storage_path(), '/nfs/pathnfs02/hashed_lanes/pathogen_prok_track/f/6/3/b/7229_2#35', 'Storage path');
is( $hps_lane->pipeline_stage(), 'no flag', 'Pipeline stage');
isa_ok($hps_lane->vrlane(), 'VRTrack::Lane');

print Dumper($hps_lane);

throws_ok{ my $hps_lane = Bio::HPS::FastTrack::VRTrackObject::Lane->new(
									database => 'pathogen_prok_track_test',
									mode => 'prod',
									study_name => 'Comparative_RNA_seq_analysis_of_three_bacterial_species',
									sample_id => '19',
									processed => '1',
									lane_name => '8405_4#6',
									storage_path => '/somewhere/over/the/rainbow'
								       )
	 } qr/does not exist in this filesystem/, 'Invalid storage path';


=cut


done_testing();
