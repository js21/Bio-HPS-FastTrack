package TestHelper;
use Moose::Role;
use Test::Most;
use File::Slurp;
use File::Compare;
use Data::Dumper;


sub mock_execute_script_and_check_multiple_file_output {

    my ( $script_name, $scripts_and_expected_files ) = @_;

    system('touch empty_file');

    #open OLDOUT, '>&STDOUT';
    #open OLDERR, '>&STDERR';
    eval("use $script_name ;");

    my $returned_values = 0;
    {
        #local *STDOUT;
	#open STDOUT, '>/dev/null' or warn "Can't open /dev/null: $!";
	#local *STDERR;
	#open STDERR, '>/dev/null' or warn "Can't open /dev/null: $!";

        for my $script_parameters ( sort keys %$scripts_and_expected_files ) {
            my $full_script = $script_parameters;
            my @input_args = split( " ", $full_script );

            my $cmd = "$script_name->new(args => \\\@input_args, script_name => '$script_name')->run;";
	    print "@input_args\n";
            eval($cmd);
            warn $@ if $@;
	    for my $arr_ref( @{ $scripts_and_expected_files->{$script_parameters} } ) {
	      my $actual_output_file_name =
		$arr_ref->[0];
	      my $expected_output_file_name =
		$arr_ref->[1];

	      if ( defined $actual_output_file_name && defined $expected_output_file_name ) {
		ok( -e $actual_output_file_name,
		    "Actual output file exists $actual_output_file_name" );

		ok( -e $expected_output_file_name,
		    "Expected output file exists $expected_output_file_name" );

		if ( $actual_output_file_name ne 'empty_file' ) {
		  print ($actual_output_file_name,"\t",$expected_output_file_name,"\n");
		  is(compare($actual_output_file_name,$expected_output_file_name), 0, "Files are equal");

		}
	      }
	    }
	  }
        #close STDOUT;
	#close STDERR;
      }



    # Restore stdout.
    #open STDOUT, '>&OLDOUT' or die "Can't restore stdout: $!";
    #open STDERR, '>&OLDERR' or die "Can't restore stderr: $!";

    # Avoid leaks by closing the independent copies.
    #close OLDOUT or die "Can't close OLDOUT: $!";
    #close OLDERR or die "Can't close OLDERR: $!";
    #unlink('empty_file');

}

1;
