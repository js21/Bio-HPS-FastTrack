#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use File::Slurp;
    use_ok('Bio::HPS::FastTrack::Config::Import');
  }

ok (my $import_config = Bio::HPS::FastTrack::Config::Import->new(
								 study => 'MRSA studies',
								 lane => '15360_1#1',
								 database => 'pathogen_hpsft_test',
								 db_alias => 'fast_track',
								 root => 't/data/conf/',
								 pipeline_stage => 'import_cram',
								 mode => 'test'
							    ),
    'Import lane for study config object creation');

ok ( $import_config->config_files(), 'Set configuration files for import');
ok ( -e $import_config->config_files->{'low_level'}, 'Low level config file in place' );
ok ( my @lines = read_file( $import_config->config_files->{'low_level'} ), 'Read low level import config file for MRSA lane') ;

is ($lines[2], qq(            'database' => 'pathogen_hpsft_test',\n), 'Database in place');
is ($lines[21], qq(  'log' => 't/data/log/import_cram_logfile.log',\n), 'Log in place');
is ($lines[24], qq(                               '15360_1#1'\n), 'Lane in place' );

ok ( dir_to_remove($import_config->config_files->{'tempdir'}->dirname), 'Removed temp directory');


ok ( my $import_config2 = Bio::HPS::FastTrack::Config::Import->new(
								   study => 'MRSA studies',
								   database => 'pathogen_hpsft_test',
								   db_alias => 'fast_track',
								   root => 't/data/conf/',
								   pipeline_stage => 'import_cram',
								   mode => 'test'
								  ),
     'Import study config object creation');

ok ( $import_config2->config_files(), 'Set configuration files for import');
ok ( -e $import_config2->config_files->{'low_level'}, 'Low level config file in place' );
ok ( my @lines2 = read_file( $import_config2->config_files->{'low_level'} ), 'Read low level config file for MRSA study' );

is ($lines[2], qq(            'database' => 'pathogen_hpsft_test',\n), 'Database in place');
is ($lines[21], qq(  'log' => 't/data/log/import_cram_logfile.log',\n), 'Log in place');
is ($lines2[24], qq(                               'MRSA\\ studies'\n), 'Lane in place' );

ok ( dir_to_remove($import_config2->config_files->{'tempdir'}->dirname), 'Removed temp directory');


done_testing();


sub dir_to_remove {
  my ($dir_to_remove) = @_ ;
  my $output = `rm -rf $dir_to_remove`;
  return 1 if ($output eq q());
}
