package Bio::HPS::FastTrack::PipelineRun::Update;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $import_runner = Bio::HPS::FastTrack::PipelineRun::Update->new(study =>  2027, database => 'pathogen_prok_track_test');

=cut

use Moose;
extends('Bio::HPS::FastTrack::PipelineRun::PipelineRun');

has 'pipeline_exec' => ( is => 'ro', isa => 'Str', default => '/software/pathogen/projects/update_pipeline/bin/update_pipeline.pl' );
has 'pipeline_stage' => ( is => 'ro', isa => 'Str', default => 'update_pipeline' );

sub run {

  my ($self) = @_;

  my $lock_file = $self->lock_file();
  my $command = $self->pipeline_exec();

  if ($self->lane) {
    $command .= q( -n ') . $self->study . q(' --database=) . $self->database . q( -run ) . $self->lane_metadata->run_id . q( -l ) . $self->lock_file . q( -nop -v --file_type cram);
  }
  else {
    $command .= q( -n ') . $self->study_metadata->{'study'} . q(' --database=) . $self->database . q( -l ) . $self->lock_file . q( -nop -v --file_type cram);
  }
  print "$command\n";
  my $output = `cd /nfs/users/nfs_j/js21/work/update_pipeline; $command`;
  print "$output\n";

}




no Moose;
__PACKAGE__->meta->make_immutable;
1;
