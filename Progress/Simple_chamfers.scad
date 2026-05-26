$fn = 64;

module chamfered_cylinder(
    d = 30,
    h = 10,
    chamfer = 1){
        
    hull(){
        translate([0,0,h/2-chamfer/2])
            cylinder(h=chamfer, d1=d, d2=d-2*chamfer, center = true);
        translate([0,0,-h/2+chamfer/2])
            cylinder(h=chamfer, d1=d-2*chamfer, d2=d, center= true);
    }
}

chamfered_cylinder();