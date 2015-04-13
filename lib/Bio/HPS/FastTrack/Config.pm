package Bio::HPS::FastTrack::Config;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $hps_config = Bio::HPS::FastTrack::Config->new( id => '123', database => 'pathogen_prok_track_test')

=cut

use Moose;
use File::Slurp;
use File::Spec;
use Cwd qw/abs_path/;
use Bio::HPS::FastTrack::Exception;
use Bio::HPS::FastTrack::Types::FastTrackTypes;

has 'study_name' => ( is => 'rw', isa => 'Str', lazy => 1, default => 'NA' );
has 'lane' => ( is => 'rw', isa => 'Str', lazy => 1, default => 'NA' );
has 'database'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'db_alias'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'add_to_config_path' => ( is => 'rw', isa => 'Str', required => 1 );
has 'mode'   => ( is => 'rw', isa => 'RunMode', required => 1 );
has 'config_root' => ( is => 'rw', isa => 'Str', lazy => 1, default => '/nfs/pathnfs05/conf' );
has 'path_to_high_level_config' => ( is => 'rw', isa => 'Str', lazy => 1, builder => '_build_path_to_high_level_config');
has 'path_to_low_level_config' => ( is => 'rw', isa => 'Str', lazy => 1, builder => '_build_path_to_low_level_config');

sub _build_path_to_high_level_config {

  my ($self) = @_;
  my $high_level_conf_filename = $self->database() . '_' . $self->add_to_config_path() . '_' . 'pipeline.conf';

  if( $self->mode eq 'test' ) {
    $self->config_root('t/data/conf/');
  }

  my $path;
  if( $self->db_alias eq 'no alias' ) {
    $path = File::Spec->catfile($self->config_root(), $self->database(), $high_level_conf_filename) ||
      Bio::HPS::Exception::FullPathNotPossible->throw( error => "Error: Could not establish the full path with config root '" . $self->config_root() . "'\n" );

    return $path;
  }
  else {
    $path = File::Spec->catfile($self->config_root(), $self->db_alias(), $high_level_conf_filename) ||
      Bio::HPS::Exception::FullPathNotPossible->throw( error => "Error: Could not establish the full path with config root '" . $self->config_root() . "'\n" );

    return $path;
  }
}

sub _build_path_to_low_level_config {

  my ($self) = @_;

  my @lines = read_file( $self->path_to_high_level_config );
  my @split;
  for my $line(@lines) {
    chomp($line);
    my $study_name = $self->study_name;
    if ($line =~ m/$study_name/) {
      @split = split(' ', $line);
    }
  }
  return $split[1] if ( defined $split[1] && $split[1] ne q());
  return 'Study not found in high level config file';
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
