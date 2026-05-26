
$fn = 64;

// instead of 
// bolt_diameter = 5;
// hole_diameter = 5; we do

bolt_diameter = 5;
clearance = 0.4;

hole_diameter = bolt_diameter + clearance;

thickness = 5;

difference(){
    cylinder(h = thickness, d = hole_diameter +5, center = true);
    
    cylinder(h = thickness + 2, d = hole_diameter, center = true);   
}

