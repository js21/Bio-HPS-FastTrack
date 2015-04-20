package Bio::HPS::FastTrack::Config::Config;

# ABSTRACT: Parent config class for all the types of configuraiton files in the Pathogen Pipelines

=head1 SYNOPSIS

my $config = Bio::HPS::FastTrack::Config::Config->new(study => 'My Study', lane => 'My lane' , database => 'My_Database', db_alias => 'My_db_Alias', root => 'My/Root/Path', pipeline_stage => 'My_Pipeline_Stage', mode => 'test');

=cut

use Moose;
use File::Temp;
use Bio::HPS::FastTrack::Exception;
use Bio::HPS::FastTrack::Types::FastTrackTypes;

has 'study' => ( is => 'rw', isa => 'Str', lazy => 1, default => '' );
has 'lane' => ( is => 'rw', isa => 'Str', lazy => 1, default => '' );
has 'database'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'db_alias'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'root'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'pipeline_stage'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'mode'   => ( is => 'rw', isa => 'RunMode', required => 1 );
has 'config_files' => ( is => 'rw', isa => 'HashRef', lazy => 1, builder => '_build_config_files');

sub run {

  my ($self) = @_;
  return 1;

}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
