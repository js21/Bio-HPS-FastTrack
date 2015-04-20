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

my $import_config = Bio::HPS::FastTrack::Config::Import->new(
							     study => 'MRSA studies',
							     lane => '15360_1#1',
							     database => 'pathogen_hpsft_test',
							     db_alias => 'fast_track',
							     root => '/nfs/pathnfs05/conf/',
							     pipeline_stage => 'import_cram',
							     mode => 'test'
							    );
$import_config->config_files();

my @lines = read_file( $import_config->config_files->{'low_level'} ) ;
print Dumper(\@lines);

print Dumper($import_config);
my $dir_to_remove = $import_config->config_files->{'tempdir'};
`rm -rf $dir_to_remove`;
done_testing();
