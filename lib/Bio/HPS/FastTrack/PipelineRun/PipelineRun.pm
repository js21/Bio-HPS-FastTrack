package Bio::HPS::FastTrack::PipelineRun::PipelineRun;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $mapping_analysis_runner = Bio::HPS::FastTrack::PipelineRun::PipelineRun->new( database => 'pathogen_prok_track_test')

=cut

use Moose;
use Bio::HPS::FastTrack::VRTrackWrapper::Study;
use Bio::HPS::FastTrack::VRTrackWrapper::Lane;
use Bio::HPS::FastTrack::Config;
use Bio::HPS::FastTrack::Exception;

has 'stage_done'   => ( is => 'ro', isa => 'Str', default => 'NA');
has 'stage_not_done'   => ( is => 'ro', isa => 'Str', default => 'NA');
has 'add_to_config_path' => ( is => 'ro', isa => 'Str', default => 'NA');
has 'pipeline_exec' => ( is => 'ro' => isa => 'Str', default => 'NA' );

has 'study' => ( is => 'rw', isa => 'Str', required => 1 );
has 'database'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'mode'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'lane' => ( is => 'rw', isa => 'Str', lazy => 1, default => '');

has 'pipeline_runner' => ( is => 'rw', isa => 'HashRef', lazy => 1, builder => '_build_pipeline_runner' );
has 'db_alias' => ( is => 'rw', isa => 'Str', lazy => 1, builder => '_build_db_alias' );
has 'study_metadata' => ( is => 'rw', isa => 'Bio::HPS::FastTrack::VRTrackWrapper::Study', lazy => 1, builder => '_build_study_metadata') ;
has 'lane_metadata' => ( is => 'rw', isa => 'Bio::HPS::FastTrack::VRTrackWrapper::Lane', lazy => 1, builder => '_build_lane_metadata') ;
has 'config_data' => ( is => 'rw', isa => 'Bio::HPS::FastTrack::Config', lazy => 1, builder => '_build_config_data') ;
has 'lanes_pipeline_stage' => ( is => 'rw', isa => 'HashRef', lazy => 1, default => sub { {} } );
has 'study_pipeline_stage' => ( is => 'rw', isa => 'HashRef', lazy => 1, default => sub { {} } );

sub _build_pipeline_runner {

  my ($self) = @_;
  return {};

}

sub _build_db_alias {

  my ($self) = @_;
  my %database_aliases = (
				'pathogen_virus_track'    => 'viruses',
				'pathogen_prok_track'     => 'prokaryotes',
				'pathogen_euk_track'      => 'eukaryotes',
				'pathogen_helminth_track' => 'helminths',
				'pathogen_rnd_track'      => 'rnd'
			       );

  if ( $database_aliases{$self->database()} ) {
    return( $database_aliases{$self->database()} );
  }
  else {
    return( 'no alias' );
  }
}

sub _build_study_metadata {

  my ($self) = @_;
  my $study = Bio::HPS::FastTrack::VRTrackWrapper::Study->new( study => $self->study(), database => $self->database(), mode => $self->mode  );
  $study->lanes();
  return $study;
}

sub _build_lane_metadata {

  my ($self) = @_;
  my $lane = Bio::HPS::FastTrack::VRTrackWrapper::Lane->new(  lane_name => $self->lane(), database => $self->database(), mode => $self->mode  );
  $lane->vrlane();
  return $lane;
}

sub _build_config_data {

  my ($self) = @_;
  my $config = Bio::HPS::FastTrack::Config->new(
						study_name => $self->study_metadata()->vrtrack_study->hierarchy_name(),
						database => $self->database(),
						db_alias => $self->db_alias(),
						add_to_config_path => $self->add_to_config_path(),
						mode => $self->mode()
					       );
  return $config;

}

sub run {

  my ($self) = @_;

  if ( $self->study ) {
    $self->_is_pipeline_stage_done_for_lanes();
    $self->_is_pipeline_stage_done_for_study();
  }
  else {
    $self->_is_pipeline_stage_done_for_lane();
  }
}

sub _is_pipeline_stage_done_for_study {

  my ($self) = @_;
  my $study = $self->study_metadata()->vrtrack_study;
  my %pipeline_stage;

  if ( defined $self->lanes_pipeline_stage()->{'stage'} ) {
    $pipeline_stage{'stage'} = $self->stage_done;
  }
  else {
    if ( defined $self->study_metadata->vrtrack_study->{'status'} && $self->study_metadata->vrtrack_study->{'status'} eq 'study not found in tracking database') {
      $pipeline_stage{'stage'} = $self->stage_not_done;
    }
    else {
      my $lane_stage = 'done';
      for my $study_lanes( keys %{ $self->lanes_pipeline_stage() } ) {
	if ($self->lanes_pipeline_stage->{$study_lanes}->{'stage'} eq $self->stage_not_done) {
	  $lane_stage = 'not done';
	  last;
	}
      }
      if ($lane_stage eq 'done') {
	$pipeline_stage{'stage'} = $self->stage_done;
      }
      else {
	$pipeline_stage{'stage'} = $self->stage_not_done;
      }
    }
    $self->study_pipeline_stage(\%pipeline_stage);
  }
}

sub _is_pipeline_stage_done_for_lanes {

  my ($self) = @_;
  my $study_lanes = $self->study_metadata()->lanes();
  my %pipeline_stage;
  my @run_ids;

  for my $lane(sort keys %{$study_lanes}) {
    my $run_id = _set_run_id_for_lane($lane);
    if( ($study_lanes->{$lane}->processed() & $self->_allowed_processed_flags() ) == 0 ) {
      $pipeline_stage{$lane}{'stage'} = $self->stage_not_done;
      $pipeline_stage{$lane}{'run_id'} = $run_id;
    }
    else {
      $pipeline_stage{$lane}{'stage'} = $self->stage_done;
      $pipeline_stage{$lane}{'run_id'} = $run_id;
    }
  }

  $self->lanes_pipeline_stage(\%pipeline_stage);
}

sub _is_pipeline_stage_done_for_lane {

  my ($self) = @_;
  my $lane = $self->lane_metadata()->vrlane;
  my %pipeline_stage;

  my $run_id = _set_run_id_for_lane($self->lane_metadata->lane_name);
  $pipeline_stage{'run_id'} = $run_id;

  unless ( defined $lane->{status} ) {
    if( ($lane->processed() & $self->_allowed_processed_flags) == 0 ) {
      $pipeline_stage{'stage'} = $self->stage_not_done;
    }
    else {
      $pipeline_stage{'stage'} = $self->stage_done;
    }
  }
  else {
    $pipeline_stage{'stage'} = $self->stage_not_done;
  }

  $self->lanes_pipeline_stage(\%pipeline_stage);
}

sub _set_run_id_for_lane {

  my ($lane) = @_;
  my $run_id = $lane;
  $run_id =~ s/\_[0-9]*\#[0-9]*//;
  return $run_id;
}

sub _allowed_processed_flags {

  my ($self) = @_;

  my %flags = (import => 1,
	       qc => 2,
	       mapped => 4,
	       stored => 8,
	       deleted => 16,
	       swapped => 32,
	       altered_fastq => 64,
	       improved => 128,
	       snp_called => 256,
	       rna_seq_expression => 512,
	       assembled  => 1024,
	       annotated  => 2048,
	      );

  if (defined $flags{$self->stage_done} && $flags{$self->stage_done} ne q()) {
    return $flags{$self->stage_done};
  }
  else {
    return 1;
  }
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
