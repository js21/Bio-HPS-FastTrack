package TestHelper;
use Moose::Role;
use Test::Most;
use File::Slurp;
use File::Compare;
use Data::Dumper;

sub mock_execute_script_and_check_output {
    my ( $script_name, $scripts_and_expected_files ) = @_;

    system('touch empty_file');

    #open OLDOUT, '>&STDOUT';
    #open OLDERR, '>&STDERR';
    eval("use $script_name ;");

    #print "SCRIPT_NAME: $script_name\n";
    my $returned_values = 0;
    {
        #local *STDOUT;
        #open STDOUT, '>/dev/null' or warn "Can't open /dev/null: $!";
        #local *STDERR;
        #open STDERR, '>/dev/null' or warn "Can't open /dev/null: $!";

        for my $script_parameters ( sort keys %$scripts_and_expected_files ) {
            my $full_script = $script_parameters;
            my @input_args = split( " ", $full_script );

            my $cmd =
"$script_name->new(args => \\\@input_args, script_name => '$script_name')->run;";
            eval($cmd);
            warn $@ if $@;
            my $actual_output_file_name =
              $scripts_and_expected_files->{$script_parameters}->[0];
            my $expected_output_file_name =
              $scripts_and_expected_files->{$script_parameters}->[1];

            ok( -e $actual_output_file_name,
                "Actual output file exists $actual_output_file_name" );

            if ( $script_name eq 'Bio::RNASeq::CommandLine::GFF3Concat' ) {
                unless ( $actual_output_file_name eq 'empty_file' ) {
                    open( my $fh, '<', $actual_output_file_name );
                    my @lines = <$fh>;
                    close($fh);

                    print Dumper(@lines);
                    ok( $lines[0] eq "##gff-version 3\n", 'First output line' );
                    ok(
                        $lines[9] eq
"Pk_strainH_chr02\tchado\tCDS\t3173\t3787\t.\t-\t0\tID=PKH_020010.1:exon:4;Parent=PKH_020010.1;Start_range=.%2C.;isObsolete=false;timelastmodified=10.12.2012+03:08:55+GMT;colour=7\n",
                        '10th output line'
                    );
                    ok( $lines[19] eq "##FASTA\n", '20th output line' );
                    ok( $lines[29] eq ">Pk_strainH_chr02\n",
                        '30th output line' );
                    ok(
                        $lines[31] eq
"gaaccctactcctaaacccggaaccctactcctaaacccggaatgtatgttcctacacca\n",
                        "32nd output line"
                    );
                    ok(
                        $lines[39] eq
"agaaggtaggggtactagaataaagttatagaggtgtcaggttaacgttgtgggggtgtt\n",
                        "40th output line"
                    );
                    ok( scalar @lines == 40, "Total lines in output file" );
		  }
	      }
	  }

        #close STDOUT;
	#close STDERR;
      }



    ## Restore stdout.
    #open STDOUT, '>&OLDOUT' or die "Can't restore stdout: $!";
    #open STDERR, '>&OLDERR' or die "Can't restore stderr: $!";
     
    # Avoid leaks by closing the independent copies.
    #close OLDOUT or die "Can't close OLDOUT: $!";
    #close OLDERR or die "Can't close OLDERR: $!";
    unlink('empty_file');

}

sub mock_execute_script_and_check_multiple_file_output {

    my ( $script_name, $scripts_and_expected_files ) = @_;

    #system('touch empty_file');

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

            my $cmd =
"$script_name->new(args => \\\@input_args, script_name => '$script_name')->run;";
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
