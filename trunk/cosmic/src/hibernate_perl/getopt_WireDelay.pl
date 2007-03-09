#!/usr/bin/perl
#WireDelay.pl
#input [thresholdTimes files] [output files] [geometryDirectory]
#Data offset by cable length amount

use Getopt::Long;

if($#ARGV < 5){
    die "usage: WireDelay.pl -in [input-file1] -in [input-file2 ...] -out [output-file1] -out [output-file2 ...] -geo [geometry file directory] You have ".($#ARGV+1)." arguments and they are \"@ARGV\"\n";
}

my %h = ();
my $result = GetOptions(\%h, 'in=s@', 'out=s@', 'geo=s');

#Set the command line arguments
@infile = @{$h{'in'}};
@ofile = @{$h{'out'}};
if($h{'geo'}){
    $geo_dir = $h{'geo'};
} else { die "Error: Geometry file directory not specified\n"; }
die "The number of inputs, and outputs must match!\n" if($#infile != $#ofile);

#open up the CommonSubs.pl
$dirname=`dirname $0`;
chomp($dirname);
$commonsubs_loc=$dirname."/CommonSubs.pl";
unless ($return = do $commonsubs_loc) {
    warn "couldn't parse $commonsubs_loc $@" if $@;
    warn "couldn't do $commonsubs_loc: $!"    unless defined $return;
    warn "couldn't run $commonsubs_loc"       unless $return;
    die;
}
$max=2**31;

#While loop to go through all input files
while($infile=shift(@infile)){
    $ofile=shift (@ofile);
    $lastId="";

    #Open input and output files
    open(IN, "$infile")  || die "Cannot open $infile for input";
    open (OUT1, ">$ofile")  || die "Cannot open $ofile for output";
    
    #print the header
    print OUT1 ("#USING WIREDELAYS: ID.CHANNEL, Julian Day, RISING EDGE(sec), FALLING EDGE(sec), TIME OVER THRESHOLD (nanosec)\n");

    #data analysis
    while(<IN>){
        next if /^\s*#/;
        @inputRow= split (/\s+/, $_);
        ($id, $chan) = split /\./, $inputRow[0];
        #get geometry info
        @detectorGeoHash= &all_geo_info($id, $geo_dir) if($lastId !=$id);
        #Wire length delay will be subtracted from "retime" and "fetime" before we output to file
        ##We use the same wireDelay for both rising edge and falling edge, because a user can't reset his geometry between the rising and falling edge pair.
        $cableLenDelay=&wireDelay($inputRow[1]+$inputRow[2],$id,$chan);
        
        #prepare output, resetting jd if necessary
        #caution sometimes rounding errors can occur by 1*10^(-16)
        $reNewTime=$cableLenDelay+$inputRow[2];
        $feNewTime=$cableLenDelay+$inputRow[3];
        $outputJd=$inputRow[1];
        if($reNewTime>=1.0){
            $outputJd=$inputRow[1]+int($reNewTime);
            $reNewTime-=int($reNewTime);
            $feNewTime-=int($feNewTime);
        }

        printf OUT1 ("%s\t%d\t%.16f\t%.16f\t%.2f\n",$inputRow[0],$outputJd,$reNewTime,$feNewTime,$inputRow[4]);
        $lastId=$id;
    }
}

sub wireDelay{
    my $currentJd=$_[0];
    my $detectorIdLookingAt=$_[1];
    my $channelNum=$_[2];
    if(defined($jdRange[0]) && $jdRange[0]<$currentJd && $jdRange[1]>$currentJd){
        #we cam just return delayFromCable because, we reload the hash each time the detector id changes
        return $detectorGeoHash[$positionInHash]{"chan".$channelNum}{'cabLen'}/86400;
    } elsif($#detectorGeoHash==-1){
        die "there is no data in the geometry file\n";
    } else { #find proper cable-delay for specific julian-day time period
        if(0==$#detectorGeoHash) { #only one entry is contained in hash
            @jdRange=($detectorGeoHash[0]{'jd'},$max);
        } else {
            @jdRange=($detectorGeoHash[0]{'jd'},$detectorGeoHash[1]{'jd'});
        }
        if($detectorGeoHash[0]->{jd} > $currentJd) {
            die "there isn't any geometry data for detector #$detectorIdLookingAt on Julian Day:$currentJd\n";
        }
        $positionInHash=0;
        while($positionInHash<= $#detectorGeoHash && (!($jdRange[0]<=$currentJd && $jdRange[1]>$currentJd))){
              $positionInHash++;
              if($positionInHash == $#detectorGeoHash) { # if we are the the last entry of geo file, then that geometry should last untill now. meaning upper bound of range should be at its maximum.
                  @jdRange=($detectorGeoHash[$positionInHash]{'jd'},$max);
              } else {
                  @jdRange=($detectorGeoHash[$positionInHash]{'jd'},$detectorGeoHash[$positionInHash+1]{'jd'});
              }
          }
          return $detectorGeoHash[$positionInHash]{"chan".$channelNum}{'cabLen'}/86400;
      }
  }
