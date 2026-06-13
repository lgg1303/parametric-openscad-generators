
/*
    Parametric electronics enclosure

    Creates a ventilated electronics enclosure with a removable lid,
    screw bosses, PCB standoffs and a cable opening.

    Author: Lourenço Guerreiro
    Units: millimetres
*/

use <../toolbox.scad>

$fn = 64;

box_width = 90;
box_length = 60;
box_height = 25;

wall_thickness = 2.5;
floor_thickness = 2.5;
corner_radius = 6;

lid_thickness = 3;
lid_lip_height = 5;
lid_lip_wall = 2;
fit_clearance = 0.35;

screw_clearance_diameter = 3.4;
screw_pilot_diameter = 2.5;

boss_diameter = 8;
boss_height = 18;
boss_margin_x = 10;
boss_margin_y = 10;

pcb_standoff_diameter = 7;
pcb_standoff_height = 6;
pcb_hole_diameter = 2.7;
pcb_hole_spacing_x = 55;
pcb_hole_spacing_y = 35;

vent_diameter = 3;
vent_slot_length = 18;
vent_rows = 3;
vent_columns = 5;
vent_spacing_x = 14;
vent_spacing_y = 8;

cable_cutout_width = 18;
cable_cutout_height = 8;
cable_cutout_z = 8;

display_spacing = 25;
epsilon = 0.02;


module screw_boss(
    diameter,
    height,
    hole_diameter
) {
    difference() {
        cylinder(
            h = height,
            d = diameter
        );

        translate([0, 0, -epsilon])
            cylinder(
                h = height + 2 * epsilon,
                d = hole_diameter
            );
    }
}


module pcb_standoff(
    diameter,
    height,
    hole_diameter
) {
    difference() {
        cylinder(
            h = height,
            d = diameter
        );

        translate([0, 0, -epsilon])
            cylinder(
                h = height + 2 * epsilon,
                d = hole_diameter
            );
    }
}


module screw_bosses(
    width,
    length,
    wall,
    floor,
    diameter,
    height,
    margin_x,
    margin_y,
    pilot_diameter
) {
    boss_pattern_width =
        width - 2 * wall - 2 * margin_x;

    boss_pattern_length =
        length - 2 * wall - 2 * margin_y;

    translate([0, 0, floor])
        tb_pattern_4_corners(
            x_distance = boss_pattern_width,
            y_distance = boss_pattern_length
        )
            screw_boss(
                diameter = diameter,
                height = height,
                hole_diameter = pilot_diameter
            );
}


module pcb_standoffs(
    floor,
    spacing_x,
    spacing_y,
    diameter,
    height,
    hole_diameter
) {
    translate([0, 0, floor])
        tb_pattern_4_corners(
            x_distance = spacing_x,
            y_distance = spacing_y
        )
            pcb_standoff(
                diameter = diameter,
                height = height,
                hole_diameter = hole_diameter
            );
}


module cable_cutout(
    box_length,
    wall,
    width,
    height,
    z_position
) {
    translate([
        0,
        -box_length / 2,
        z_position
    ])
        cube(
            [
                width,
                wall + 2 * epsilon,
                height
            ],
            center = true
        );
}


module enclosure_base(
    width,
    length,
    height,
    wall,
    floor,
    radius
) {
    assert(
        width > 2 * wall,
        "Wall thickness is too large for the box width."
    );

    assert(
        length > 2 * wall,
        "Wall thickness is too large for the box length."
    );

    assert(
        height > floor,
        "Box height must be greater than the floor thickness."
    );

    assert(
        boss_height < height - floor,
        "Screw bosses are too tall for the enclosure."
    );

    assert(
        pcb_standoff_height < height - floor,
        "PCB standoffs are too tall for the enclosure."
    );

    difference() {
        union() {
            tb_hollow_enclosure(
                width = width,
                length = length,
                height = height,
                wall = wall,
                floor = floor,
                radius = radius,
                epsilon = epsilon
            );

            screw_bosses(
                width = width,
                length = length,
                wall = wall,
                floor = floor,
                diameter = boss_diameter,
                height = boss_height,
                margin_x = boss_margin_x,
                margin_y = boss_margin_y,
                pilot_diameter = screw_pilot_diameter
            );

            pcb_standoffs(
                floor = floor,
                spacing_x = pcb_hole_spacing_x,
                spacing_y = pcb_hole_spacing_y,
                diameter = pcb_standoff_diameter,
                height = pcb_standoff_height,
                hole_diameter = pcb_hole_diameter
            );
        }

        cable_cutout(
            box_length = length,
            wall = wall,
            width = cable_cutout_width,
            height = cable_cutout_height,
            z_position = cable_cutout_z
        );
    }
}


