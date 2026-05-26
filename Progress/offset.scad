$fn = 64;

/*module offset_square(length, width, off){
    offset(delta = off)
        square([length, width], center = true);
    
}

linear_extrude(5, center = true)
    offset_square(20,20,10);*/

module chamfer_square(length, width, chamfer){
    offset(delta = chamfer, chamfer = true)
        square([length-2*chamfer,width-2*chamfer], center = true);
    // take 2*chamfer out because the offset works by adding a periferical skin with the chamfer in each side
}

linear_extrude(height = 5,center = true)
    chamfer_square(20,20,5);