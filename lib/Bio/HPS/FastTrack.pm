package Bio::HPS::FastTrack;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $hps_fast_track_update =  Bio::HPS::FastTrack->new(
						      study => 'My Study',
						      database => 'My database',
						      pipeline => ['update'],
						     );
$hps_fast_track_update->run;

=cut

use Moose;
use Bio::HPS::FastTrack::SetPipeline;
use Bio::HPS::FastTrack::Exception;
use Bio::HPS::FastTrack::Types::FastTrackTypes;

has 'pipeline'   => ( is => 'rw',  isa => 'Maybe[ArrayRef]', required => 1);
has 'database'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'mode' => ( is => 'rw', isa => 'RunMode', required => 1);
has 'study' => ( is => 'rw', isa => 'Str', lazy => 1, default => '');
has 'lane' => ( is => 'rw', isa => 'Str', lazy => 1, default => '');
has 'sleep_time' => ( is => 'rw', isa => 'Int', lazy => 1, default => 2 );
has 'pipeline_runners'   => ( is => 'rw', isa => 'ArrayRef', lazy => 1, builder => '_build_pipeline_runners');

#_build_pipeline_runners:
#Builds an Array Ref of PipelineRunner
#objects
sub _build_pipeline_runners {
  my ($self) = @_;
  return Bio::HPS::FastTrack::SetPipeline->new(
					       study => $self->study(),
					       lane => $self->lane(),
					       pipeline => $self->pipeline(),
					       database => $self->database(),
					       sleep_time => $self->sleep_time(),
					       mode => $self->mode()
					      )->pipeline_runners();
}

sub run {

  my ($self) = @_;

  for my $pipeline_runner(@{$self->pipeline_runners()}) {
    if ( $self->study() ) {
      $pipeline_runner->config_files() unless $self->pipeline eq 'update'; #The Update pipeline follows a different protocol. No config files are required
      $pipeline_runner->command_to_run();
      $pipeline_runner->run() if $self->mode() eq 'prod'; #Only run if in production
    }
    else {
      $pipeline_runner->config_files() unless $self->pipeline eq 'update'; #The Update pipeline follows a different protocol. No config files are required
      $pipeline_runner->lane_metadata();
      $pipeline_runner->command_to_run();
      $pipeline_runner->run() if $self->mode() eq 'prod'; #Only run if in production
    }
    _remove_temp_dir( $pipeline_runner->temp_dir );
  }
}

sub _remove_temp_dir {

  my ($dir_to_remove) = @_;
  if (-d $dir_to_remove) {
    my $output = `rm -rf $dir_to_remove`;
    return 1 if ($output eq q());
  }
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

