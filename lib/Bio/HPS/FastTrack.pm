package Bio::HPS::FastTrack;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $hps_fast_track_bacteria_update_and_import =  Bio::HPS::FastTrack->new( study => 'My Study', lane => 'My lane' , database => 'My_Database', pipeline => ['update','import'], mode => 'test' );
$hps_fast_track_bacteria_update_and_import->run;

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
has 'pipeline_runners'   => ( is => 'rw', isa => 'ArrayRef', lazy => 1, builder => '_build_pipeline_runners');

sub run {

  my ($self) = @_;

  for my $pipeline_runner(@{$self->pipeline_runners()}) {
    if ( $self->study() ) {
      $pipeline_runner->command_to_run();
      $pipeline_runner->run() if $self->mode() eq 'prod';
    }
    else {
      $pipeline_runner->lane_metadata();
      $pipeline_runner->command_to_run();
      $pipeline_runner->run() if $self->mode() eq 'prod';
    }
  }
}

sub _build_pipeline_runners {
  my ($self) = @_;
  return Bio::HPS::FastTrack::SetPipeline->new(
					       study => $self->study(),
					       lane => $self->lane(),
					       pipeline => $self->pipeline(),
					       database => $self->database(),
					       mode => $self->mode()
					      )->pipeline_runners();
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

