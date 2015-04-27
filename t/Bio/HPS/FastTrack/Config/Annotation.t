#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use File::Slurp;
    use_ok('Bio::HPS::FastTrack::Config::Annotation');
  }

ok (my $annotation_config = Bio::HPS::FastTrack::Config::Annotation->new(
							 study => 'Comparative RNA seq analysis of three bacterial species',
							 database => 'pathogen_hpsft_test',
							 db_alias => 'fast_track',
							 root => 't/data/conf/',
							 pipeline_stage => 'annotate_assembly_pipeline',
							 mode => 'test'
							),
    'Annotation config object creation for study');

ok ( $annotation_config->config_files(), 'Set configuration files for assembly');
ok ( -e $annotation_config->config_files->{'high_level'}, 'High level config file in place' );
ok ( my @lines = read_file( $annotation_config->config_files->{'high_level'} ), 'Read high level Annotation config file for study') ;

is ( $lines[0], "__VRTrack_AnnotateAssembly__ t/data/conf/fast_track/annotate_assembly/annotate_assembly_Comparative_RNA_seq_analysis_of_three_bacterial_species_velvet.conf\n", '1st line of high level config');

ok ( dir_to_remove($annotation_config->config_files->{'tempdir'}->dirname), 'Removed temp directory');

ok ( my $annotation_config2 = Bio::HPS::FastTrack::Config::Annotation->new(
							   lane => '8405_4#11',
							   database => 'pathogen_hpsft_test',
							   db_alias => 'fast_track',
							   root => 't/data/conf/',
							   pipeline_stage => 'annotate_assembly_pipeline',
							   mode => 'test'
							  ),
     'Creation of Annotation config object for a single lane' );

throws_ok { $annotation_config2->config_files } qr/Fast tracking Annotation/ , 'Fast track Annotation for a single lane is not yet implemented';

done_testing();


sub dir_to_remove {
  my ($dir_to_remove) = @_ ;
  my $output = `rm -rf $dir_to_remove`;
  return 1 if ($output eq q());
}
