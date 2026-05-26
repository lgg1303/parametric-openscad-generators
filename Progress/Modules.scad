$fn = 64;


module circular_plate_holes(
    plate_radius = 20,
    thickness = 5,
    hole_diameter = 5,
    hole_distance = 15,
    n_holes = 8){

    difference(){
        
        cylinder(h=thickness,r = plate_radius,center = true);
        
        angle = 360/n_holes;
        
        for(i = [0:angle:360-angle]){

            rotate([0,0,i])
            translate([hole_distance,0,0])
            cylinder(h=thickness+2, d = hole_diameter, center = true);
        }
        
    }

}

//circular_plate_holes(plate_radius = 25);

module move_to(x, y,z = 0){
    translate([x,y,z])
        children();
}

move_to(10,10){
    circular_plate_holes();
}