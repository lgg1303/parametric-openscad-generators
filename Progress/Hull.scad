$fn = 64;

/*hull(){
    translate([-20,0,0])
        cylinder(h = 20, r = 10, center = true);
    
    translate([20,0,0])
        //cylinder(h = 20, r = 10, center = true);
        cube([40,30,20]);

    
}*/
//creates a complex conection between the components

module create_arm(
    length = 40, 
    width = 10,
    hight = 10,
    hole_size = 5,
    hole_distance = 5){

   difference(){
        linear_extrude(hight,center = true){
            hull(){
                translate([length/2 - width/2,0,0])
                    circle( d = width);
                translate([-length/2 + width/2,0,0])
                    circle(d = width);
            }
        }
        translate([hole_distance,0,0])
            cylinder(h = hight+2, d = hole_size, center = true);
        translate([-hole_distance,0,0])
            cylinder(h = hight+2, d = hole_size, center = true);
          
    }
    
}

minkowski(){
    create_arm(hole_distance = 15);
    sphere(4);
}