package Bio::HPS::FastTrack::Config::SNPCalling;

# ABSTRACT: SNPCalling pipeline config class. Inherits from the parent class Config

=head1 SYNOPSIS

my $snp_calling_config = Bio::HPS::FastTrack::Config::SNPCalling->new(study => 'My Study', lane => 'My lane' , database => 'My_Database', db_alias => 'My_db_Alias', root => 'My/Root/Path', mode => 'test');

=cut

use Moose;
extends('Bio::HPS::FastTrack::Config::Config');

sub run {

  my ($self) = @_;
  return 1;

}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
