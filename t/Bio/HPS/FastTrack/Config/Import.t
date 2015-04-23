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

my @lines = read_file( $import_config->config_files->{'low_level'} ) ;

is ($lines[2], qq(            'database' => 'pathogen_hpsft_test',\n), 'Database in place');
is ($lines[21], qq(  'log' => 't/data/log/import_cram_logfile.log',\n), 'Log in place');
is ($lines[24], qq(                               '15360_1#1'\n), 'Lane in place' );

my $dir_to_remove = $import_config->config_files->{'tempdir'};
`rm -rf $dir_to_remove`;

my $import_config2 = Bio::HPS::FastTrack::Config::Import->new(
							     study => 'MRSA studies',
							     database => 'pathogen_hpsft_test',
							     db_alias => 'fast_track',
							     root => 't/data/conf/',
							     pipeline_stage => 'import_cram',
							     mode => 'test'
							    );
$import_config2->config_files();

my @lines2 = read_file( $import_config2->config_files->{'low_level'} ) ;
is ($lines[2], qq(            'database' => 'pathogen_hpsft_test',\n), 'Database in place');
is ($lines[21], qq(  'log' => 't/data/log/import_cram_logfile.log',\n), 'Log in place');
is ($lines2[24], qq(                               'MRSA\\ studies'\n), 'Lane in place' );

my $dir_to_remove2 = $import_config2->config_files->{'tempdir'};
`rm -rf $dir_to_remove2`;

done_testing();
