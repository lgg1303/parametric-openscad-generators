//fucntions does not create geometry, creates values

// lets crate again the cylinder with holes but using fuction


// Global quality
$fn = 64;

//functions
function position_x (radius, angle) = radius * cos(angle);
function position_y (radius, angle) = radius * sin(angle);

//modules
module circular_plate_holes(
    plate_radius = 20,
    thickness = 5,
    hole_diameter = 5,
    hole_distance_border = 3,
    n_holes = 8){
        
    assert(hole_distance_border > hole_diameter/2, "The hole is outside the plate");  //the condition we want, "The message in case the condition is not respected"

    difference(){
        
        cylinder(h=thickness,r = plate_radius,center = true);
        
        angle = 360/n_holes;
        
        for(i = [0:angle:360-angle]){

            translate([position_x(plate_radius-hole_distance_border,i),position_y(plate_radius-hole_distance_border,i),0])
            cylinder(h=thickness+2, d = hole_diameter, center = true);
        }
        
    }

}

//build
circular_plate_holes();