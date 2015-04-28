package Bio::HPS::FastTrack::PipelineRun::Mapping;

# ABSTRACT: Mapping pipeline runner class. Inherits from the parent class PipelineRun

=head1 SYNOPSIS

my $mapping_runner = Bio::HPS::FastTrack::PipelineRun::Mapping->new(study => 'My Study', lane => 'My lane' , database => 'My_Database');
$mapping_runner->command_to_run;
$mapping_runner->run;

=cut

use Moose;
extends('Bio::HPS::FastTrack::PipelineRun::PipelineRun');

has 'pipeline_exec' => ( is => 'ro', isa => 'Str', default => '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline' );
has 'pipeline_stage' => ( is => 'ro', isa => 'Str', default => 'mapping_pipeline' );


no Moose;
__PACKAGE__->meta->make_immutable;
1;
