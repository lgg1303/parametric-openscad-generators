// Global resolution quality for cylinders and round corners
$fn = 64;

// Module to generate the main base plate with rounded corners
module plate(x = 50, y = 50, z = 5, r_corner = 5){
    
    // Safety checks: ensure the corner radius doesn't exceed plate dimensions
    assert(r_corner < x/2 , "Too much radius corner");
    assert(r_corner < y/2 , "Too much radius corner");

    // Extrude the 2D shape into a 3D plate
    linear_extrude(height = z, center = true){
        
        // Create rounded corners by applying an offset to a square
        offset(r = r_corner)
        square([x-2*r_corner,y-2*r_corner], center = true);
        
        }
    }
    
//plate(); // Debug preview

// Module to generate a single slotted hole (oblong hole)
module hole_slot(d = 5, h = 7, slot_length = 2){
    
    // Create an elongated slot by merging two cylinders together
    hull(){
        translate([-slot_length/2,0,0])
        cylinder(h = h,d = d,center = true);
        
        translate([slot_length/2,0,0])
        cylinder(h = h, d = d,center = true);
        }
    
    }
    
//hole_slot(d = 10,slot_length = 10); // Debug preview
    
    
// Main assembly module that combines the plate and the holes
module assembly(
    x = 50, 
    y = 50, 
    z = 5, 
    r_corner = 2,
    d = 5,  
    slot_length = 5,
    dist_border_x = 10,
    dist_border_y = 5){
        
    // Safety checks: ensure holes fit properly within the plate boundaries
    assert(dist_border_x > d/2 + slot_length/2, "Hole outside the plate");
    assert(dist_border_y > d/2, "Hole outside the plate");
    assert(slot_length < 20, "slot too big");
    assert(x/2 - dist_border_x > d/2 + slot_length/2, "holes too close");
    
        
    // Subtract the holes from the solid base plate
    difference(){
        
        // Solid base plate
        plate(x,y,z,r_corner);
        
        // Nested loops to automatically place holes at all 4 corners
        for(i = [x/2 - dist_border_x, -x/2 + dist_border_x]){ // X coordinates
            for(j = [y/2 - dist_border_y, -y/2 + dist_border_y]){ // Y coordinates
                
                // Position and cut out each slotted hole (h = z+2 prevents rendering artifacts)
                translate([i,j,0])
                    hole_slot(d = d, h = z+2, slot_length = slot_length);
                
                }
            }
        }
    }
    
// Final Model Render
assembly(r_corner = 10, dist_border_x = 10, slot_length = 0); // (slot_length = 0 creates standard round holes)