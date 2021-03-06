package Bio::HPS::FastTrack::PipelineRun::SNPCalling;

# ABSTRACT: SNP calling pipeline runner class. Inherits from the parent class PipelineRun

=head1 SYNOPSIS

my $snp_calling_runner = Bio::HPS::FastTrack::PipelineRun::SNPCalling->new(study => 'My Study', lane => 'My lane' , database => 'My_Database', mode => 'prod');
$snp_calling_runner->command_to_run;
$snp_calling_runner->run;
=cut

use Moose;
extends('Bio::HPS::FastTrack::PipelineRun::PipelineRun');

has 'pipeline_exec' => ( is => 'ro', isa => 'Str', default => '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline' );
has 'pipeline_stage' => ( is => 'ro', isa => 'Str', default => 'snps_pipeline' );

no Moose;
__PACKAGE__->meta->make_immutable;
1;
