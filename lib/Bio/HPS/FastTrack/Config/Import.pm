package Bio::HPS::FastTrack::Config::Import;

# ABSTRACT: Import pipeline config class. Inherits from the parent class Config

=head1 SYNOPSIS

my $import_config = Bio::HPS::FastTrack::Config::Import->new(study => 'My Study', lane => 'My lane' , database => 'My_Database', db_alias => 'My_db_Alias', root => 'My/Root/Path', pipeline_stage => 'import_cram_pipeline' mode => 'test');

=cut

use Moose;
use File::Slurp;
extends('Bio::HPS::FastTrack::Config::Config');

has 'config_template' => ( is => 'ro', isa => 'Str', default => '/nfs/pathnfs05/conf/prokaryotes/import_cram/import_cram_global.conf' );

sub _build_config_files {

  my ($self) = @_;
  my $dir = File::Temp->newdir($self->root . 'XXXX', CLEANUP => 0);
  my $suffix_for_config_path = $self->db_alias() eq 'no alias' ? $self->database() : $self->db_alias();

  my $high_level_path = $dir->dirname . q(/) . $self->pipeline_stage . q(_) . $suffix_for_config_path . q(.conf);
  my $low_level_path = $dir->dirname . q(/) . 'import_cram_global' . q(.conf);

  my $pipeline = $self->pipeline_stage;
  $pipeline =~ s/_cram//;
  my $import_log_file = $self->log_root . $suffix_for_config_path . q(_) . $pipeline . q(.log);

  _write_high_level_conf_file($self,$high_level_path,$low_level_path);
  _write_low_level_conf_file($self,$low_level_path,$suffix_for_config_path);

  my %config_files = (
		      'tempdir' => $dir,
		      'high_level' => $high_level_path,
		      'low_level' => $low_level_path,
		      'log_file' => $import_log_file
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
  my @lines = read_file( $self->config_template );
  my $ll_buffer;
  my $database = $self->database();

  for my $line(@lines) {
    chomp($line);
    if ( $self->mode eq 'test' ) {
      $line =~ s/'port' => '3347'/'port' => '3346'/;
      $line =~ s/'host' => 'patp-db'/'host' => 'patt-db'/;
    }
    $line =~ s/('database' => ')[a-z_]*/$1$database/;
    $line =~ s/(\/nfs\/pathnfs05\/log\/)[a-z_]*(\/import_cram_logfile.log)/$1$suffix_for_config_path$2/;
    $line =~ s/(\/lustre\/scratch108\/pathogen\/pathpipe\/)[a-z_]*(\/seq-pipelines)/$1$suffix_for_config_path$2/;

    if ($line =~ m/\s{2}'root'/) {
      if ( defined $self->study && $self->study ne q() && (!defined $self->lane || $self->lane eq q()) ) {
	my $limits = _get_limits_string($self,'project');

	$ll_buffer .= "$limits\n";
      }
      elsif ( defined $self->lane && $self->lane ne q() ) {
	my $limits = _get_limits_string($self,'lane');

	$ll_buffer .= "$limits\n";
      }
    }
    $ll_buffer .= "$line\n";
  }
  write_file( $low_level_path, $ll_buffer );
}


sub _get_limits_string {

  my ($self,$feature) = @_;
  my $feature_to_print;
  $feature_to_print = $feature eq 'project' ? $self->study : $self->lane;
  $feature_to_print =~ s/\s/\\ /g;
  my $limits =<<END_OF_LIMITS_STRING;
  'limits' => {
                '$feature' => [
                               '$feature_to_print'
                             ]
              },
END_OF_LIMITS_STRING

  return $limits;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
