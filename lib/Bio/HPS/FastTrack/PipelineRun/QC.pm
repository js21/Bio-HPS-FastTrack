package Bio::HPS::FastTrack::PipelineRun::QC;

# ABSTRACT: QC pipeline runner class. Inherits from the parent class PipelineRun

=head1 SYNOPSIS

my $qc_runner = Bio::HPS::FastTrack::PipelineRun::QC->new(study => 'My Study', lane => 'My lane' , database => 'My_Database', mode => 'test');

=cut

use Moose;
extends('Bio::HPS::FastTrack::PipelineRun::PipelineRun');

has 'pipeline_exec' => ( is => 'ro', isa => 'Str', default => '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline' );
has 'pipeline_stage' => ( is => 'ro', isa => 'Str', default => 'qc_pipeline' );
has 'command_to_run' => ( is => 'rw', isa => 'Str', lazy => 1, builder => '_build_command_to_run' );

sub _build_command_to_run {

  my ($self) = @_;

  if ( ( !defined $self->study || $self->study eq q() ) && defined $self->lane && $self->lane ne q() ) {
    Bio::HPS::FastTrack::Exception::FeatureNotYetImplemented->throw( error => "Fast tracking QC for a specific lane is not yet possible\n" );
  }

  my $lock_file = $self->lock_file();
  my $command = $self->pipeline_exec();
  my $command_to_run = $self->pipeline_exec . q( -c ) . $self->config_files->{'high_level'} . q( -l ) . $self->config_files->{'log_file'};
  $command_to_run .= q( -v -v -L ) . $self->lock_file;
  $command_to_run .= q( -m 500);
  return $command_to_run;
}

sub run {

  my ($self) = @_;
  my $command = $self->command_to_run();
  my $output = `$command`;
  sleep($self->sleep_time);
  print "$output\n";
  my $dir_to_remove = $self->config_files->{'tempdir'};
  _remove_temp_config_folder($dir_to_remove);
}

sub _remove_temp_config_folder {

  my ($dir_to_remove) =@_;
  `rm -rf $dir_to_remove`;
  print "Deleting $dir_to_remove\n";
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
