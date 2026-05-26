module slot(length = 20, diameter = 5, height = 10) {
    hull() {
        translate([-length / 2 + diameter / 2, 0, 0])
            cylinder(h = height, d = diameter, center = true, $fn = 32);

        translate([length / 2 - diameter / 2, 0, 0])
            cylinder(h = height, d = diameter, center = true, $fn = 32);
    }
}

difference() {
    cube([60, 30, 5], center = true);

    slot(length = 30, diameter = 6, height = 7);
}