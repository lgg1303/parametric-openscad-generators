
/*
    Parametric flange generator

    Creates a circular flange with a centre hole, a configurable
    bolt pattern and optional chamfers.

    Author: Lourenço Guerreiro
    Units: millimetres
*/

use <../toolbox.scad>

$fn = 96;

outer_diameter = 80;
thickness = 8;

center_hole_diameter = 22;

bolt_count = 6;
bolt_circle_diameter = 58;
bolt_hole_diameter = 5.5;
bolt_pattern_angle = 0;

outer_chamfer = 1;
hole_chamfer = 0.6;

epsilon = 0.02;


module flange_body(
    diameter,
    height,
    chamfer
) {
    if (chamfer > 0) {
        union() {
            cylinder(
                h = height - 2 * chamfer + 2 * epsilon,
                d = diameter,
                center = true
            );

            translate([
                0,
                0,
                height / 2 - chamfer / 2
            ])
                cylinder(
                    h = chamfer + epsilon,
                    d1 = diameter,
                    d2 = diameter - 2 * chamfer,
                    center = true
                );

            translate([
                0,
                0,
                -height / 2 + chamfer / 2
            ])
                cylinder(
                    h = chamfer + epsilon,
                    d1 = diameter - 2 * chamfer,
                    d2 = diameter,
                    center = true
                );
        }
    } else {
        cylinder(
            h = height,
            d = diameter,
            center = true
        );
    }
}


module hole_chamfers(
    diameter,
    chamfer,
    part_thickness
) {
    translate([
        0,
        0,
        part_thickness / 2 - chamfer / 2 + epsilon / 2
    ])
        cylinder(
            h = chamfer + epsilon,
            d1 = diameter,
            d2 = diameter + 2 * chamfer,
            center = true
        );

    translate([
        0,
        0,
        -part_thickness / 2 + chamfer / 2 - epsilon / 2
    ])
        cylinder(
            h = chamfer + epsilon,
            d1 = diameter + 2 * chamfer,
            d2 = diameter,
            center = true
        );
}


module finished_hole(
    diameter,
    height,
    chamfer,
    part_thickness
) {
    union() {
        cylinder(
            h = height,
            d = diameter,
            center = true
        );

        if (chamfer > 0) {
            hole_chamfers(
                diameter = diameter,
                chamfer = chamfer,
                part_thickness = part_thickness
            );
        }
    }
}


module flange(
    outer_diameter,
    thickness,
    center_hole_diameter,
    bolt_count,
    bolt_circle_diameter,
    bolt_hole_diameter,
    bolt_pattern_angle,
    outer_chamfer,
    hole_chamfer
) {
    assert(
        outer_diameter > 0,
        "Outer diameter must be greater than zero."
    );

    assert(
        thickness > 0,
        "Flange thickness must be greater than zero."
    );

    assert(
        center_hole_diameter > 0 &&
        center_hole_diameter < outer_diameter,
        "Centre hole diameter is invalid."
    );

    assert(
        bolt_count >= 3,
        "The flange must have at least three bolt holes."
    );

    assert(
        bolt_circle_diameter > 0,
        "Bolt circle diameter must be greater than zero."
    );

    assert(
        bolt_hole_diameter > 0,
        "Bolt hole diameter must be greater than zero."
    );

    assert(
        bolt_circle_diameter / 2 + bolt_hole_diameter / 2
        < outer_diameter / 2,
        "The bolt holes extend outside the flange."
    );

    assert(
        center_hole_diameter / 2
        < bolt_circle_diameter / 2 - bolt_hole_diameter / 2,
        "The bolt holes intersect the centre hole."
    );

    assert(
        outer_chamfer >= 0 &&
        2 * outer_chamfer < thickness,
        "Outer chamfer is too large."
    );

    assert(
        hole_chamfer >= 0 &&
        2 * hole_chamfer < thickness,
        "Hole chamfer is too large."
    );

    difference() {
        flange_body(
            diameter = outer_diameter,
            height = thickness,
            chamfer = outer_chamfer
        );

        finished_hole(
            diameter = center_hole_diameter,
            height = thickness + 2,
            chamfer = hole_chamfer,
            part_thickness = thickness
        );

        tb_pattern_circular(
            count = bolt_count,
            diameter = bolt_circle_diameter,
            start_angle = bolt_pattern_angle
        )
            finished_hole(
                diameter = bolt_hole_diameter,
                height = thickness + 2,
                chamfer = hole_chamfer,
                part_thickness = thickness
            );
    }
}


flange(
    outer_diameter = outer_diameter,
    thickness = thickness,
    center_hole_diameter = center_hole_diameter,
    bolt_count = bolt_count,
    bolt_circle_diameter = bolt_circle_diameter,
    bolt_hole_diameter = bolt_hole_diameter,
    bolt_pattern_angle = bolt_pattern_angle,
    outer_chamfer = outer_chamfer,
    hole_chamfer = hole_chamfer
);

