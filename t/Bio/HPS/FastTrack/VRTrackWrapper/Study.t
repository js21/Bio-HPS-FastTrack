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
isa_ok( $study, 'Bio::HPS::FastTrack::VRTrackWrapper::Study', 'Study object');
isa_ok ( $study->vrtrack(), 'VRTrack::VRTrack' );
isa_ok( $study->vrtrack_study(), 'VRTrack::Project');
isa_ok( $study->lanes(), 'HASH' );
for my $lane(sort keys %{$study->lanes}) {
  isa_ok ( $study->lanes->{$lane}, 'VRTrack::Lane');
}

#print Dumper($study);

ok( my $study2 = Bio::HPS::FastTrack::VRTrackWrapper::Study->new(study => 'Comparative RNA-seq analysis of three' , database => 'pathogen_prok_track_test', mode => 'prod'), 'Study object creation' );
isa_ok( $study2, 'Bio::HPS::FastTrack::VRTrackWrapper::Study', 'Study object');
isa_ok ( $study2->vrtrack(), 'VRTrack::VRTrack' );
isa_ok( $study2->vrtrack_study(), 'VRTrack::Project');
isa_ok( $study2->lanes(), 'HASH' );


ok( my $study3 = Bio::HPS::FastTrack::VRTrackWrapper::Study->new(study => 'Glabolabo' , database => 'pathogen_prok_track_test', mode => 'prod'), 'Study object creation' );
isa_ok( $study3, 'Bio::HPS::FastTrack::VRTrackWrapper::Study', 'Study object');
isa_ok ( $study3->vrtrack(), 'VRTrack::VRTrack' );
isa_ok( $study3->vrtrack_study(), 'VRProject');
isa_ok( $study3->lanes(), 'HASH' );

#print Dumper($study2);



=head


is($study->study_name, 'Comparative_RNA_seq_analysis_of_three_bacterial_species', 'Study name');

my $lane = $study->lanes()->[0];
is($lane->study_name, 'Comparative_RNA_seq_analysis_of_three_bacterial_species', 'Lane study name');
is($lane->sample_id, 79, 'Sample ID');
is($lane->processed, 15, 'Processed flag');
is($lane->lane_name, '7138_6#17', 'Lane name');
is($lane->storage_path, 'no storage path retrieved', 'Storage path');
is($lane->pipeline_stage, 'no flag', 'Pipeline Stage');

#print Dumper($study);

=cut

done_testing();

