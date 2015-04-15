package Bio::HPS::FastTrack::Exception;

#ABSTRACT: Exceptions for the High Priority Samples FastTrack system

=head1 SYNOPSIS

Exceptions for the High Priority Samples FastTrack system

=cut


use Exception::Class (
		      Bio::HPS::Exception::FileDoesNotExist                       => { description => 'Cannot find file' },
		      Bio::HPS::Exception::FullPathNotPossible                    => { description => 'Cannot create absolute path for a file' },
		      Bio::HPS::FastTrack::Exception::DatabaseConnection          => { description => 'Database, host or port parameters are wrong' },
		      Bio::HPS::Exception::PipelineNotSupported                   => { description => 'Pipeline not supported or not specified' },
		      Bio::HPS::Exception::NoPipelineSpecified                    => { description => 'No pipeline was specified as an argument' },
		      Bio::HPS::FastTrack::Exception::SeveralStudiesForStudyName  => { description => 'Several studies retrieved for the study name string' },
		     );

1;
