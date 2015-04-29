package Bio::HPS::FastTrack::PipelineRun::Update;

# ABSTRACT: Update Pipeline runner class. Inherits from PipelineRun class

=head1 SYNOPSIS

my $update_runner = Bio::HPS::FastTrack::PipelineRun::Update->new(study => 'My Study', lane => 'My lane' , database => 'My_Database', mode => 'prod');
$update_runner->command_to_run;
$update_runner->run;

=cut

use Moose;
extends('Bio::HPS::FastTrack::PipelineRun::PipelineRun');

has 'pipeline_exec' => ( is => 'ro', isa => 'Str', default => '/software/pathogen/projects/update_pipeline/bin/update_pipeline.pl' );
has 'pipeline_stage' => ( is => 'ro', isa => 'Str', default => 'update_pipeline' );
has 'command_to_run' => ( is => 'rw', isa => 'Str', lazy => 1, builder => '_build_command_to_run' );

#_build_command_to_run
#Overrides the parent class method.
#Builds a different command
#from the rest of the pipeline
#runners.
sub _build_command_to_run {

  my ($self) = @_;

  my $lock_file = $self->lock_file();
  my $command_to_run = $self->pipeline_exec();
  my $min_run_id;

  if ($self->lane) {
    $min_run_id = $self->lane_metadata->run_id - 1;
    $command_to_run .= q( -n ') . $self->study . q(' --database=) . $self->database . q( -run ) . $self->lane_metadata->run_id . q( -min ) . $min_run_id . q( -l ) . $self->lock_file . q( -nop -v --file_type cram);
  }
  elsif ($self->study && $self->lane) {
    $min_run_id = $self->lane_metadata->run_id - 1;
    $command_to_run .= q( -n ') . $self->study_metadata->{'study'} . q(' --database=) . $self->database . q( -run ) . $self->lane_metadata->run_id . q( -min ) . $min_run_id . q( -l ) . $self->lock_file . q( -nop -v --file_type cram);
  }
  else {
    $command_to_run .= q( -n ') . $self->study_metadata->{'study'} . q(' --database=) . $self->database . q( -l ) . $self->lock_file . q( -nop -v --file_type cram);
  }
  return $command_to_run;
}

sub run {

  my ($self) = @_;
  my $command = $self->command_to_run();
  my $output = `cd /software/pathogen/projects/update_pipeline; $command` if $self->mode eq 'prod';
  print "$output\n";
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
