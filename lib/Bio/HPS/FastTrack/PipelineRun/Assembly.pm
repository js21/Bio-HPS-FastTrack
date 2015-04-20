package Bio::HPS::FastTrack::PipelineRun::Assembly;

# ABSTRACT: Assembly pipeline runner class. Inherits from the parent class PipelineRun

=head1 SYNOPSIS

my $assembly_runner = Bio::HPS::FastTrack::PipelineRun::Assembly->new(study => 'My Study', lane => 'My lane' , database => 'My_Database', mode => 'test');

=cut

use Moose;
extends('Bio::HPS::FastTrack::PipelineRun::PipelineRun');

has 'pipeline_exec' => ( is => 'ro', isa => 'Str', default => '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline' );
has 'pipeline_stage' => ( is => 'ro', isa => 'Str', default => 'assembly_pipeline' );
has 'command_to_run' => ( is => 'rw', isa => 'Str', lazy => 1, builder => '_build_command_to_run' );

no Moose;
__PACKAGE__->meta->make_immutable;
1;
