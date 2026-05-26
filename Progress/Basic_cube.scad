//cube([40,20,10], center = true);

$fn = 24; //Number segments
//$fn = 24 fast preview
//48 medium quality
//96 High quaility
//+128 Very smoth


translate([10,0,0]) //; breaks the connection between the geometric forme and the action
color("blue")
rotate([45,0,0])
scale([1,2,1]){
cylinder(h=10, r=2, center = true);
}
//sphere(10);

