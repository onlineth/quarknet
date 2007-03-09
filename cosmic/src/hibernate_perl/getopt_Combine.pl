#!/usr/bin/perl
# Combines N number of files into one big file
#
#Written by Paul Nepywoda, FNAL on 1-13-04
##PERFORMANCE: cat file1 file2 > file3 actually takes 1.07 times the time that Combine.pl takes
# nepywoda 5-19-04: this is now a "generic" Combine in the sense that it can combine any number of files of any format
# nepywoda 7-13-04: argument tests and correct warning/error output
# dettman 7-20-05: moved to the Getopt format for arguments

use Getopt::Long;
if($#ARGV < 1){
	die "usage: Combine.pl -in [input file 1] -in [input file 2] ... -in [input file N] -out [output file]\n";
}
my %h = ();
my $result = GetOptions(\%h, 'in=s@', 'out=s');

use Digest::MD5 qw(md5_hex);
$ofile = $h{'out'};
@infileList = @{$h{'in'}};
print "@infileList\n";

#md5 input/output file comparison
my $arg_str = join " ", @infileList[0..$#infileList];
my $mtime1 = (stat($0))[9];         #this script's timestamp
foreach $file (@infileList){
    my $mtime = (stat($file))[9];
    $mtimes .= "$mtime ";      #input file's timestamp
}
$arg_str = "$mtime1 $mtimes $arg_str";
my $md5 = md5_hex($arg_str);
if(-e $ofile){
    $outmd5 = `head -n 1 $ofile`;
    $outmd5 = substr($outmd5, 1);
    chomp $outmd5;
    print "md5s COMPUTED:$md5 FROMFILE:$outmd5\n";
    if($md5 eq $outmd5){
        print "input argument md5's match, not re-calculating output file: $ofile\n";
        exit;
    }
}

open(OUT, ">$ofile") or die("Cannot open file: $ofile for output\n");

#output header
print OUT ("#$md5\n");
print OUT ("#md5_hex($arg_str)\n");
print OUT ("#Combined data for files: ");
foreach $file (@infileList){
	print OUT ("$file ");
}
print OUT "\n";

while($infile=shift(@infileList)){
	print "$infile\n";
    open(IN, "$infile") or die("Cannot open file: $infile for input, exiting...\n");
	
	while(<IN>){
		#if the first character is a'#', then we know it's a comment and we can ignore it.
		next if m/^\s*#/;

		print OUT $_;
	}
	close IN;
}
