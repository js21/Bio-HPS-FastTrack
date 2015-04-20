package Bio::HPS::FastTrack::VRTrackWrapper::VRTrack;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $hps_vrtrack = Bio::HPS::FastTrack::VRTrackWrapper::VRTrack->new( database => 'database', mode => 'test');

=cut

use Moose;
use lib "/software/pathogen/internal/pathdev/vr-codebase/modules";
use DBI;
use File::Slurp;
use YAML::XS;
use VRTrack::VRTrack;
use Bio::HPS::FastTrack::Types::FastTrackTypes;

has 'database' => ( is => 'rw', isa => 'Str', required => 1 );
has 'mode' => ( is => 'rw', isa => 'RunMode', default => 'prod');
has 'filename' => ( is => 'rw', isa => 'Str', default => 'database.yml' );
has 'settings' => ( is => 'rw', isa => 'HashRef', builder => '_build_settings' );
has 'vrtrack' => ( is => 'rw', isa => 'VRTrack::VRTrack', lazy => 1, builder => '_build_vrtrack_instance' );

sub _build_settings {

  my ($self) = @_;
  my ($settings) = Load( scalar read_file("config/".$self->mode."/".$self->filename.""));
  return $settings;

}

sub _build_vrtrack_instance {

  my ($self) = @_;
  my $mode = $self->mode;
  my %db_params = (
		    host => $self->settings->{$mode}->{'host'},
		    port => $self->settings->{$mode}->{'port'},
		    database => $self->database,
		    user => $self->settings->{$mode}->{'user'},
		    password => ''
		   );
  my $vrtrack = VRTrack::VRTrack->new(\%db_params);
  return $vrtrack;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
