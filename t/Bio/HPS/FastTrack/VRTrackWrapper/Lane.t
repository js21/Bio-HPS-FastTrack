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
								       database => 'pathogen_hpsft_test',
								       lane_name => '9789_2#29',
								       mode => 'test',
								      ),
   'Bio::HPS::FastTrack::VRTrackWrapper::Lane');

throws_ok { $hps_lane->study_name() } qr/Could not retrieve the study name for lane/, 'No study name found';


isa_ok ( my $hps_lane2 = Bio::HPS::FastTrack::VRTrackWrapper::Lane->new(
									database => 'pathogen_hpsft_test',
									lane_name => '8405_4#7',
									mode => 'test',
								       ),
   'Bio::HPS::FastTrack::VRTrackWrapper::Lane');

is($hps_lane2->study_name(),'Comparative RNA-seq analysis of three bacterial species', 'Study name found');


done_testing();
