$fn = 64;

module base(x = 80,y = 50,z = 5){
    
    cube([x,y,z], center = true);
    
    }
    
//base(z = 10);    
    
module legs(d = 5, h = 20){
    
    cylinder(h = h,  d = d, center = true);
    
    }
    
//legs();
    
    
module assembly(x = 80,y = 50,z = 5, d = 5, h = 20){
    
    base(x,y,z);
    
    for(i = [x/2 -10,-x/2 + 10]){
        for(j = [y/2 -10,-y/2+10]){
            
            translate([i,j,-z/2 - h/2])
                legs(d,h);
            
            }
        
        }
    
    }
    
 assembly();