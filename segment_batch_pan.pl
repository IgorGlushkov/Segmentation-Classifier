#!/usr/local/bin/perl
#use Encode;
use Cwd qw(abs_path);
$path = abs_path($0);
$path=~ s/segment_batch_pan.pl//;
$path1=$path;
#$path1=~ s/$path1/ $path1/;
chop($path);
opendir(DIR, ".");
@files=sort(grep(/PAN/, readdir(DIR)));

#print @files;

#print @files;
open (FILE, ">segment_pan1.bat");
#segmentation and adddatafromlayers

foreach(@files){
        $image=$_;
        $image_old=$image;
        $image=~ s/.tif//;
        $image=~ s/.TIF//;
        
        print FILE "r.in.gdal -e -k --overwrite input=$path1$image_old output=$image\n";
        print FILE "v.to.rast input=aoi output=MASK use=val \n";
        print FILE "g.region rast=$image res=2.5\n";
        #gauss3x3
         print FILE "r.neighbors -c --overwrite input=$image output=$image.g size=3 gauss=0.6\n";
         print FILE "i.group group=$image.g input=$image.g\n";
        #LOCALMAX 7.5x7.5m sourse 
         print FILE "r.neighbors -c --overwrite input=$image.g output=$image.min method=minimum size=5\n";
	 print FILE "r.mapcalc --overwrite expression=\'$image.lm5=if($image.g == $image.min, $image.g, 0)\'\n"; 
	 print FILE "r.null map=$image.lm5 setnull=0\n"; 
         print FILE "r.mapcalc --overwrite expression=\'$image.lm5_DN70=if($image.lm5n < 70, 1, 0)\'\n";
	 print FILE "r.null map=$image.lm5_DN70 null=0\n";
         #print FILE "r.to.vect -s --overwrite input=$image.lm5_DN50 output=gap_rano393\_lm50 type=point\n";
         #print FILE "v.out.ogr -e input=gap_rano393\_lm50 type=point dsn=$path\n";
         #print FILE "r.texture --overwrite input=$image prefix=and6 method=sa,sv,de,var,entr size=5\n";
         
        }




