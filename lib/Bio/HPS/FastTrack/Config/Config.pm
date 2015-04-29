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

has 'suffix_for_config_path' => ( is => 'rw', isa => 'Str', lazy => 1, builder => '_build_suffix_for_config_path' );
has 'log_root' => ( is => 'rw', isa => 'Str', lazy => 1, builder => '_build_log_root' );
has 'config_files' => ( is => 'rw', isa => 'HashRef', lazy => 1, builder => '_build_config_files');

sub BUILD {

  my ($self) = @_;

  if ( $self->study eq q() && $self->lane eq q() ) {
    Bio::HPS::FastTrack::Exception::StudyAndLaneNotSpecified->throw( error => "Study and lane were not specified\n" );
  }

  $self->root('t/data/conf/') if $self->mode eq 'test';
}

#run:
#Method is to be overriden
sub run {
  my ($self) = @_;
  return(1);

}

#_build_log_root:
#Lazy method not needed for the update
#pipeline but needed for the remaining pipelines
sub _build_log_root {

  my ($self) = @_;
  return 't/data/log/' if $self->mode eq 'test';
  return '/nfs/pathnfs05/log/';
}

#_build_suffix_for_config_path:
#Returns the db alias or the name of the database
sub _build_suffix_for_config_path {

  my ($self) = @_;
  return $self->db_alias() eq 'no alias' ? $self->database() : $self->db_alias();
}

#_build_config_files:
#All pipelines with exception of the Update and Import pipelines
#adhere to this rule for config files.
#Returns a hash ref of the path to the high level configuration file,
#the location of the log file and the path to the temporary directory
sub _build_config_files {

  my ($self) = @_;
  return({}) if $self->pipeline_stage eq q();

  my $pipeline = $self->pipeline_stage;
  $pipeline =~ s/_pipeline//;

  my %config_files;
  my $registered_studies;

  my $dir = File::Temp->newdir($self->root . $self->suffix_for_config_path . q(/) . 'XXXX', CLEANUP => 0);
  my $original_high_level_config_path = $self->root . $self->suffix_for_config_path . q(/) . $self->suffix_for_config_path . q(_) . $self->pipeline_stage . q(.conf);
  my $high_level_path = $dir->dirname . q(/) . $self->suffix_for_config_path . q(_) . $self->pipeline_stage . q(.conf); #A temporary high level config file to store the set of studies filtered from the original
  my $log_file = $self->log_root . $self->suffix_for_config_path . q(_) . $self->pipeline_stage . q(.log);

  if ( $self->study ne q() && $self->lane ne q() ) {
    $registered_studies = _extract_studies_and_insert_lane($self,$original_high_level_config_path,$dir);
    _write_high_level_conf_file($self,$high_level_path,$registered_studies);
  }
  else {
    $registered_studies = _extract_studies($self, $original_high_level_config_path, $dir); #Extracting the study strings that matched the study we are interested in
    _write_high_level_conf_file($self,$high_level_path,$registered_studies);
  }

  %config_files = (
		   'tempdir' => $dir,
		   'high_level' => $high_level_path,
		   'log_file' => $log_file
		  );


  return(\%config_files);
}

=head _extract_studies_to_and_insert_lane:

Checks the original config file
for the name of the study we are
interested in. Several registered studies
can be returned from this call

=cut
sub _extract_studies_and_insert_lane {

  my ($self,$original_high_level_config_path,$dir) =@_;

  my @lines = read_file($original_high_level_config_path);

  my $study_string = $self->study;
  $study_string =~ s/\s|-/_/g;
  my @registered_studies;
  for my $reg_study(@lines) {
    chomp($reg_study);
    if ( $reg_study =~ m/$study_string/) {
      $reg_study =~ s/^#+//g;
      my $low_level_file_path = $reg_study;
      $low_level_file_path =~ s/^__[a-zA-Z_]+\s(.*$)/$1/;
      print "$low_level_file_path\n";
      push(@registered_studies, $reg_study);
    }
  }
  if ( scalar @registered_studies == 0 ) {
    my $dir_to_remove = $dir->dirname;
    `rm -rf $dir_to_remove`;
    return Bio::HPS::FastTrack::Exception::StudyNotFoundInHighLevelConfig->throw(
										 error => "Study '" .
										 $self->study .
										 "' is not present in file '$original_high_level_config_path'\n"
										);
  }
  else {
    return \@registered_studies;
  }
}

=head _extract_studies:

Checks the original config file
for the name of the study we are
insterested in. Several study
registries can be returned from this call

=cut
sub _extract_studies {

  my ($self, $original_high_level_config_path, $dir) = @_;

  my @lines = read_file($original_high_level_config_path);

  my $study_string = $self->study;
  $study_string =~ s/\s|-/_/g;
  my @registered_studies;
  for my $reg_study(@lines) {
    chomp($reg_study);
    if ( $reg_study =~ m/$study_string/) {
      $reg_study =~ s/^#+//g;
      push(@registered_studies, $reg_study);
    }
  }
  if ( scalar @registered_studies == 0 ) {
    my $dir_to_remove = $dir->dirname;
    `rm -rf $dir_to_remove`;
    return Bio::HPS::FastTrack::Exception::StudyNotFoundInHighLevelConfig->throw(
										 error => "Study '" .
										 $self->study .
										 "' is not present in file '$original_high_level_config_path'\n"
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
