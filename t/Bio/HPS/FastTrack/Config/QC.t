#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use File::Slurp;
    use_ok('Bio::HPS::FastTrack::Config::QC');
  }

ok (my $qc_config = Bio::HPS::FastTrack::Config::QC->new(
							 study => 'Comparative RNA seq analysis of three bacterial species',
							 database => 'pathogen_hpsft_test',
							 db_alias => 'fast_track',
							 root => 't/data/conf/',
							 pipeline_stage => 'qc_pipeline',
							 mode => 'test'
							),
    'QC config object creation for study');

ok ( $qc_config->config_files(), 'Set configuration files for qc');
ok ( -e $qc_config->config_files->{'high_level'}, 'High level config file in place' );
ok ( my @lines = read_file( $qc_config->config_files->{'high_level'} ), 'Read high level QC config file for study') ;

is ( $lines[0], "__VRTrack_QC__ t/data/conf/fast_track/qc/qc_Comparative_RNA_seq_analysis_of_three_bacterial_species_Clostridium_difficile.conf\n", '1st line of high level config');
is ( $lines[1], "__VRTrack_QC__ t/data/conf/fast_track/qc/qc_Comparative_RNA_seq_analysis_of_three_bacterial_species_Streptococcus_pyogenes.conf\n", '2nd line of high level config');

ok ( dir_to_remove($qc_config->config_files->{'tempdir'}->dirname), 'Removed temp directory');

ok ( my $qc_config2 = Bio::HPS::FastTrack::Config::QC->new(
							   lane => '8405_4#11',
							   database => 'pathogen_hpsft_test',
							   db_alias => 'fast_track',
							   root => 't/data/conf/',
							   pipeline_stage => 'qc_pipeline',
							   mode => 'test'
							  ),
     'Creation of QC config object for a single lane' );

throws_ok { $qc_config2->config_files } qr/Fast tracking QC/ , 'Fast track QC for a single lane is not yet implemented';

done_testing();


sub dir_to_remove {
  my ($dir_to_remove) = @_ ;
  my $output = `rm -rf $dir_to_remove`;
  return 1 if ($output eq q());
}
