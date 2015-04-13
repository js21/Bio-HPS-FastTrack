package Bio::HPS::FastTrack;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $hps_fast_track_bacteria_update_and_import =  Bio::HPS::FastTrack->new( study => 'Comparative RNA-seq analysis of three bacterial species', lane => '7229_2#35' database => 'prokaryotes', pipeline => ['update','import'] );
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

has 'study' => ( is => 'rw', isa => 'Str', required => 1);
has 'lane' => ( is => 'rw', isa => 'Str', lazy => 1, default => 'NA');
has 'database'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'pipeline'   => ( is => 'rw',  isa => 'Maybe[ArrayRef]', default => sub { [] });
has 'pipeline_runners'   => ( is => 'rw', isa => 'ArrayRef', lazy => 1, builder => '_build_pipeline_runners');
has 'mode'   => ( is => 'rw', isa => 'RunMode', required => 1 );

sub run {

  my ($self) = @_;

  for my $pipeline_runner(@{$self->pipeline_runners()}) {
    $pipeline_runner->study_metadata();
    $pipeline_runner->run();
  }
}

sub _build_pipeline_runners {
  my ($self) = @_;
  return Bio::HPS::FastTrack::SetPipeline->new( study => $self->study(), lane => $self->lane(), pipeline => $self->pipeline(), database=> $self->database(), mode => $self->mode )->pipeline_runners();
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

