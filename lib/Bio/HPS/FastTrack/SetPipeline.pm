package  Bio::HPS::FastTrack::SetPipeline;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $analysis_detector = Bio::HPS::FastTrack::SetPipelines->new( database => 'virus', analysis => ['all'])

=cut

use Moose;
use Bio::HPS::FastTrack::PipelineRun::PipelineRun;
use Bio::HPS::FastTrack::PipelineRun::Update;
use Bio::HPS::FastTrack::PipelineRun::Import;
use Bio::HPS::FastTrack::PipelineRun::QC;
use Bio::HPS::FastTrack::PipelineRun::Mapping;
use Bio::HPS::FastTrack::PipelineRun::Assembly;
use Bio::HPS::FastTrack::PipelineRun::Annotation;
use Bio::HPS::FastTrack::PipelineRun::SNPCalling;
use Bio::HPS::FastTrack::PipelineRun::RNASeqAnalysis;
use Bio::HPS::FastTrack::Types::FastTrackTypes;
use Bio::HPS::FastTrack::Exception;

has 'study'   => ( is => 'rw', isa => 'Str', lazy => 1, default => '' );
has 'lane'   => ( is => 'rw', isa => 'Str', lazy => 1, default => '');
has 'database'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'mode' => ( is => 'rw', isa => 'RunMode', required => 1);
has 'pipeline'   => ( is => 'rw',  isa => 'Maybe[ArrayRef]', required => 1);
has 'pipeline_runners'   => ( is => 'rw', isa => 'ArrayRef', lazy => 1, builder => '_build_pipeline_runners');


sub _build_pipeline_runners {

  my ($self) = @_;

  my @runners;
  if ( $self->study eq '' && $self->lane eq '' ) {
    Bio::HPS::FastTrack::Exception::StudyAndLaneNotSpecified->throw( error => "Error: Specify a lane or a study or both\n" );
  }
  if ( scalar @{ $self->pipeline() } == 0 ) {
    Bio::HPS::FastTrack::Exception::NoPipelineSpecified->throw( error => "Error: No pipeline was specified through the command line option -p. Usage can be accessed through the -h option.\n" );
  }
  else {
    for my $pipeline(@{ $self->pipeline() }) {
      my $allowed_pipeline = $self->_allowed_pipelines($pipeline);
      if ( defined $allowed_pipeline && $allowed_pipeline ne q() ) {
	push( @runners, $allowed_pipeline );
      }
      else {
	Bio::HPS::FastTrack::Exception::PipelineNotSupported->throw( error => "Error: The requested pipeline is not supported '" . $pipeline . "'\n" );
      }
    }
  }
  return \@runners;
}

sub _allowed_pipelines {

  my ($self, $pipeline) = @_;
  my %pipelines = (
		   'update' => Bio::HPS::FastTrack::PipelineRun::Update->new(study => $self->study(), lane => $self->lane(), database => $self->database(), mode => $self->mode() ),
		   'import' => Bio::HPS::FastTrack::PipelineRun::Import->new(study => $self->study(), lane => $self->lane(), database => $self->database(), mode => $self->mode() ),
		   'qc' => Bio::HPS::FastTrack::PipelineRun::QC->new(study => $self->study(), lane => $self->lane(), database => $self->database(), mode => $self->mode() ),
		   'mapping' => Bio::HPS::FastTrack::PipelineRun::Mapping->new(study => $self->study(), lane => $self->lane(), database => $self->database(), mode => $self->mode() ),
		   'assembly' => Bio::HPS::FastTrack::PipelineRun::Assembly->new(study => $self->study(), lane => $self->lane(), database => $self->database(), mode => $self->mode() ),
		   'annotation' => Bio::HPS::FastTrack::PipelineRun::Annotation->new(study => $self->study(), lane => $self->lane(), database => $self->database(), mode => $self->mode() ),
		   'snp-calling' => Bio::HPS::FastTrack::PipelineRun::SNPCalling->new(study => $self->study(), lane => $self->lane(), database => $self->database(), mode => $self->mode() ),
		   'rna-seq' => Bio::HPS::FastTrack::PipelineRun::RNASeqAnalysis->new(study => $self->study(), lane => $self->lane(), database => $self->database(), mode => $self->mode() ),
		  );
  return $pipelines{$pipeline};
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
