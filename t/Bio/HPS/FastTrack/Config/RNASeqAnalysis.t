#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use File::Slurp;
    use_ok('Bio::HPS::FastTrack::Config::RNASeqAnalysis');
  }

ok (my $rna_seq_config = Bio::HPS::FastTrack::Config::RNASeqAnalysis->new(
							 study => 'Comparative RNA seq analysis of three bacterial species',
							 database => 'pathogen_hpsft_test',
							 db_alias => 'fast_track',
							 root => 't/data/conf/',
							 pipeline_stage => 'rna_seq_pipeline',
							 mode => 'test'
							),
    'RNASeqAnalysis config object creation for study');

ok ( $rna_seq_config->config_files(), 'Set configuration files for rna_seq');
ok ( -e $rna_seq_config->config_files->{'high_level'}, 'High level config file in place' );
ok ( my @lines = read_file( $rna_seq_config->config_files->{'high_level'} ), 'Read high level RNASeqAnalysis config file for study') ;

is ( $lines[0], "__VRTrack_RNASeqExpression__ t/data/conf/fast_track/rna_seq/rna_seq_Comparative_RNA_seq_analysis_of_three_bacterial_species_Clostridium_difficil_840.conf\n", '1st line of high level config');

ok ( dir_to_remove($rna_seq_config->config_files->{'tempdir'}->dirname), 'Removed temp directory');

ok ( my $rna_seq_config2 = Bio::HPS::FastTrack::Config::RNASeqAnalysis->new(
							   lane => '8405_4#11',
							   database => 'pathogen_hpsft_test',
							   db_alias => 'fast_track',
							   root => 't/data/conf/',
							   pipeline_stage => 'rna_seq_pipeline',
							   mode => 'test'
							  ),
     'Creation of RNASeqAnalysis config object for a single lane' );

throws_ok { $rna_seq_config2->config_files } qr/Fast tracking RNASeq/ , 'Fast track RNASeqAnalysis for a single lane is not yet implemented';

done_testing();


sub dir_to_remove {
  my ($dir_to_remove) = @_ ;
  my $output = `rm -rf $dir_to_remove`;
  return 1 if ($output eq q());
}
