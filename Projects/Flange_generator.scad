//Quility
$fn = 96;

// -------------------------
// Main parameters
// -------------------------

outer_diameter = 80;
thickness = 8;

center_hole_diameter = 22;

bolt_count = 6;
bolt_circle_diameter = 58;
bolt_hole_diameter = 5.5;

// Chamfers
outer_chamfer = 1.0;
hole_chamfer = 0.6;

// -------------------------
// Build
// -------------------------

flange(
    outer_diameter = outer_diameter,
    thickness = thickness,
    center_hole_diameter = center_hole_diameter,
    bolt_count = bolt_count,
    bolt_circle_diameter = bolt_circle_diameter,
    bolt_hole_diameter = bolt_hole_diameter,
    outer_chamfer = outer_chamfer,
    hole_chamfer = hole_chamfer
);

//Modules

module flange(
    outer_diameter = 80,
    thickness = 8,
    center_hole_diameter = 22,
    bolt_count = 6,
    bolt_circle_diameter = 58,
    bolt_hole_diameter = 5.5,
    outer_chamfer = 1,
    hole_chamfer = 0.5
) {

    assert(outer_diameter > 0, "outer_diameter must be positive");
    assert(thickness > 0, "thickness must be positive");
    assert(center_hole_diameter > 0, "center_hole_diameter must be positive");
    assert(bolt_count >= 3, "bolt_count must be at least 3");
    assert(bolt_circle_diameter > 0, "bolt_circle_diameter must be positive");
    assert(bolt_hole_diameter > 0, "bolt_hole_diameter must be positive");
    assert(outer_chamfer >= 0, "outer_chamfer cannot be negative");
    assert(hole_chamfer >= 0, "hole_chamfer cannot be negative");
    
    assert(
        center_hole_diameter < outer_diameter,
        "center hole is larger than the flange"
    );
    
    assert(
        bolt_circle_diameter / 2 + bolt_hole_diameter / 2 < outer_diameter / 2,
        "bolt holes are outside the flange"
    );
    
    assert(
        center_hole_diameter / 2 < bolt_circle_diameter / 2 - bolt_hole_diameter / 2,
        "bolt holes intersect the center hole"
    );
    
    assert(
        2 * outer_chamfer < thickness,
        "outer_chamfer is too large for the flange thickness"
    );
    
    assert(
        2 * hole_chamfer < thickness,
        "hole_chamfer is too large for the flange thickness"
    );
    
    difference() {
        
        flange_body(
            d = outer_diameter,
            h = thickness,
            chamfer = outer_chamfer
        );
        
        center_hole(
            d = center_hole_diameter,
            h = thickness + 2,
            chamfer = hole_chamfer,
            part_thickness = thickness
        );
        
        bolt_circle_holes(
            bolt_count = bolt_count,
            bolt_circle_diameter = bolt_circle_diameter,
            bolt_hole_diameter = bolt_hole_diameter,
            h = thickness + 2,
            hole_chamfer = hole_chamfer,
            part_thickness = thickness
        );
    }
}

// Flange body with outside chamfer

module flange_body(d = 80, h = 8, chamfer = 1) {
    
    if (chamfer > 0) {
        union() {
            
            // Main straight section
            cylinder(
                h = h - 2 * chamfer,
                d = d,
                center = true
            );
            
            // Top chamfer
            translate([0, 0, h / 2 - chamfer / 2])
                cylinder(
                    h = chamfer,
                    d1 = d,
                    d2 = d - 2 * chamfer,
                    center = true
                );
            
            // Bottom chamfer
            translate([0, 0, -h / 2 + chamfer / 2])
                cylinder(
                    h = chamfer,
                    d1 = d - 2 * chamfer,
                    d2 = d,
                    center = true
                );
        }
    } else {
        cylinder(
            h = h,
            d = d,
            center = true
        );
    }
}


// Center hole with optional chamfer


module center_hole(d = 20, h = 10, chamfer = 0.5, part_thickness = 8) {
    
    union() {
        
        // Main through hole
        cylinder(
            h = h,
            d = d,
            center = true
        );
        
        if (chamfer > 0) {
            hole_chamfers(
                d = d,
                chamfer = chamfer,
                part_thickness = part_thickness
            );
        }
    }
}

// Bolt circle holes


module bolt_circle_holes(
    bolt_count = 6,
    bolt_circle_diameter = 58,
    bolt_hole_diameter = 5.5,
    h = 10,
    hole_chamfer = 0.5,
    part_thickness = 8
) {
    
    for (i = [0 : bolt_count - 1]) {
        
        angle = i * 360 / bolt_count;
        
        rotate([0, 0, angle])
            translate([bolt_circle_diameter / 2, 0, 0])
                union() {
                    
                    cylinder(
                        h = h,
                        d = bolt_hole_diameter,
                        center = true
                    );
                    
                    if (hole_chamfer > 0) {
                        hole_chamfers(
                            d = bolt_hole_diameter,
                            chamfer = hole_chamfer,
                            part_thickness = part_thickness
                        );
                    }
                }
    }
}

// Chamfer cutter for holes


module hole_chamfers(d = 5, chamfer = 0.5, part_thickness = 8) {
    
    // Top chamfer cutter
    translate([0, 0, part_thickness / 2 - chamfer / 2])
        cylinder(
            h = chamfer,
            d1 = d,
            d2 = d + 2 * chamfer,
            center = true
        );
    
    // Bottom chamfer cutter
    translate([0, 0, -part_thickness / 2 + chamfer / 2])
        cylinder(
            h = chamfer,
            d1 = d + 2 * chamfer,
            d2 = d,
            center = true
        );
}