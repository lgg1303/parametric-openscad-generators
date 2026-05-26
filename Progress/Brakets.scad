thickness = 4;
leg_a = 50;
leg_b = 40;
width = 30;

hole_diameter = 5;
hole_offset = 20;

module l_bracket() {
    difference() {
        union() {
            // Base horizontal
            translate([0, 0, 0])
                cube([leg_a, width, thickness], center = true);

            // Parede vertical
            translate([-leg_a / 2 + thickness / 2, 0, leg_b / 2])
                cube([thickness, width, leg_b], center = true);
        }

        // Furo na base
        translate([hole_offset / 2, 0, 0])
            cylinder(h = thickness + 2, d = hole_diameter, center = true, $fn = 40);

        // Furo na parede vertical
        translate([-leg_a / 2 + thickness / 2, 0, leg_b / 2])
            rotate([90, 0, 0])
                cylinder(h = width + 2, d = hole_diameter, center = true, $fn = 40);
    }
}

l_bracket();