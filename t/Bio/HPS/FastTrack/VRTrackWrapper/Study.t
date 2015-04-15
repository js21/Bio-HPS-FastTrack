#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
  use Test::Most;
  use_ok('Bio::HPS::FastTrack::VRTrackWrapper::Study');
  }

ok( my $study = Bio::HPS::FastTrack::VRTrackWrapper::Study->new(study => 'Comparative RNA-seq analysis of three bacterial species' , database => 'pathogen_hpsft_test', mode => 'prod'), 'Study object creation' );
isa_ok( $study, 'Bio::HPS::FastTrack::VRTrackWrapper::Study');
isa_ok ( $study->vrtrack(), 'VRTrack::VRTrack' );
isa_ok( $study->vrtrack_study(), 'VRTrack::Project');
isa_ok( $study->lanes(), 'HASH' );
is( $study->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Full study name');
for my $lane(sort keys %{$study->lanes}) {
  isa_ok ( $study->lanes->{$lane}, 'VRTrack::Lane');
}

my $lane = $study->lanes()->{'8405_4#2'};
is($lane->processed, 0, 'Processed flag');
is($lane->name, '8405_4#2', 'Lane name');


ok( my $study2 = Bio::HPS::FastTrack::VRTrackWrapper::Study->new(study => 'Comparative RNA-seq analysis of three' , database => 'pathogen_prok_track_test', mode => 'prod'), 'Study object creation' );
isa_ok( $study2, 'Bio::HPS::FastTrack::VRTrackWrapper::Study');
isa_ok ( $study2->vrtrack(), 'VRTrack::VRTrack' );
isa_ok( $study2->vrtrack_study(), 'VRTrack::Project');
isa_ok( $study2->lanes(), 'HASH' );


ok( my $study3 = Bio::HPS::FastTrack::VRTrackWrapper::Study->new(study => 'Glabolabo' , database => 'pathogen_prok_track_test', mode => 'prod'), 'Study object creation' );
isa_ok( $study3, 'Bio::HPS::FastTrack::VRTrackWrapper::Study');
isa_ok ( $study3->vrtrack(), 'VRTrack::VRTrack' );
isa_ok( $study3->vrtrack_study(), 'VRProject');
isa_ok( $study3->lanes(), 'HASH' );

done_testing();

