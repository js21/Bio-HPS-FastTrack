package Bio::HPS::FastTrack::Config::Import;

# ABSTRACT: Import pipeline config class. Inherits from the parent class Config

=head1 SYNOPSIS

my $import_config = Bio::HPS::FastTrack::Config::Import->new(study => 'My Study', lane => 'My lane' , database => 'My_Database', db_alias => 'My_db_Alias', root => 'My/Root/Path', pipeline_stage => 'import_cram_pipeline' mode => 'test');

=cut

use Moose;
use File::Slurp;
extends('Bio::HPS::FastTrack::Config::Config');


sub _build_config_files {

  my ($self) = @_;
  my $dir = File::Temp->newdir($self->root . 'XXXX', CLEANUP => 0);
  print($self->db_alias,"\n");
  my $suffix_for_config_path = $self->db_alias() eq 'no alias' ? $self->database() : $self->db_alias();

  my $high_level_path = $dir->dirname . q(/) . $self->pipeline_stage . q(_) . $suffix_for_config_path . q(.conf);
  my $low_level_path = $dir->dirname . q(/) . 'import_cram_global' . q(.conf);

  _write_high_level_conf_file($self,$high_level_path,$low_level_path);
  _write_low_level_conf_file($self,$low_level_path,$suffix_for_config_path);

  my %config_files = (
		      'tempdir' => $dir,
		      'high_level' => $high_level_path,
		      'low_level' => $low_level_path
	     );
  return(\%config_files);
}

sub _write_high_level_conf_file {

  my ($self, $high_level_path, $low_level_path) = @_;
  my $hl_buffer =<<END_OF_HL_BUFFER;
__VRTrack_Import_cram__ $low_level_path
END_OF_HL_BUFFER

  write_file( $high_level_path, \$hl_buffer ) ;

}

sub _write_low_level_conf_file {

  my ($self, $low_level_path, $suffix_for_config_path) = @_;
  my $template = $self->root() . q(/) . 'prokaryotes/import_cram/import_cram_global.conf';
  my @lines = read_file( $template );
  my $ll_buffer;
  my $database = $self->database();

  for my $line(@lines) {
    chomp($line);
    $line =~ s/('database' => ')[a-z_]*/$1$database/;
    $line =~ s/(\/nfs\/pathnfs05\/log\/)[a-z_]*(\/import_cram_logfile.log)/$1$suffix_for_config_path$2/;
    $line =~ s/(\/lustre\/scratch108\/pathogen\/pathpipe\/)[a-z_]*(\/seq-pipelines)/$1$suffix_for_config_path$2/;
    $ll_buffer .= "$line\n";
  }
  write_file( $low_level_path, $ll_buffer );
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
