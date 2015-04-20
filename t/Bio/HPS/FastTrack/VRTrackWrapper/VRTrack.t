#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
  use Test::Most;
  use Test::Exception;
  use_ok('Bio::HPS::FastTrack::VRTrackWrapper::VRTrack');
}

isa_ok ( my $hps_vrtrack = Bio::HPS::FastTrack::VRTrackWrapper::VRTrack->new( database => 'pathogen_hpsft_test', mode => 'test'), 'Bio::HPS::FastTrack::VRTrackWrapper::VRTrack' );
isa_ok ( my $vrtrack_obj = $hps_vrtrack->vrtrack(), 'VRTrack::VRTrack' );
is ( $hps_vrtrack->settings->{'test'}->{'host'}, 'patt-db', 'Test host' );
is ( $hps_vrtrack->settings->{'test'}->{'user'}, 'pathpipe_ro', 'Test user' );
is ( $hps_vrtrack->settings->{'test'}->{'port'}, 3346, 'Test port' );
is ( $vrtrack_obj->{_db_params}->{'host'}, $hps_vrtrack->settings->{'test'}->{'host'}, 'VRTrack host' );
is ( $vrtrack_obj->{_db_params}->{'user'}, $hps_vrtrack->settings->{'test'}->{'user'}, 'VRTrack user' );
is ( $vrtrack_obj->{_db_params}->{'port'}, $hps_vrtrack->settings->{'test'}->{'port'}, 'VRTrack port' );

done_testing();
