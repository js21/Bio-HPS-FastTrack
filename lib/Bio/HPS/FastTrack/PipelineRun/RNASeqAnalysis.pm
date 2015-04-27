package Bio::HPS::FastTrack::PipelineRun::RNASeqAnalysis;

# ABSTRACT: RNASeq analysis pipeline runner class. Inherits from the parent class PipelineRun

=head1 SYNOPSIS

my $rna_seq_runner = Bio::HPS::FastTrack::PipelineRun::RNASeqAnalysis->new(study => 'My Study', lane => 'My lane' , database => 'My_Database', mode => 'test');

=cut

use Moose;
extends('Bio::HPS::FastTrack::PipelineRun::PipelineRun');

has 'pipeline_exec' => ( is => 'ro', isa => 'Str', default => '/software/pathogen/internal/pathdev/vr-codebase/scripts/run-pipeline' );
has 'pipeline_stage' => ( is => 'ro', isa => 'Str', default => 'rna_seq_pipeline' );

no Moose;
__PACKAGE__->meta->make_immutable;
1;
