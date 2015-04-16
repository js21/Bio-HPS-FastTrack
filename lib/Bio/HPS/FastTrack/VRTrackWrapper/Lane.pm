package Bio::HPS::FastTrack::VRTrackWrapper::Lane;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $hps_lane = Bio::HPS::FastTrack::VRTrackWrapper::Lane->new(
							     database => 'pathogen_prok_track_test',
							     mode => 'prod',
							     lane_name => '7229_2#35',
							    )->vrlane;


=cut

use Moose;
use Bio::HPS::FastTrack::Types::FastTrackTypes;
extends('Bio::HPS::FastTrack::VRTrackWrapper::VRTrack');

has 'lane_name'      => ( is => 'rw', isa => 'Str', required => 1 );
has 'run_id' => ( is => 'rw', isa => 'Int', builder => '_build_run_id' );
#has 'vrlane' => ( is => 'rw', isa => 'VRTrack::Lane', builder => '_build_vrtrack_lane' );


sub _build_run_id {

  my ($self) = @_;
  my $run_id = $self->lane_name;
  $run_id =~ s/(^[0-9]+)_.*/$1/g;
  return $run_id;
}

sub _build_vrtrack_lane {

  my ($self) = @_;
  my $vrlane = VRTrack::Lane->create($self->vrtrack, $self->lane_name);
  return $vrlane;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
