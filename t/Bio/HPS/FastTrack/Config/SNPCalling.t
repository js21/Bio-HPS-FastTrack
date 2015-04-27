#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use File::Slurp;
    use_ok('Bio::HPS::FastTrack::Config::SNPCalling');
  }

ok (my $snps_config = Bio::HPS::FastTrack::Config::SNPCalling->new(
							 study => 'Comparative RNA seq analysis of three bacterial species',
							 database => 'pathogen_hpsft_test',
							 db_alias => 'fast_track',
							 root => 't/data/conf/',
							 pipeline_stage => 'snps_pipeline',
							 mode => 'test'
							),
    'SNPCalling config object creation for study');

ok ( $snps_config->config_files(), 'Set configuration files for snps');
ok ( -e $snps_config->config_files->{'high_level'}, 'High level config file in place' );
ok ( my @lines = read_file( $snps_config->config_files->{'high_level'} ), 'Read high level SNPCalling config file for study') ;

is ( $lines[0], "__VRTrack_SNPs__ t/data/conf/fast_track/snps/snps_Comparative_RNA_seq_analysis_of_three_bacterial_species_Clostridium_difficil_83.conf\n", '1st line of high level config');

ok ( dir_to_remove($snps_config->config_files->{'tempdir'}->dirname), 'Removed temp directory');

ok ( my $snps_config2 = Bio::HPS::FastTrack::Config::SNPCalling->new(
							   lane => '8405_4#11',
							   database => 'pathogen_hpsft_test',
							   db_alias => 'fast_track',
							   root => 't/data/conf/',
							   pipeline_stage => 'snps_pipeline',
							   mode => 'test'
							  ),
     'Creation of SNPCalling config object for a single lane' );

throws_ok { $snps_config2->config_files } qr/Fast tracking SNP-Calling/ , 'Fast track SNPCalling for a single lane is not yet implemented';

done_testing();


sub dir_to_remove {
  my ($dir_to_remove) = @_ ;
  my $output = `rm -rf $dir_to_remove`;
  return 1 if ($output eq q());
}
