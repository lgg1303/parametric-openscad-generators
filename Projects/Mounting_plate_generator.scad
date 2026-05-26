//Quality
$fn = 64;

module plate(x = 50, y = 50, z = 5, r_corner = 5){
    
    assert(r_corner < x/2 , "Too much radius corner");
    assert(r_corner < y/2 , "Too much radius corner");

    linear_extrude(height = z, center = true){
        
        offset(r = r_corner)
        square([x-2*r_corner,y-2*r_corner], center = true);
        
        }
    }
    
//plate();

module hole_slot(d = 5, h = 7, slot_length = 2){
    
    hull(){
        translate([-slot_length/2,0,0])
        cylinder(h = h,d = d,center = true);
        
        translate([slot_length/2,0,0])
        cylinder(h = h, d = d,center = true);
        }
    
    }
    
//hole_slot(d = 10,slot_length = 10);
    
    
module assembly(
    x = 50, 
    y = 50, 
    z = 5, 
    r_corner = 2,
    d = 5,  
    slot_length = 5,
    dist_border_x = 10,
    dist_border_y = 5){
        
    assert(dist_border_x > d/2 + slot_length/2, "Hole outside the plate");
    assert(dist_border_y > d/2, "Hole outside the plate");
    assert(slot_length < 20, "slot too big");
    assert(x/2 - dist_border_x > d/2 + slot_length/2, "holes too close");
    
        
    difference(){
        
        plate(x,y,z,r_corner);
        
        for(i = [x/2 - dist_border_x, -x/2 + dist_border_x]){
            for(j = [y/2 - dist_border_y, -y/2 + dist_border_y]){
                
                translate([i,j,0])
                    hole_slot(d = d, h = z+2, slot_length = slot_length);

                
                }
            }
        }
    }
    
//build
    
assembly(r_corner = 10,dist_border_x = 10,slot_length = 0);  //slot_length = 0) for no slot