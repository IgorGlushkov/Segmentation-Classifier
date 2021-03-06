#!/usr/local/bin/perl
#use Encode;
use Cwd qw(abs_path);
$path = abs_path($0);
$path=~ s/\/segment_batch_col.pl//;
#$path1=$path;
#$path1=~ s/$path1/ $path1/;
opendir(DIR, ".");
#sort spectral images (might be another letters) 
@files=sort(grep(/CH/, readdir(DIR)));
#print @files;
#Change name of file containing tiles borders
open (DDR, "171380_140826.tiles");
@reg=<DDR>;
#change prefix
$pref="mas";
#change name of panchromatic images
$PAN="SP5_PAN_171380_140826";
print @reg;
open (FILE, ">171380_140826_col.bat");
#segmentation and adddatafromlayers

foreach(@files){
        $image=$_;
        $image_old=$image;
        $image=~ s/\.TIF//;
        $image=~ s/\.tif//;
        print FILE "r.in.gdal -e -k --overwrite input=$path/$image_old output=$image\n";
	print FILE "v.in.ogr -c -o dsn=$path/$image_old output=$image\n";
        #print FILE "r.tileset -g sourceproj='+proj=utm +zone=39 +south +datum=WGS84 +units=m +no_defs' maxcols=1000 maxrows=1000\n";
        print FILE "g.region rast=$image.1 res=10\n";
        #gauss3x3
         print FILE "r.neighbors -c --overwrite input=$image.1 output=$image.1.g size=3 gauss=0.6\n";
        print FILE "r.neighbors -c --overwrite input=$image.2 output=$image.2.g size=3 gauss=0.6\n";
         print FILE "r.neighbors -c --overwrite input=$image.3 output=$image.3.g size=3 gauss=0.6\n";
         print FILE "r.neighbors -c --overwrite input=$image.4 output=$image.4.g size=3 gauss=0.6\n";
         print FILE "i.group group=$image.g input=$image.1.g,$image.2.g,$image.3.g,$image.4.g\n";
        print FILE "g.region rast=$image.1.g res=10\n";
        print FILE "r.resample --overwrite input=srtm_sl output=tmp_sl\n";
        print FILE "r.resample --overwrite input=srtm_as output=tmp_as\n";
        print FILE "r.resample --overwrite input=srtm_ti output=tmp_ti\n";
        print FILE "r.resample --overwrite input=srtm_mada output=tmp_srtm\n";
        print FILE "i.group group=$image.g input=$image.1.g,$image.2.g,$image.3.g,$image.4.g\n";
	
        foreach(@reg){
                   $line=$_;
                   $line=~ s/\n//;
                   $counter++; 
                   print FILE "g.region $line\n";  
	print FILE "i.segment --overwrite group=$image.g output=$image\_3_10 threshold=0.03 method=region_growing minsize=10 memory=10000 iterations=1000\n";
        print FILE "r.to.vect -s --overwrite input=$image\_3_10 output=$pref\_3_10\_$counter type=area\n";
        print FILE "v.rast.stats -c map=$pref\_3_10\_$counter raster=$image.1.g column_prefix=c1 method=minimum,maximum,range,average,stddev,variance,coeff_var\n";
        print FILE "v.rast.stats -c map=$pref\_3_10\_$counter raster=$image.2.g column_prefix=c2 method=minimum,maximum,range,average,stddev,variance,coeff_var\n";
        print FILE "v.rast.stats -c map=$pref\_3_10\_$counter raster=$image.3.g column_prefix=c3 method=minimum,maximum,range,average,stddev,variance,coeff_var\n";
        print FILE "v.rast.stats -c map=$pref\_3_10\_$counter raster=$image.4.g column_prefix=c4 method=minimum,maximum,range,average,stddev,variance,coeff_var\n";
        print FILE "v.rast.stats -c map=$pref\_3_10\_$counter raster=tmp_srtm column_prefix=sr method=minimum,maximum,range,average,stddev,variance,coeff_var\n";
        print FILE "v.rast.stats -c map=$pref\_3_10\_$counter raster=tmp_as column_prefix=as method=minimum,maximum,range,average,stddev,variance,coeff_var\n";
        print FILE "v.rast.stats -c map=$pref\_3_10\_$counter raster=tmp_sl column_prefix=sl method=minimum,maximum,range,average,stddev,variance,coeff_var\n";
        print FILE "v.rast.stats -c map=$pref\_3_10\_$counter raster=tmp_ti column_prefix=ti method=minimum,maximum,range,average,stddev,variance,coeff_var\n";
	print FILE "g.region vect=$pref\_3_10\_$counter res=3\n";
	print FILE "r.texture --overwrite input=$PAN\.g output=$pref method=sa,sv,de,var,entr size=5\n";
	print FILE "v.rast.stats -c map=$pref\_3_10\_$counter raster=$pref\_DE column_prefix=de method=minimum,maximum,range,average,stddev,variance,coeff_var\n";
	print FILE "v.rast.stats -c map=$pref\_3_10\_$counter raster=$pref\_SA column_prefix=sa method=minimum,maximum,range,average,stddev,variance,coeff_var\n";
	print FILE "v.rast.stats -c map=$pref\_3_10\_$counter raster=$pref\_Var column_prefix=va method=minimum,maximum,range,average,stddev,variance,coeff_var\n";
	print FILE "v.rast.stats -c map=$pref\_3_10\_$counter raster=$pref\_SV column_prefix=sv method=minimum,maximum,range,average,stddev,variance,coeff_var\n";
	print FILE "v.rast.stats -c map=$pref\_3_10\_$counter raster=$pref\_Entr column_prefix=en method=minimum,maximum,range,average,stddev,variance,coeff_var\n";
        print FILE "v.rast.stats -c map=$pref\_3_10\_$counter raster=$PAN\.lm5_DN55 column_prefix=pc method=sum\n";
	print FILE "v.extract --overwrite input=$pref\_3_10\_$counter where='pc_sum >= 0' output=$pref\_$counter\n";
        print FILE "v.out.ogr -e --overwrite input=$pref\_$counter type=area dsn=$path\n";
        
        }

 }




