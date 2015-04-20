#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
  use Test::Most;
  use Test::Exception;
  use_ok('Bio::HPS::FastTrack');
}


ok ( my $hps_fast_track_update =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['update'], mode => 'test' ), 'Creating update study HPS::FastTrack object' );
is ( $hps_fast_track_update->database(), 'pathogen_hpsft_test', 'Database name comparison update');
is_deeply ( $hps_fast_track_update->pipeline(), ['update'], 'Pipeline types comparison update');
isa_ok ( $hps_fast_track_update->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Update' );
is ( $hps_fast_track_update->pipeline_runners()->[0]->study_metadata->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Study id comparison update');
is ( $hps_fast_track_update->pipeline_runners()->[0]->command_to_run,
     q(/software/pathogen/projects/update_pipeline/bin/update_pipeline.pl -n 'Comparative RNA-seq analysis of three bacterial species' --database=pathogen_hpsft_test -l /nfs/pathnfs05/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock -nop -v --file_type cram),
     'Update command');

ok ( my $hps_fast_track_update_lane =  Bio::HPS::FastTrack->new( lane => '8405_4#7', database => 'pathogen_hpsft_test', pipeline => ['update'], mode => 'test' ), 'Creating update_lane HPS::FastTrack object' );
isa_ok ( $hps_fast_track_update_lane->pipeline_runners->[0], 'Bio::HPS::FastTrack::PipelineRun::Update' );
is ( $hps_fast_track_update_lane->pipeline_runners()->[0]->command_to_run(),
     q(/software/pathogen/projects/update_pipeline/bin/update_pipeline.pl -n 'Comparative RNA-seq analysis of three bacterial species' --database=pathogen_hpsft_test -run 8405 -min 8404 -l /nfs/pathnfs05/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock -nop -v --file_type cram),
     'Update command 2');
is ( $hps_fast_track_update_lane->pipeline_runners->[0]->study, 'Comparative RNA-seq analysis of three bacterial species', 'Study name' );


ok ( my $hps_fast_track_update_study_for_run =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', lane => '8405_4#7', database => 'pathogen_hpsft_test', pipeline => ['update'], mode => 'test' ), 'Creating update study for specific run id HPS::FastTrack object' );
is ( $hps_fast_track_update_study_for_run->database(), 'pathogen_hpsft_test', 'Database name comparison update');
is_deeply ( $hps_fast_track_update_study_for_run->pipeline(), ['update'], 'Pipeline types comparison update');
isa_ok ( $hps_fast_track_update_study_for_run->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Update' );
is ( $hps_fast_track_update_study_for_run->pipeline_runners()->[0]->study_metadata->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Study name comparison update');
is ( $hps_fast_track_update_study_for_run->pipeline_runners()->[0]->command_to_run,
     q(/software/pathogen/projects/update_pipeline/bin/update_pipeline.pl -n 'Comparative RNA-seq analysis of three bacterial species' --database=pathogen_hpsft_test -run 8405 -min 8404 -l /nfs/pathnfs05/conf/fast_track/.pathogen_hpsft_test.update_pipeline.lock -nop -v --file_type cram),
     'Update command 3');

ok ( my $hps_fast_track_update_without_lane_or_study =  Bio::HPS::FastTrack->new( database => 'pathogen_hpsft_test', pipeline => ['update'], mode => 'test' ), 'Creating update HPS::FastTrack object without lane or study' );
is ( $hps_fast_track_update_without_lane_or_study->database(), 'pathogen_hpsft_test', 'Database name comparison update without lane or study');
is_deeply ( $hps_fast_track_update_without_lane_or_study->pipeline(), ['update'], 'Pipeline types comparison update without lane or study');
throws_ok { $hps_fast_track_update_without_lane_or_study->pipeline_runners()->[0]} qr/Specify a lane or a study or both/, 'No study or lane specified';

throws_ok { my $hps_fast_track_update_without_database_with_lane = Bio::HPS::FastTrack->new( lane => '8405_4#7', pipeline => ['update'], mode => 'test' )
	  } qr/Attribute \(database\) is required/, 'Database requirement 1';

throws_ok { my $hps_fast_track_update_without_database_with_study = Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', pipeline => ['update'], mode => 'test' )
	  } qr/Attribute \(database\) is required/, 'Database requirement 2';

throws_ok { my $hps_fast_track_update_without_pipeline_with_lane = Bio::HPS::FastTrack->new( lane => '8405_4#7', database => 'pathogen_hpsft_test', mode => 'test' )
	  } qr/Attribute \(pipeline\) is required/, 'Pipeline requirement 1';

throws_ok { my $hps_fast_track_update_without_pipeline_with_study = Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', mode => 'test' )
	  } qr/Attribute \(pipeline\) is required/, 'Pipeline requirement 2';


ok ( my $hps_fast_track_import =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', database => 'pathogen_hpsft_test', pipeline => ['import'], mode => 'test' ),
     'Creating import study HPS::FastTrack object' );
is ( $hps_fast_track_import->database(), 'pathogen_hpsft_test', 'Database name comparison import');
is_deeply ( $hps_fast_track_import->pipeline(), ['import'], 'Pipeline types comparison import');
isa_ok ( $hps_fast_track_import->pipeline_runners()->[0], 'Bio::HPS::FastTrack::PipelineRun::Import' );
is ( $hps_fast_track_import->pipeline_runners()->[0]->study_metadata->study(), 'Comparative RNA-seq analysis of three bacterial species', 'Study id comparison import');


done_testing();

