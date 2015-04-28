package Bio::HPS::FastTrack::PipelineRun::Import;

# ABSTRACT: Import pipeline runner class. Inherits from the parent class PipelineRun

=head1 SYNOPSIS

my $import_runner = Bio::HPS::FastTrack::PipelineRun::Import->new(study => 'My Study', lane => 'My lane' , database => 'My_Database', mode => 'prod');
$import_runner->command_to_run;
$import_runner->run;

=cut

use Moose;
extends('Bio::HPS::FastTrack::PipelineRun::PipelineRun');

has 'pipeline_exec' => ( is => 'ro', isa => 'Str', default => '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline' );
has 'pipeline_stage' => ( is => 'ro', isa => 'Str', default => 'import_cram_pipeline' );

no Moose;
__PACKAGE__->meta->make_immutable;
1;
