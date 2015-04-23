package Bio::HPS::FastTrack::PipelineRun::PipelineRun;

# ABSTRACT: Parent class from which all pipeline runners inherit from.

=head1 SYNOPSIS

my $mapping_analysis_runner = Bio::HPS::FastTrack::PipelineRun::PipelineRun->new(study => 'My Study', lane => 'My lane' , database => 'My_Database');

=cut

use Moose;
use Bio::HPS::FastTrack::SetConfig;
use Bio::HPS::FastTrack::VRTrackWrapper::Study;
use Bio::HPS::FastTrack::VRTrackWrapper::Lane;
use Bio::HPS::FastTrack::Types::FastTrackTypes;
use Bio::HPS::FastTrack::Exception;

has 'root' => ( is => 'rw', isa => 'Str', default => '/nfs/pathnfs05/conf/' );
#has 'root' => ( is => 'ro', isa => 'Str', default => '/lustre/scratch108/pathogen/js21/conf/' );
has 'pipeline_exec' => ( is => 'ro', isa => 'Str', default => '' );
has 'pipeline_stage' => ( is => 'ro', isa => 'Str', default => '' );
has 'sleep_time' => ( is => 'rw', isa => 'Int', lazy => 1, default => 120 );

has 'database'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'mode' => ( is => 'rw', isa => 'RunMode', required => 1);
has 'study' => ( is => 'rw', isa => 'Str', lazy => 1, default => '' );
has 'lane' => ( is => 'rw', isa => 'Str', lazy => 1, default => '');

has 'pipeline_runner' => ( is => 'rw', isa => 'HashRef', lazy => 1, builder => '_build_pipeline_runner' );
has 'db_alias' => ( is => 'rw', isa => 'Str', builder => '_build_db_alias' );
has 'lock_file' => ( is => 'rw', isa => 'Str', lazy => 1, builder => '_build_lock_file' );
has 'study_metadata' => ( is => 'rw', isa => 'Bio::HPS::FastTrack::VRTrackWrapper::Study', lazy => 1, builder => '_build_study_metadata' );
has 'lane_metadata' => ( is => 'rw', isa => 'Bio::HPS::FastTrack::VRTrackWrapper::Lane', lazy => 1, builder => '_build_lane_metadata' );
has 'config_files' => ( is => 'rw', isa => 'HashRef', lazy => 1, builder => '_build_config_files' );

sub run {

  my ($self) = @_;
  return 1;

}

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
			  'pathogen_rnd_track'      => 'rnd',
			  'pathogen_hpsft_test'    => 'fast_track'
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
  my $study = Bio::HPS::FastTrack::VRTrackWrapper::Study->new( study => $self->study(), database => $self->database(), mode => $self->mode() );
  $study->lanes();
  return $study;
}

sub _build_lane_metadata {

  my ($self) = @_;
  my $lane = Bio::HPS::FastTrack::VRTrackWrapper::Lane->new(  lane_name => $self->lane(), database => $self->database(), mode => $self->mode() );
  unless ( $self->study() ) {
    $self->study($lane->study_name());
  }
  return $lane;
}

sub _build_lock_file {

  my ($self) = @_;
  my $lock_file;
  if ( $self->db_alias eq 'no alias' || !defined $self->db_alias ) {
    $lock_file = $self->root() . $self->database() . q(/.) . $self->database() . q(.) . $self->pipeline_stage() . q(.lock);
  }
  else {
    $lock_file = $self->root() . $self->db_alias() . q(/.) . $self->database() . q(.) . $self->pipeline_stage() . q(.lock);
  }
  return $lock_file;
}

sub _build_config_files {

  my ($self) = @_;

  my %no_config;
  return \%no_config if $self->pipeline_stage eq 'update_pipeline';

  return Bio::HPS::FastTrack::SetConfig->new(
					  study => $self->study(),
					  lane => $self->lane(),
					  database => $self->database(),
					  pipeline_stage => $self->pipeline_stage(),
					  db_alias => $self->db_alias,
					  root => $self->root(),
					  mode => $self->mode()
					 )->config_files();
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
