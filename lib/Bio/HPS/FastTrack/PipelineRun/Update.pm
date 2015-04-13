package Bio::HPS::FastTrack::PipelineRun::Update;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $import_runner = Bio::HPS::FastTrack::PipelineRun::Update->new(study =>  2027, database => 'pathogen_prok_track_test');

=cut

use Moose;
extends('Bio::HPS::FastTrack::PipelineRun::PipelineRun');

has 'stage_done'   => ( is => 'ro', isa => 'Str', default => 'updated' );
has 'stage_not_done'   => ( is => 'ro', isa => 'Str', default => 'not updated' );
has 'add_to_config_path' => ( is => 'ro', isa => 'Str', default => 'update' );
has 'pipeline_exec' => ( is => 'ro' => isa => 'Str', default => '/software/pathogen/projects/update_pipeline/bin/update_pipeline.pl' );

after 'run' => sub {

  my ($self) = @_;
  my $command = $self->pipeline_exec();
  if ( $self->study_pipeline_stage->{'stage'} eq $self->stage_not_done ) {
    $command .= q( -n ') . $self->study_metadata->vrtrack_study->{'name'} . q(' --database=) . $self->database . q( -nop -v -t cram);
  }
  print "$command\n";

};


no Moose;
__PACKAGE__->meta->make_immutable;
1;
