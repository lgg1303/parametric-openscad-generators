$fn = 64;

// parameters


box_x = 90;
box_y = 60;
box_z = 25;

wall = 2.5;
floor_thickness = 2.5;

r_corner = 6;

lid_thickness = 3;
lid_lip_h = 5;
lid_lip_wall = 2;
fit_clearance = 0.35;

screw_d = 3;
screw_clearance_d = 3.4;
screw_pilot_d = 2.5;

boss_d = 8;
boss_h = 18;
boss_margin_x = 10;
boss_margin_y = 10;

pcb_standoff_d = 7;
pcb_standoff_h = 6;
pcb_hole_d = 2.7;

pcb_hole_spacing_x = 55;
pcb_hole_spacing_y = 35;

vent_d = 3;
vent_slot_length = 18;
vent_rows = 3;
vent_cols = 5;
vent_spacing_x = 14;
vent_spacing_y = 8;

cable_cutout_x = 18;
cable_cutout_z = 8;
cable_cutout_h = 8;

// build

base();

translate([box_x + 25, 0, 0])
    lid();


// basic shapes


module rounded_rect_2d(x = 50, y = 50, r = 5) {
    
    assert(x > 0, "x must be positive");
    assert(y > 0, "y must be positive");
    assert(r >= 0, "r cannot be negative");
    assert(r < x / 2, "corner radius too large in x");
    assert(r < y / 2, "corner radius too large in y");
    
    offset(r = r)
        square([x - 2 * r, y - 2 * r], center = true);
}


module rounded_solid(x = 50, y = 50, z = 5, r = 5) {
    
    linear_extrude(height = z, center = false)
        rounded_rect_2d(x = x, y = y, r = r);
}


module rounded_ring(x = 50, y = 50, z = 5, r = 5, wall = 2) {
    
    assert(wall > 0, "wall must be positive");
    assert(x - 2 * wall > 0, "wall too large in x");
    assert(y - 2 * wall > 0, "wall too large in y");
    
    difference() {
        
        rounded_solid(
            x = x,
            y = y,
            z = z,
            r = r
        );
        
        translate([0, 0, -1])
            rounded_solid(
                x = x - 2 * wall,
                y = y - 2 * wall,
                z = z + 2,
                r = max(r - wall, 0.1)
            );
    }
}


module slot(d = 3, h = 10, slot_length = 15) {
    
    assert(slot_length >= d, "slot_length must be bigger than d");
    
    center_distance = slot_length - d;
    
    hull() {
        translate([-center_distance / 2, 0, 0])
            cylinder(h = h, d = d, center = true);
        
        translate([center_distance / 2, 0, 0])
            cylinder(h = h, d = d, center = true);
    }
}

// screw boss

module screw_boss(d = 8, h = 15, hole_d = 2.5) {
    
    difference() {
        
        cylinder(h = h, d = d, center = false);
        
        translate([0, 0, -1])
            cylinder(h = h + 2, d = hole_d, center = false);
    }
}


// pcb standoff

module pcb_standoff(d = 7, h = 6, hole_d = 2.7) {
    
    difference() {
        
        cylinder(h = h, d = d, center = false);
        
        translate([0, 0, -1])
            cylinder(h = h + 2, d = hole_d, center = false);
    }
}


// base shell

module base_shell(
    x = 90,
    y = 60,
    z = 25,
    wall = 2.5,
    floor_thickness = 2.5,
    r_corner = 6
) {
    
    assert(wall > 0, "wall must be positive");
    assert(floor_thickness > 0, "floor_thickness must be positive");
    assert(x - 2 * wall > 0, "wall too large in x");
    assert(y - 2 * wall > 0, "wall too large in y");
    assert(z > floor_thickness, "box_z must be larger than floor_thickness");
    
    difference() {
        
        rounded_solid(
            x = x,
            y = y,
            z = z,
            r = r_corner
        );
        
        translate([0, 0, floor_thickness])
            rounded_solid(
                x = x - 2 * wall,
                y = y - 2 * wall,
                z = z,
                r = max(r_corner - wall, 0.1)
            );
    }
}


// screw boss pattern

module screw_bosses(
    x = 90,
    y = 60,
    wall = 2.5,
    floor_thickness = 2.5,
    boss_d = 8,
    boss_h = 18,
    boss_margin_x = 10,
    boss_margin_y = 10,
    screw_pilot_d = 2.5
) {
    
    boss_x = x / 2 - wall - boss_margin_x;
    boss_y = y / 2 - wall - boss_margin_y;
    
    for (i = [-boss_x, boss_x]) {
        for (j = [-boss_y, boss_y]) {
            translate([i, j, floor_thickness])
                screw_boss(
                    d = boss_d,
                    h = boss_h,
                    hole_d = screw_pilot_d
                );
        }
    }
}


// pcb standoff pattern

module pcb_standoffs(
    floor_thickness = 2.5,
    spacing_x = 55,
    spacing_y = 35,
    d = 7,
    h = 6,
    hole_d = 2.7
) {
    
    for (i = [-spacing_x / 2, spacing_x / 2]) {
        for (j = [-spacing_y / 2, spacing_y / 2]) {
            translate([i, j, floor_thickness])
                pcb_standoff(
                    d = d,
                    h = h,
                    hole_d = hole_d
                );
        }
    }
}


