package Bio::HPS::FastTrack::Config::Annotation;

# ABSTRACT: Annotation pipeline config class. Inherits from the parent class Config

=head1 SYNOPSIS

my $annotation_config = Bio::HPS::FastTrack::Config::Annotation->new(study => 'My Study', lane => 'My lane' , database => 'My_Database', db_alias => 'My_db_Alias', root => 'My/Root/Path', mode => 'test');

=cut

use Moose;
extends('Bio::HPS::FastTrack::Config::Config');


no Moose;
__PACKAGE__->meta->make_immutable;
1;
