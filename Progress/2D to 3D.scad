$fn = 64;

/*linear_extrude(height = 20, center = true)
square([20,20], center = true);*/


/*module rounded_square(length, width, radius){
    offset(r = radius)
        square([length-2*radius,width-2*radius], center = true);
    // take 2*radius out because the offset works by adding a periferical skin with the radius in each side
}

linear_extrude(height = 5,center = true)
    rounded_square(20,20,5);*/


module chamfer_square(length, width, chamfer){
    offset(delta = chamfer, chamfer = true)
        square([length-2*chamfer,width-2*chamfer], center = true);
    // take 2*chamfer out because the offset works by adding a periferical skin with the chamfer in each side
}

linear_extrude(height = 5,center = true)
    chamfer_square(20,20,5);