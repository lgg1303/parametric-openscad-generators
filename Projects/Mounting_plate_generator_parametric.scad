/*
    Parametric mounting plate generator

    Creates a rectangular mounting plate with rounded corners and
    four configurable mounting holes.

    Author: Lourenço Guerreiro
    Units: millimetres
*/

$fn = 64;

plate_width = 80;
plate_length = 55;
plate_thickness = 5;
corner_radius = 6;

hole_diameter = 5;
slot_length = 10;
slot_angle = 0;

hole_offset_x = 10;
hole_offset_y = 10;

epsilon = 0.02;


/*
    Creates the main plate body.

    The corner radius is produced by applying an offset to a smaller
    rectangle before extruding it.
*/
module rounded_plate(width, length, thickness, radius) {

    assert(width > 0, "Plate width must be greater than zero.");
    assert(length > 0, "Plate length must be greater than zero.");
    assert(thickness > 0, "Plate thickness must be greater than zero.");
    assert(radius >= 0, "Corner radius cannot be negative.");
    assert(
        radius <= min(width, length) / 2,
        "Corner radius is too large for the plate dimensions."
    );

    linear_extrude(height = thickness, center = true)
        if (radius > 0) {
            offset(r = radius)
                square(
                    [
                        width - 2 * radius,
                        length - 2 * radius
                    ],
                    center = true
                );
        }
        else {
            square([width, length], center = true);
        }
}


/*
    Creates either a round hole or a slotted hole.

    slot_length represents the total external length of the slot.
    When slot_length equals hole_diameter, the result is a round hole.
*/
module mounting_hole(
    diameter,
    total_length,
    height,
    angle = 0
) {

    assert(diameter > 0, "Hole diameter must be greater than zero.");
    assert(
        total_length >= diameter,
        "Slot length must be equal to or greater than the hole diameter."
    );

    centre_distance = total_length - diameter;

    rotate([0, 0, angle])
        hull() {
            translate([-centre_distance / 2, 0, 0])
                cylinder(
                    d = diameter,
                    h = height,
                    center = true
                );

            translate([centre_distance / 2, 0, 0])
                cylinder(
                    d = diameter,
                    h = height,
                    center = true
                );
        }
}


/*
    Places one mounting hole near each corner of the plate.
*/
module four_hole_pattern(
    plate_width,
    plate_length,
    offset_x,
    offset_y
) {

    x_positions = [
        -plate_width / 2 + offset_x,
         plate_width / 2 - offset_x
    ];

    y_positions = [
        -plate_length / 2 + offset_y,
         plate_length / 2 - offset_y
    ];

    for (x = x_positions)
        for (y = y_positions)
            translate([x, y, 0])
                mounting_hole(
                    diameter = hole_diameter,
                    total_length = slot_length,
                    height = plate_thickness + 2 * epsilon,
                    angle = slot_angle
                );
}


module mounting_plate() {

    hole_radius = hole_diameter / 2;

    assert(
        hole_offset_x >= slot_length / 2,
        "The mounting holes are too close to the left or right edge."
    );

    assert(
        hole_offset_y >= hole_radius,
        "The mounting holes are too close to the top or bottom edge."
    );

    assert(
        hole_offset_x < plate_width / 2,
        "Horizontal hole offset must be smaller than half the plate width."
    );

    assert(
        hole_offset_y < plate_length / 2,
        "Vertical hole offset must be smaller than half the plate length."
    );

    difference() {

        rounded_plate(
            width = plate_width,
            length = plate_length,
            thickness = plate_thickness,
            radius = corner_radius
        );

        four_hole_pattern(
            plate_width = plate_width,
            plate_length = plate_length,
            offset_x = hole_offset_x,
            offset_y = hole_offset_y
        );
    }
}


mounting_plate();