module ventilation_pattern(
    diameter,
    slot_length,
    rows,
    columns,
    spacing_x,
    spacing_y,
    height
) {
    assert(rows >= 1, "Vent rows must be at least one.");
    assert(columns >= 1, "Vent columns must be at least one.");

    for (column = [0 : columns - 1]) {
        for (row = [0 : rows - 1]) {
            x_position =
                (column - (columns - 1) / 2)
                * spacing_x;

            y_position =
                (row - (rows - 1) / 2)
                * spacing_y;

            translate([
                x_position,
                y_position,
                0
            ])
                tb_slot_hole(
                    diameter = diameter,
                    height = height,
                    slot_length = slot_length
                );
        }
    }
}


module lid_screw_holes(
    width,
    length,
    wall,
    margin_x,
    margin_y,
    hole_diameter,
    height
) {
    hole_pattern_width =
        width - 2 * wall - 2 * margin_x;

    hole_pattern_length =
        length - 2 * wall - 2 * margin_y;

    tb_pattern_4_corners(
        x_distance = hole_pattern_width,
        y_distance = hole_pattern_length
    )
        cylinder(
            h = height,
            d = hole_diameter,
            center = true
        );
}


module enclosure_lid(
    width,
    length,
    wall,
    radius,
    thickness,
    lip_height,
    lip_wall,
    clearance
) {
    lip_width =
        width - 2 * wall - 2 * clearance;

    lip_length =
        length - 2 * wall - 2 * clearance;

    lip_radius =
        max(radius - wall - clearance, 0);

    assert(
        lip_width > 2 * lip_wall,
        "Lid lip wall is too large for the available width."
    );

    assert(
        lip_length > 2 * lip_wall,
        "Lid lip wall is too large for the available length."
    );

    difference() {
        union() {
            tb_rounded_solid(
                width = width,
                length = length,
                height = thickness,
                radius = radius,
                center = false
            );

            translate([0, 0, -lip_height])
                tb_rounded_ring(
                    width = lip_width,
                    length = lip_length,
                    height = lip_height,
                    radius = lip_radius,
                    wall = lip_wall,
                    center = false,
                    epsilon = epsilon
                );
        }

        translate([
            0,
            0,
            thickness / 2
        ])
            ventilation_pattern(
                diameter = vent_diameter,
                slot_length = vent_slot_length,
                rows = vent_rows,
                columns = vent_columns,
                spacing_x = vent_spacing_x,
                spacing_y = vent_spacing_y,
                height = thickness + 2 * epsilon
            );

        lid_screw_holes(
            width = width,
            length = length,
            wall = wall,
            margin_x = boss_margin_x,
            margin_y = boss_margin_y,
            hole_diameter = screw_clearance_diameter,
            height = thickness + lip_height + 2
        );
    }
}


enclosure_base(
    width = box_width,
    length = box_length,
    height = box_height,
    wall = wall_thickness,
    floor = floor_thickness,
    radius = corner_radius
);

translate([
    box_width + display_spacing,
    0,
    0
])
    enclosure_lid(
        width = box_width,
        length = box_length,
        wall = wall_thickness,
        radius = corner_radius,
        thickness = lid_thickness,
        lip_height = lid_lip_height,
        lip_wall = lid_lip_wall,
        clearance = fit_clearance
    );

