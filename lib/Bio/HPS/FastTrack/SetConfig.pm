package Bio::HPS::FastTrack::SetConfig;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $hps_config = Bio::HPS::FastTrack::Config->new( id => '123', database => 'pathogen_prok_track_test')

=cut

use Moose;
use Bio::HPS::FastTrack::Config::Config;
use Bio::HPS::FastTrack::Config::Import;
use Bio::HPS::FastTrack::Config::QC;
use Bio::HPS::FastTrack::Config::Mapping;
use Bio::HPS::FastTrack::Config::Assembly;
use Bio::HPS::FastTrack::Config::Annotation;
use Bio::HPS::FastTrack::Config::SNPCalling;
use Bio::HPS::FastTrack::Config::RNASeqAnalysis;
use Bio::HPS::FastTrack::Exception;
use Bio::HPS::FastTrack::Types::FastTrackTypes;

has 'study' => ( is => 'rw', isa => 'Str', lazy => 1, default => '' );
has 'lane' => ( is => 'rw', isa => 'Str', lazy => 1, default => '' );
has 'pipeline_stage' => ( is => 'rw', isa => 'Str', required => 1 );
has 'database'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'db_alias'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'root'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'mode'   => ( is => 'rw', isa => 'RunMode', required => 1 );
has 'config_files' => ( is => 'rw', isa => 'HashRef', lazy => 1, builder => '_build_config_files' );


sub _build_config_files {

  my ($self) = @_;
  return _pipeline_config_files_templates($self)->config_files();
}

sub _pipeline_config_files_templates {

  my ($self) = @_;

  my %templates = (
		   'import_cram_pipeline' => Bio::HPS::FastTrack::Config::Import->new(
										      study => $self->study(),
										      lane => $self->lane(),
										      database => $self->database(),
										      db_alias => $self->db_alias(),
										      root => $self->root(),
										      pipeline_stage => $self->pipeline_stage(),
										      mode => $self->mode()
										     ),
		   'qc_pipeline' => Bio::HPS::FastTrack::Config::QC->new(
									 study => $self->study(),
									 lane => $self->lane(),
									 database => $self->database(),
									 db_alias => $self->db_alias(),
									 root => $self->root(),
									 pipeline_stage => $self->pipeline_stage(),
									 mode => $self->mode()
									),
		   'mapping_pipeline' => Bio::HPS::FastTrack::Config::Mapping->new(
										   study => $self->study(),
										   lane => $self->lane(),
										   database => $self->database(),
										   db_alias => $self->db_alias(),
										   root => $self->root(),
										   pipeline_stage => $self->pipeline_stage(),
										   mode => $self->mode()
										  ),
		   'assembly_pipeline' => Bio::HPS::FastTrack::Config::Assembly->new(
										     study => $self->study(),
										     lane => $self->lane(),
										     database => $self->database(),
										     db_alias => $self->db_alias(),
										     root => $self->root(),
										     pipeline_stage => $self->pipeline_stage(),
										     mode => $self->mode()
										    ),
		   'annotate_assembly_pipeline' => Bio::HPS::FastTrack::Config::Annotation->new(
												study => $self->study(),
												lane => $self->lane(),
												database => $self->database(),
												db_alias => $self->db_alias(),
												root => $self->root(),
												pipeline_stage => $self->pipeline_stage(),
												mode => $self->mode()
											       ),
		   'snps_pipeline' => Bio::HPS::FastTrack::Config::SNPCalling->new(
										   study => $self->study(),
										   lane => $self->lane(),
										   database => $self->database(),
										   db_alias => $self->db_alias(),
										   root => $self->root(),
										   pipeline_stage => $self->pipeline_stage(),
										   mode => $self->mode()
										  ),
		   'rna_seq_pipeline' => Bio::HPS::FastTrack::Config::RNASeqAnalysis->new(
											  study => $self->study(),
											  lane => $self->lane(),
											  database => $self->database(),
											  db_alias => $self->db_alias(),
											  root => $self->root(),
											  pipeline_stage => $self->pipeline_stage(),
											  mode => $self->mode()
											 ),
		  );

  print("PIPELINE: ", $self->pipeline_stage, "\n");
  Bio::HPS::FastTrack::Exception::NoPipelineSpecified->throw( error => "Error: No pipeline was specified through the command line option -p. Usage can be accessed through the -h option.\n" ) if !defined $templates{$self->pipeline_stage};
  return $templates{$self->pipeline_stage};

}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
