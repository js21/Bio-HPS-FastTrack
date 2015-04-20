package Bio::HPS::FastTrack;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $hps_fast_track_bacteria_update_and_import =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', lane => '7229_2#35' database => 'prokaryotes', pipeline => ['update','import'], mode => 'test' );
$hps_fast_track_bacteria_update_and_import->study();
$hps_fast_track_bacteria_update_and_import->database();
for my $pipeline_run( @{ hps_fast_track_bacteria_update_and_import->pipeline_runners() } ) {
  $pipeline_run->run();
}

=cut

use Moose;
use Bio::HPS::FastTrack::SetPipeline;
use Bio::HPS::FastTrack::Exception;
use Bio::HPS::FastTrack::Types::FastTrackTypes;

has 'pipeline'   => ( is => 'rw',  isa => 'Maybe[ArrayRef]', required => 1);
has 'database'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'mode' => ( is => 'rw', isa => 'RunMode', default => 'prod');
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

