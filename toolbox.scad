// Global resolution quality for cylinders and corners
$fn = 64;

// Module to generate a 3D rectangular plate with rounded corners
module tb_rounded_plate(x = 50, y = 50, z = 5, r_corner = 5) {
    // Safety checks to ensure corner radius fits the plate dimensions
    assert(r_corner < x/2, "Error: Corner radius too big for X");
    assert(r_corner < y/2, "Error: Corner radius too big for Y");

    // Extrude the 2D rounded shape into a 3D plate
    linear_extrude(height = z, center = true) {
        offset(r = r_corner)
        square([x - 2 * r_corner, y - 2 * r_corner], center = true);
    }
}

// Module to generate a single slotted oblong hole
module tb_slot_hole(d = 5, h = 10, slot_length = 2) {
    // Merge two cylinders to create the elongated slot shape
    hull() {
        translate([-slot_length/2, 0, 0])
            cylinder(h = h, d = d, center = true);
        
        translate([slot_length/2, 0, 0])
            cylinder(h = h, d = d, center = true);
    }
}

// Layout pattern to duplicate child shapes across 4 symmetric corners
module tb_pattern_4_corners(x_dist = 40, y_dist = 40) {
    for (i = [x_dist/2, -x_dist/2]) {
        for (j = [y_dist/2, -y_dist/2]) {
            translate([i, j, 0])
                children();
        }
    }
}

// Layout pattern to arrange child shapes symmetrically in a circle
module tb_pattern_circular(count = 4, diameter = 40) {
    if (count > 0) {
        for (i = [0 : count - 1]) {
            rotate([0, 0, i * (360 / count)])
                translate([diameter / 2, 0, 0])
                    children();
        }
    }
}

// Module to generate a hollowed box for electronics components
module tb_hollow_enclosure(x = 60, y = 60, z = 30, wall = 2, r_corner = 4) {
    difference() {
        // Outer solid main body
        tb_rounded_plate(x, y, z, r_corner);
        
        // Inner hollow cavity shifted up to keep the bottom wall
        translate([0, 0, wall])
            tb_rounded_plate(x - 2*wall, y - 2*wall, z, max(0.1, r_corner - wall));
    }
}