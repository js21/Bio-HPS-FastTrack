package Bio::HPS::FastTrack::Config::Config;

# ABSTRACT: Parent config class for all the types of configuraiton files in the Pathogen Pipelines

=head1 SYNOPSIS

my $config = Bio::HPS::FastTrack::Config::Config->new(study => 'My Study', lane => 'My lane' , database => 'My_Database', db_alias => 'My_db_Alias', root => 'My/Root/Path', pipeline_stage => 'My_Pipeline_Stage', mode => 'test');

=cut

use Moose;
use File::Temp;
use File::Slurp;
use Bio::HPS::FastTrack::Exception;
use Bio::HPS::FastTrack::Types::FastTrackTypes;

has 'study' => ( is => 'rw', isa => 'Str', lazy => 1, default => '' );
has 'lane' => ( is => 'rw', isa => 'Str', lazy => 1, default => '' );
has 'database'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'db_alias'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'root'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'pipeline_stage'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'mode'   => ( is => 'rw', isa => 'RunMode', required => 1 );
has 'suffix_for_config_path' => ( is => 'rw', isa => 'Str', builder => '_build_suffix_for_config_path' );
has 'config_files' => ( is => 'rw', isa => 'HashRef', lazy => 1, builder => '_build_config_files');
has 'log_root' => ( is => 'rw', isa => 'Str', lazy => 1, builder => '_build_log_root' );

sub BUILD {

  my ($self) = @_;
  $self->root('t/data/conf/') if $self->mode eq 'test';
}

sub run {
  my ($self) = @_;
  return(1);

}

sub _build_log_root {

  my ($self) = @_;
  return 't/data/log/' if $self->mode eq 'test';
  return '/nfs/pathnfs05/log/';
}

sub _build_suffix_for_config_path {

  my ($self) = @_;
  return $self->db_alias() eq 'no alias' ? $self->database() : $self->db_alias();;
}

sub _build_config_files {

  my ($self) = @_;
  return({}) if $self->pipeline_stage eq q();

  my $pipeline = $self->pipeline_stage;
  $pipeline =~ s/_pipeline//;

  if ( ( !defined $self->study || $self->study eq q() ) && defined $self->lane && $self->lane ne q() ) {
    Bio::HPS::FastTrack::Exception::FeatureNotYetImplemented->throw( error => _get_error_info($pipeline) );
  }

  my $dir = File::Temp->newdir($self->root . $self->suffix_for_config_path . q(/) . 'XXXX', CLEANUP => 0);
  my $main_high_level_config_path = $self->root . $self->suffix_for_config_path . q(/) . $self->suffix_for_config_path . q(_) . $self->pipeline_stage . q(.conf);
  my $high_level_path = $dir->dirname . q(/) . $self->suffix_for_config_path . q(_) . $self->pipeline_stage . q(.conf);
  my $log_file = $self->log_root . $self->suffix_for_config_path . q(_) . $self->pipeline_stage . q(.log);

  my $registered_studies = _extract_studies_to_run($self, $main_high_level_config_path, $dir);
  _write_high_level_conf_file($self,$high_level_path,$registered_studies);

  my %config_files = (
		      'tempdir' => $dir,
		      'high_level' => $high_level_path,
		      'log_file' => $log_file
		     );

  return(\%config_files);
}

sub _get_error_info {

  my ($pipeline) = @_;
  my %error_hash = (
		    'mapping' => "Fast tracking Mapping for a specific lane is not yet possible\n",
		    'qc' => "Fast tracking QC for a specific lane is not yet possible\n",
		    'assembly' => "Fast tracking Assembly for a specific lane is not yet possible\n",
		    'annotate_assembly' => "Fast tracking Annotation for a specific lane is not yet possible\n",
		    'snps' => "Fast tracking SNP-Calling for a specific lane is not yet possible\n",
		    'rna_seq' => "Fast tracking RNASeq for a specific lane is not yet possible\n",
		   );
  return $error_hash{$pipeline};

}

sub _extract_studies_to_run {

  my ($self, $main_high_level_config_path, $dir) = @_;

  my @lines = read_file($main_high_level_config_path);

  my $study_string = $self->study;
  $study_string =~ s/\s|-/_/g;
  my @registered_studies;
  for my $reg_study(@lines) {
    chomp($reg_study);
    if ( $reg_study =~ m/$study_string/) {
      push(@registered_studies, $reg_study);
    }
  }
  if ( scalar @registered_studies == 0 ) {
    my $dir_to_remove = $dir->dirname;
    `rm -rf $dir_to_remove`;
    return Bio::HPS::FastTrack::Exception::StudyNotFoundInHighLevelConfig->throw(
										 error => "Study '" .
										 $self->study .
										 "' is not present in file '$main_high_level_config_path'\n"
										);
  }
  else {
    return \@registered_studies;
  }
}

sub _write_high_level_conf_file {

  my ($self, $high_level_path, $registered_studies) = @_;
  my @low_level_paths;
  my $hl_buffer;
  for my $reg_study( @{ $registered_studies } ) {
    $hl_buffer .= "$reg_study\n";
  }
  write_file( $high_level_path, \$hl_buffer ) ;
}



no Moose;
__PACKAGE__->meta->make_immutable;
1;
