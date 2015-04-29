package Bio::HPS::FastTrack::PipelineRun::PipelineRun;

# ABSTRACT: Parent class from which all pipeline runners inherit from.

=head1 SYNOPSIS

my $pipeline_runner = Bio::HPS::FastTrack::PipelineRun::PipelineRun->new(
									 study => 'My Study',
									 lane => 'My lane' ,
									 database => 'My_Database'
									 mode => 'prod'
									);

=cut

use Moose;
use Bio::HPS::FastTrack::SetConfig;
use Bio::HPS::FastTrack::VRTrackWrapper::Study;
use Bio::HPS::FastTrack::VRTrackWrapper::Lane;
use Bio::HPS::FastTrack::Types::FastTrackTypes;
use Bio::HPS::FastTrack::Exception;

has 'root' => ( is => 'rw', isa => 'Str', default => '/nfs/pathnfs05/conf/' );
has 'pipeline_exec' => ( is => 'ro', isa => 'Str', default => '' );
has 'pipeline_stage' => ( is => 'ro', isa => 'Str', default => '' );
has 'sleep_time' => ( is => 'rw', isa => 'Int', lazy => 1, default => 2 );

has 'database'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'mode' => ( is => 'rw', isa => 'RunMode', required => 1);
has 'study' => ( is => 'rw', isa => 'Str', lazy => 1, default => '' );
has 'lane' => ( is => 'rw', isa => 'Str', lazy => 1, default => '');
has 'temp_dir' => ( is => 'rw', isa => 'Str', lazy => 1, default => '' );

has 'db_alias' => ( is => 'rw', isa => 'Str', builder => '_build_db_alias' );
has 'lock_file' => ( is => 'rw', isa => 'Str', lazy => 1, builder => '_build_lock_file' );
has 'study_metadata' => ( is => 'rw', isa => 'Bio::HPS::FastTrack::VRTrackWrapper::Study', lazy => 1, builder => '_build_study_metadata' );
has 'lane_metadata' => ( is => 'rw', isa => 'Bio::HPS::FastTrack::VRTrackWrapper::Lane', lazy => 1, builder => '_build_lane_metadata' );
has 'config_files' => ( is => 'rw', isa => 'HashRef', lazy => 1, builder => '_build_config_files' );
has 'command_to_run' => ( is => 'rw', isa => 'Str', lazy => 1, builder => '_build_command_to_run' );

#_build_db_alias:
#Returns the alias for a database
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

#_build_lock_file:
#Returns the lock file file path.
#This file ensures that there's
#only one conneciton writing to a
#database
sub _build_lock_file {

  my ($self) = @_;

  #Set root to point to test folder if running in test mode before building the lock file path
  $self->root('t/data/conf/') if $self->mode eq 'test';

  my $lock_file;
  if ( $self->db_alias eq 'no alias' || !defined $self->db_alias ) {
    $lock_file = $self->root() . $self->database() . q(/.) . $self->database() . q(.) . $self->pipeline_stage() . q(.lock);
  }
  else {
    $lock_file = $self->root() . $self->db_alias() . q(/.) . $self->database() . q(.) . $self->pipeline_stage() . q(.lock);
  }
  return $lock_file;
}

#_build_study_metadata:
#Returns a study object with all
#the study metadata and all the lanes
#that belong to the study
sub _build_study_metadata {

  my ($self) = @_;
  my $study = Bio::HPS::FastTrack::VRTrackWrapper::Study->new( study => $self->study(), database => $self->database(), mode => $self->mode() );
  $study->lanes();
  return $study;
}

#_build_lane_metadata:
#Returns the metadata for a
#particular lane
sub _build_lane_metadata {

  my ($self) = @_;
  my $lane = Bio::HPS::FastTrack::VRTrackWrapper::Lane->new(  lane_name => $self->lane(), database => $self->database(), mode => $self->mode() );
  unless ( $self->study() ) {
    $self->study($lane->study_name());
  }
  return $lane;
}

#_build_config_files:
#Returns a hash ref with config file paths needed
#for the pipeline that is being fast tracked
sub _build_config_files {

  my ($self) = @_;

  my %no_config;
  return \%no_config if $self->pipeline_stage eq 'update_pipeline';

  #Set root to point to test folder if running in test mode before building any config file paths
  $self->root('t/data/conf/') if $self->mode eq 'test';

  my $config_files = Bio::HPS::FastTrack::SetConfig->new(
							 study => $self->study(),
							 lane => $self->lane(),
							 database => $self->database(),
							 pipeline_stage => $self->pipeline_stage(),
							 db_alias => $self->db_alias,
							 root => $self->root(),
							 mode => $self->mode()
							)->config_files();
  $self->temp_dir($config_files->{'tempdir'}->dirname);
  return $config_files;
}

#_build_command_to_run:
#Builds the command line string
#that will later run with the run method
sub _build_command_to_run {

  my ($self) = @_;

  if ( $self->pipeline_stage eq 'qc_pipeline') {
    if ( ( !defined $self->study || $self->study eq q() ) && defined $self->lane && $self->lane ne q() ) {
      Bio::HPS::FastTrack::Exception::FeatureNotYetImplemented->throw( error => "Fast tracking QC for a specific lane is not yet possible\n" );
    }
  }

  my $command_to_run = $self->pipeline_exec . q( -c ) . $self->config_files->{'high_level'} . q( -l ) . $self->config_files->{'log_file'};
  $command_to_run .= q( -v -v -L ) . $self->lock_file;
  $command_to_run .= q( -m 500);
  $command_to_run .= qq( -s ) . $self->sleep_time;
  print "$command_to_run\n";
  return $command_to_run;
}

#run:
#Runs the command if in production
sub run {

  my ($self) = @_;
  my $command = $self->command_to_run();
  print "$command\n";
  `$command` if $self->mode eq 'prod';

}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
