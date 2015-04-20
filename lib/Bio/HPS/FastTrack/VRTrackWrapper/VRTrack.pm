package Bio::HPS::FastTrack::VRTrackWrapper::VRTrack;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $hps_vrtrack = Bio::HPS::FastTrack::VRTrackWrapper::VRTrack->new(host => 'host', => port => 'port', database => 'database', user => 'user');

=cut

use Moose;
use lib "/software/pathogen/internal/pathdev/vr-codebase/modules";
use DBI;
use VRTrack::VRTrack;
use Bio::HPS::FastTrack::Types::FastTrackTypes;


has 'database' => ( is => 'rw', isa => 'Str', required => 1 );
has 'hostname' => ( is => 'rw', isa => 'Str', lazy => 1, default => 'patt-db' ); #Test database at the moment, when in production change to 'mcs17'
has 'port' => ( is => 'rw', isa => 'Int', lazy => 1, default => '3346' ); #Test port at the moment, when in production change to '3347'
has 'user' => ( is => 'rw', isa => 'Str', lazy => 1, default => 'pathpipe_ro' );
has 'vrtrack' => ( is => 'rw', isa => 'VRTrack::VRTrack', builder => '_build_vrtrack_instance' );

sub _build_vrtrack_instance {

  my ($self) = @_;
  my %db_params = (
		    host => $self->hostname,
		    port => $self->port,
		    database => $self->database,
		    user => $self->user,
		    password => ''
		   );
  my $vrtrack = VRTrack::VRTrack->new(\%db_params);
  return $vrtrack;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
