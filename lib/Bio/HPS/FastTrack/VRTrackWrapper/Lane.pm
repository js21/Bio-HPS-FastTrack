package Bio::HPS::FastTrack::VRTrackWrapper::Lane;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $hps_lane = Bio::HPS::FastTrack::VRTrackWrapper::Lane->new(
							     database => 'pathogen_prok_track_test',
							     lane_name => '7229_2#35',
							    );


=cut

use Moose;
use Bio::HPS::FastTrack::Exception;
use Bio::HPS::FastTrack::Types::FastTrackTypes;
extends('Bio::HPS::FastTrack::VRTrackWrapper::VRTrack');

has 'lane_name'      => ( is => 'rw', isa => 'Str', required => 1 );
has 'study_name' => ( is => 'rw', isa => 'Str', lazy => 1, builder => '_build_study_name' );
has 'run_id' => ( is => 'rw', isa => 'Int', lazy => 1, builder => '_build_run_id' );


sub _build_run_id {

  my ($self) = @_;
  my $run_id = $self->lane_name;
  $run_id =~ s/(^[0-9]+)_.*/$1/g;
  return $run_id;
}

sub _build_study_name {

  my ($self) = @_;

  my $lane_name = _wrap_in_single_quotes($self->lane_name);

  my $sql = <<"END_OF_SQL";
select p.`name` from latest_lane as la
inner join latest_library as li on (li.`library_id` = la.`library_id`)
inner join latest_sample as s on (s.`sample_id` = li.`sample_id`)
inner join latest_project as p on (p.`project_id` = s.`project_id`)
where la.`name` = $lane_name;
END_OF_SQL

  $self->connection();

  my $sth = $self->connection->prepare($sql);
  $sth->execute();

  my $study_name;
  while (my $ref = $sth->fetchrow_arrayref()) {
    $study_name = $ref->[0];
  }
  $sth->finish();
  $self->connection->disconnect();

  if (defined $study_name && $study_name ne q()) {
    return( $study_name );
  }
  else {
    Bio::HPS::FastTrack::Exception::StudyNameNotFoundForLane->throw(
								    error => "Error: Could not retrieve the study name for lane '" .
								    $self->lane_name . "' from database '" .
								    $self->database() . "'\n"
								   );
  }
}

sub _wrap_in_single_quotes {

  my ($string_to_wrap) = @_;
  my $wrapped_string = q(') . $string_to_wrap . q(');
  return $wrapped_string;
}

sub _get_user_input_not_used {

    print "The study for this lane was not found in the database. Please specify the study name for this lane bellow, so it can be retrieved from SequenceScape\n";
    my $user_input = <STDIN>;
    chomp($user_input);
    return( $user_input );
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
