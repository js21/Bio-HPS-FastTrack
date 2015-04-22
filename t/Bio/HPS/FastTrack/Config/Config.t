#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use File::Slurp;
    use_ok('Bio::HPS::FastTrack::Config::Config');
  }

ok (my $parent_config = Bio::HPS::FastTrack::Config::Config->new(
							     study => 'MRSA studies',
							     lane => '15360_1#1',
							     database => 'pathogen_hpsft_test',
							     db_alias => 'fast_track',
							     root => '/nfs/pathnfs05/conf/',
							     pipeline_stage => '',
							     mode => 'test'
							    ),
    'Parent config object creation');

is_deeply( $parent_config->config_files(), {}, 'Parent config returns empty hash for config files');
is ( $parent_config->run(), 1, 'Parent config run method simply returns true');

done_testing();
