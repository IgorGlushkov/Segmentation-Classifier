#!/usr/local/bin/perl
#use Encode;
use Cwd qw(abs_path);
$path = abs_path($0);
$path=~ s/\/rpatch.pl//;
$path1=$path;
opendir(DIR, ".");
@files=sort(grep(/\.tif/, readdir(DIR)));

open (FILE, ">171381_140826rpatch.bat");
#chmod 0777, rpatch.bat;

my @newim =();

foreach(@files){
        $image=$_;
	$image_old=$image;
        $image=~ s/.tif//;
        $image=~ s/.TIF//;
        print FILE "r.in.gdal -e -k --overwrite input=$path1/$image_old output=$image\n";
	
	push @newim, $image;

}

	$im=join(',',@newim);
	print FILE "g.region rast=SP5_CH_171381_140826.1 res=10\n";
	print FILE "r.patch --overwrite input=$im output=171381_140826_class\n";
	print FILE "r.out.gdal -f --overwrite input=171381_140826_class output=$path/171381_140826_class\.tif format=GTiff type=UInt16\n";