// cable cutout

module cable_cutout(
    box_y = 60,
    wall = 2.5,
    cutout_x = 18,
    cutout_h = 8,
    cutout_z = 8
) {
    
    translate([0, -box_y / 2, cutout_z])
        cube([cutout_x, wall + 2, cutout_h], center = true);
}


// base

module base(
    x = box_x,
    y = box_y,
    z = box_z,
    wall = wall,
    floor_thickness = floor_thickness,
    r_corner = r_corner,
    boss_d = boss_d,
    boss_h = boss_h,
    boss_margin_x = boss_margin_x,
    boss_margin_y = boss_margin_y,
    screw_pilot_d = screw_pilot_d,
    pcb_standoff_d = pcb_standoff_d,
    pcb_standoff_h = pcb_standoff_h,
    pcb_hole_d = pcb_hole_d
) {
    
    assert(boss_h < z - floor_thickness, "boss_h too tall");
    assert(pcb_standoff_h < z - floor_thickness, "pcb_standoff_h too tall");
    
    difference() {
        
        union() {
            
            base_shell(
                x = x,
                y = y,
                z = z,
                wall = wall,
                floor_thickness = floor_thickness,
                r_corner = r_corner
            );
            
            screw_bosses(
                x = x,
                y = y,
                wall = wall,
                floor_thickness = floor_thickness,
                boss_d = boss_d,
                boss_h = boss_h,
                boss_margin_x = boss_margin_x,
                boss_margin_y = boss_margin_y,
                screw_pilot_d = screw_pilot_d
            );
            
            pcb_standoffs(
                floor_thickness = floor_thickness,
                spacing_x = pcb_hole_spacing_x,
                spacing_y = pcb_hole_spacing_y,
                d = pcb_standoff_d,
                h = pcb_standoff_h,
                hole_d = pcb_hole_d
            );
        }
        
        cable_cutout(
            box_y = y,
            wall = wall,
            cutout_x = cable_cutout_x,
            cutout_h = cable_cutout_h,
            cutout_z = cable_cutout_z
        );
    }
}


// lid vents

module lid_vents(
    d = 3,
    slot_length = 18,
    rows = 3,
    cols = 5,
    spacing_x = 14,
    spacing_y = 8,
    h = 10
) {
    
    for (i = [0 : cols - 1]) {
        for (j = [0 : rows - 1]) {
            
            pos_x = (i - (cols - 1) / 2) * spacing_x;
            pos_y = (j - (rows - 1) / 2) * spacing_y;
            
            translate([pos_x, pos_y, 0])
                slot(
                    d = d,
                    h = h,
                    slot_length = slot_length
                );
        }
    }
}


// lid screw holes

module lid_screw_holes(
    x = 90,
    y = 60,
    wall = 2.5,
    boss_margin_x = 10,
    boss_margin_y = 10,
    screw_clearance_d = 3.4,
    h = 20
) {
    
    hole_x = x / 2 - wall - boss_margin_x;
    hole_y = y / 2 - wall - boss_margin_y;
    
    for (i = [-hole_x, hole_x]) {
        for (j = [-hole_y, hole_y]) {
            translate([i, j, 0])
                cylinder(h = h, d = screw_clearance_d, center = true);
        }
    }
}


// lid

module lid(
    x = box_x,
    y = box_y,
    wall = wall,
    r_corner = r_corner,
    lid_thickness = lid_thickness,
    lid_lip_h = lid_lip_h,
    lid_lip_wall = lid_lip_wall,
    fit_clearance = fit_clearance,
    screw_clearance_d = screw_clearance_d
) {
    
    lip_x = x - 2 * wall - 2 * fit_clearance;
    lip_y = y - 2 * wall - 2 * fit_clearance;
    lip_r = max(r_corner - wall - fit_clearance, 0.1);
    
    assert(lip_x > 0, "lip_x too small");
    assert(lip_y > 0, "lip_y too small");
    assert(lid_lip_wall > 0, "lid_lip_wall must be positive");
    assert(lip_x - 2 * lid_lip_wall > 0, "lid_lip_wall too large in x");
    assert(lip_y - 2 * lid_lip_wall > 0, "lid_lip_wall too large in y");
    
    difference() {
        
        union() {
            
            rounded_solid(
                x = x,
                y = y,
                z = lid_thickness,
                r = r_corner
            );
            
            translate([0, 0, -lid_lip_h])
                rounded_ring(
                    x = lip_x,
                    y = lip_y,
                    z = lid_lip_h,
                    r = lip_r,
                    wall = lid_lip_wall
                );
        }
        
        translate([0, 0, lid_thickness / 2])
            lid_vents(
                d = vent_d,
                slot_length = vent_slot_length,
                rows = vent_rows,
                cols = vent_cols,
                spacing_x = vent_spacing_x,
                spacing_y = vent_spacing_y,
                h = lid_thickness + 2
            );
        
        lid_screw_holes(
            x = x,
            y = y,
            wall = wall,
            boss_margin_x = boss_margin_x,
            boss_margin_y = boss_margin_y,
            screw_clearance_d = screw_clearance_d,
            h = lid_thickness + lid_lip_h + 4
        );
    }
}