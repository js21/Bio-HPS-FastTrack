package Bio::HPS::FastTrack::Exception;

#ABSTRACT: Exceptions for the High Priority Samples FastTrack system

=head1 SYNOPSIS

Exceptions for the High Priority Samples FastTrack system

=cut


use Exception::Class (
		      Bio::HPS::FastTrack::Exception::FileDoesNotExist                       => { description => 'Cannot find file' },
		      Bio::HPS::FastTrack::Exception::FullPathNotPossible                    => { description => 'Cannot create absolute path for a file' },
		      Bio::HPS::FastTrack::Exception::DatabaseConnection          => { description => 'Database, host or port parameters are wrong' },
		      Bio::HPS::FastTrack::Exception::PipelineNotSupported                   => { description => 'Pipeline not supported or not specified' },
		      Bio::HPS::FastTrack::Exception::NoPipelineSpecified                    => { description => 'No pipeline was specified as an argument' },
		      Bio::HPS::FastTrack::Exception::SeveralStudiesForStudyName  => { description => 'Several studies retrieved for the study name string' },
		      Bio::HPS::FastTrack::Exception::StudyNameNotFoundForLane    => { description => 'Study not present in tracking database. User will have to specify a study name' },
		      Bio::HPS::FastTrack::Exception::StudyAndLaneNotSpecified    => { description => 'Study and lane parameters need to be specified' },
		     );

1;
