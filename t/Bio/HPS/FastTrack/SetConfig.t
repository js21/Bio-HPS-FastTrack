#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::HPS::FastTrack::SetConfig');
  }

ok (my $pipeline_config = Bio::HPS::FastTrack::SetConfig->new(
							      study => 'Comparative RNA-seq analysis of three bacterial species',
							      database => 'pathogen_hpsft_test',
							      pipeline_stage => 'import_cram_pipeline',
							      db_alias => 'fast_track',
							      root => 't/data/conf/',
							      mode => 'test'
							     ),
    'Import Object Creation');
ok ( $pipeline_config->config_files(), 'Get config files');


done_testing();
