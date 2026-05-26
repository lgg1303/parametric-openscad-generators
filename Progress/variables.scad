$fn = 64;

/*

length = 100;
width = 50;
thickness = 6;

hole_diameter = 5;
hole_offset_x = 40;
hole_offset_y = 20;

difference() {
    // Body
    cube([length, width, thickness], center=true);


    // Holes manual
    translate([ hole_offset_x,  hole_offset_y, 0])
        cylinder(h=thickness + 2, d=hole_diameter, center=true);

    translate([-hole_offset_x,  hole_offset_y, 0])
        cylinder(h=thickness + 2, d=hole_diameter, center=true);

    translate([ hole_offset_x, -hole_offset_y, 0])
        cylinder(h=thickness + 2, d=hole_diameter, center=true);

    translate([-hole_offset_x, -hole_offset_y, 0])
        cylinder(h=thickness + 2, d=hole_diameter, center=true);
    
    
    //Holes loop
    for( x = [hole_offset_x, -hole_offset_x]){
        for(y = [hole_offset_y, -hole_offset_y]){
            translate([x,y,0])
                cylinder(h = thickness + 2, d = hole_diameter, center = true);
        }
    }
    
}
*/


$fn = 64;

plate_radius = 20;
thickness = 5;

hole_diameter = 5;
hole_distance = 15;
n_holes = 8;

difference(){
    
    cylinder(h=thickness,r = plate_radius,center = true);
    
    angle = 360/n_holes;
    
    for(i = [0:angle:360-angle]){

        rotate([0,0,i])
        translate([hole_distance,0,0])
        cylinder(h=thickness+2, d = hole_diameter, center = true);
    }
    
}




