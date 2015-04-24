package Bio::HPS::FastTrack::Config::QC;

# ABSTRACT: QC pipeline config class. Inherits from the parent class Config

=head1 SYNOPSIS

my $qc_config = Bio::HPS::FastTrack::Config::QC->new(study => 'My Study', lane => 'My lane' , database => 'My_Database', db_alias => 'My_db_Alias', root => 'My/Root/Path', mode => 'test');

=cut

use Moose;
use File::Slurp;
extends('Bio::HPS::FastTrack::Config::Config');

has 'suffix_for_config_path' => ( is => 'rw', isa => 'Str', builder => '_build_suffix_for_config_path' );

sub BUILD {

  my ($self) = @_;
  $self->root('t/data/conf/') if $self->mode eq 'test';
}

sub _build_suffix_for_config_path {

  my ($self) = @_;
  return $self->db_alias() eq 'no alias' ? $self->database() : $self->db_alias();;
}

sub _build_config_files {

  my ($self) = @_;

  if ( ( !defined $self->study || $self->study eq q() ) && defined $self->lane && $self->lane ne q() ) {
    Bio::HPS::FastTrack::Exception::FeatureNotYetImplemented->throw( error => "Fast tracking QC for a specific lane is not yet possible\n" );
  }

  my $pipeline = $self->pipeline_stage;
  $pipeline =~ s/_pipeline//;

  my $dir = File::Temp->newdir($self->root . $self->suffix_for_config_path . q(/) . 'XXXX', CLEANUP => 0);
  my $main_high_level_config_path = $self->root . $self->suffix_for_config_path . q(/) . $self->suffix_for_config_path . q(_) . $self->pipeline_stage . q(.conf);
  my $high_level_path = $dir->dirname . q(/) . $self->suffix_for_config_path . q(_) . $self->pipeline_stage . q(.conf);
  my $import_log_file = $self->log_root . $self->suffix_for_config_path . q(_) . $self->pipeline_stage . q(.log);

  my $registered_studies = _extract_studies_to_run($self, $main_high_level_config_path, $dir);
  _write_high_level_conf_file($self,$high_level_path,$registered_studies);

  my %config_files = (
		      'tempdir' => $dir,
		      'high_level' => $high_level_path,
		      'log_file' => $import_log_file
	     );
  return(\%config_files);
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
