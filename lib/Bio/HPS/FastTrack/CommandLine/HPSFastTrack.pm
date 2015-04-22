package Bio::HPS::FastTrack::CommandLine::HPSFastTrack;

# ABSTRACT: Command line API for the HPS FastTrack application

=head1 SYNOPSIS


=cut

use Moose;
use Getopt::Long qw(GetOptionsFromArray);
use Bio::HPS::FastTrack;
use Bio::HPS::FastTrack::Types::FastTrackTypes;
use Bio::HPS::FastTrack::Exception;

has 'args'        => ( is => 'ro', isa => 'ArrayRef', required => 1 );
has 'script_name' => ( is => 'ro', isa => 'Str',      required => 1 );
has 'help'        => ( is => 'rw', isa => 'Bool',     default  => 0 );

has 'study' => ( is => 'rw', isa => 'Str', lazy => 1, default => '');
has 'lane' => ( is => 'rw', isa => 'Str', lazy => 1, default => '');
has 'database'   => ( is => 'rw', isa => 'Str');
has 'pipeline'   => ( is => 'rw', isa => 'Maybe[ArrayRef]', lazy => 1, default => sub { [] });
has 'sleep_time'   => ( is => 'rw', isa => 'Int', default => 120 );
has 'mode'   => ( is => 'rw', isa => 'RunMode', default => 'prod' );

sub BUILD {

    my ($self) = @_;

    my ( $study, $lane, $database, $pipeline, $sleep_time, $mode, $help );

    GetOptionsFromArray(
			$self->args,
			's|study=s' => \$study,
			'l|lane:s' => \$lane,
			'd|db=s'   => \$database,
			'p|pipeline=s@' =>\$pipeline,
			't|sleep_time:s' =>\$sleep_time,
			'm|mode:s' =>\$mode,
			'h|help'           => \$help,
    );

    $self->study($study) if ( defined($study) );
    $self->lane($lane) if ( defined($lane) );
    $self->database($database)     if ( defined($database) );
    $self->pipeline($pipeline)     if ( defined($pipeline) );
    $self->sleep_time($sleep_time) if ( defined($sleep_time) );
    $self->mode($mode) if ( defined($mode) );

}

sub run {
    my ($self) = @_;

    ( ($self->study || $self->lane) && $self->database && scalar @{$self->pipeline} > 0 ) or die die_with_usage();

    my $hps_fast_track = Bio::HPS::FastTrack->new(
						  study => $self->study,
						  lane => $self->lane,
						  database   => $self->database,
						  pipeline => $self->pipeline,
						  sleep_time => $self->sleep_time,
						  mode => $self->mode,
						 );
    $hps_fast_track->run;
}

sub die_with_usage {

my $usage = <<USAGE;
Usage:
  Specify the study name, the lane or both
  -d|database      <the tracking database to store the relevant data for the study/lane>
  -p|pipeline      <the pipeline to run>
  -s|study         <optional: Study name to fast track>
  -l|lane          <optional: Lane name to fast track>
  -t|sleep_time    <optional: Time in seconds to wait for pipeline to run. Defaults to 120 seconds>
  -h|help          <print this message>

Utility script to fast track high priority samples through the Pathogen Informatics pipelines


USAGE

return $usage;

}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
