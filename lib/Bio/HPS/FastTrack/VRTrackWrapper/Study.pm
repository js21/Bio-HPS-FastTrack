package Bio::HPS::FastTrack::VRTrackWrapper::Study;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $study = Bio::HPS::FastTrack::VRTrackWrapper::Study->new(study => 2027, database => 'pathogen_prok_track_test', mode => 'prod'), 'Study object creation' );

=cut

use Moose;
use DBI;
use File::Slurp;
use Bio::HPS::FastTrack::VRTrackWrapper::Lane;
use VRTrack::Project;
use Bio::HPS::FastTrack::Exception;
use Bio::HPS::FastTrack::Types::FastTrackTypes;
use Data::Dumper;
extends('Bio::HPS::FastTrack::VRTrackWrapper::VRTrack');

has 'study' => ( is => 'rw', isa => 'Str', required => 1 );
has 'vrtrack_study' => ( is => 'rw', isa => 'VRProject', lazy => 1, builder => '_build_vrtrack_study');
has 'lanes' => ( is => 'rw', isa => 'HashRef', lazy => 1, builder => '_build_list_of_lanes_for_study');

sub _build_list_of_lanes_for_study {

  my ($self) = @_;
  $self->_get_lane_data_from_database();
}

sub _build_vrtrack_study {

  my ($self) = @_;

  $self->_set_full_study_name();
  my $vrtrack_study = VRTrack::Project->new_by_name( $self->vrtrack(), $self->study);
  if (defined $vrtrack_study && $vrtrack_study ne qq() ) {
    return $vrtrack_study;
  }
  else {
    return _study_not_found($self->study);
  }
}

sub _study_not_found {
  my ($study) = @_;
  my %study_not_found = (
			 study => $study,
			 status   => 'study not found in tracking database'
			);
  bless(\%study_not_found, "VRProject");
  return \%study_not_found;
}

sub _set_full_study_name {

  my ($self) = @_;
  my $sql_study_name_regex = _prepare_sql_study_name_string($self->study);
  my $sql = <<"END_OF_SQL";
select p.`name` from latest_project as p
where p.`name` like $sql_study_name_regex
END_OF_SQL

  my $dbi_driver = $self->mode() eq 'prod' ? 'DBI:mysql:database=' : 'DBI:SQLite:dbname=';
  my $dsn = $dbi_driver . $self->database() . ';host=' . $self->hostname() . ';port=' . $self->port();
  my $dbh = DBI->connect($dsn, $self->user()) ||
    Bio::HPS::FastTrack::Exception::DatabaseConnection->throw(
							      error => "Error: Could not connect to database '" .
							      $self->database() . "' on host '" .
							      $self->hostname . "' on port '" . $self->port . "'\n"
							     );
  my $sth = $dbh->prepare($sql);
  $sth->execute();
  my $ref = $sth->fetchrow_arrayref();

  return 1 if !defined $ref;

  Bio::HPS::FastTrack::Exception::SeveralStudiesForStudyName->throw(
								    error => "Error: There are several studies in the database for the study name '" .
								    $self->study() . "' Try again with the full study name"
								   ) if scalar @{ $ref } > 1;
  $self->study($ref->[0]);
  $sth->finish();
  $dbh->disconnect();
}

sub _get_lane_data_from_database {

  my ($self) = @_;
  my %lanes;
  my $sql_study_name_regex = _prepare_sql_study_name_string($self->study);
  my $sql = <<"END_OF_SQL";
select la.`name` from latest_lane as la
inner join latest_library as li on (li.`library_id` = la.`library_id`)
inner join latest_sample as s on (s.`sample_id` = li.`sample_id`)
inner join latest_project as p on (p.`project_id` = s.`project_id`)
where p.`name` like $sql_study_name_regex
group by la.`name`
order by la.`name`;
END_OF_SQL

  my $dbi_driver = $self->mode() eq 'prod' ? 'DBI:mysql:database=' : 'DBI:SQLite:dbname=';
  my $create_test_db = 't/data/database/create_test_db_and_populate.sql';
  my $destroy_test_db = 't/data/database/create_test_db_and_populate.sql';
  _use_sqllite_test_db($create_test_db) if $self->mode eq 'test';

  my $dsn = $dbi_driver . $self->database() . ';host=' . $self->hostname() . ';port=' . $self->port();
  my $dbh = DBI->connect($dsn, $self->user()) ||
    Bio::HPS::FastTrack::Exception::DatabaseConnection->throw(
							      error => "Error: Could not connect to database '" .
							      $self->database() . "' on host '" .
							      $self->hostname . "' on port '" . $self->port . "'\n"
							     );
  my $sth = $dbh->prepare($sql);
  $sth->execute();
  while (my $ref = $sth->fetchrow_arrayref()) {
    my $lane = Bio::HPS::FastTrack::VRTrackWrapper::Lane->new(
							     database => $self->database,
							     mode => $self->mode,
							     lane_name => $ref->[0]
							    )->vrlane;
    $lanes{$lane->hierarchy_name} = $lane;
  }
  $sth->finish();

  _use_sqllite_test_db($destroy_test_db) if $self->mode eq 'test';
  $dbh->disconnect();

  return \%lanes;
}

sub _prepare_sql_study_name_string {

  my ($study_name) = @_;
  return(q(') . $study_name . q(%'));
}

sub _use_sqllite_test_db {

  my ($file) = @_;
  my $dsn = 'DBI:SQLite:dbname=t/data/database/test.db';
  my $dbh = DBI->connect($dsn);
  my @sql = read_file($file);
  for my $stmt (@sql) {
    $dbh->do($stmt);
  }
  $dbh->disconnect();
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
