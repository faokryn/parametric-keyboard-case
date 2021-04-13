include <./variables.scad>;

screw_positions = [
    [screwhead_diameter/2 + wall, screwhead_diameter/2 + wall],
    [screwhead_diameter/2 +wall, depth - screwhead_diameter/2 + wall],
    [width - screwhead_diameter/2 + wall, screwhead_diameter/2 + wall],
    [width - screwhead_diameter/2 + wall, depth - screwhead_diameter/2 + wall]
];

module body() {
    rotate([xa, -ya, 0]) difference() {
        translate([wall, wall, 0]) minkowski() {
            sphere(wall);
            cube([width + x_tol, depth + y_tol, plate + switch]);
        }
        translate([-z/2, -z/2, -wall - z/2])
            cube([width + x_tol + 2*wall + z, depth + y_tol + 2*wall + z, wall + z]);
    }
}

module cavity() {
    rotate([xa, -ya, 0]) translate([wall + gap/2, wall + gap/2, wall])
        cube([width + x_tol - gap, depth + y_tol - gap, switch]);
}

difference() {
    union() {
        // case body
        difference() {
            project_extrude() body();

            // plate
            rotate([xa, -ya, 0]) translate([wall, wall, wall + switch - reinforcement])
                cube([width + x_tol, depth + y_tol, plate + reinforcement + z]);

            // cavity
            hull() {
                cavity();
                translate([0, 0, wall]) linear_extrude(z)  projection() cavity();
            }
        }

        // screw insert posts
        for (x = screw_positions) project_extrude()
            rotate([xa, -ya, 0]) translate([x[0], x[1], switch - reinforcement - screwinsert_length])
                cylinder(screwinsert_length + wall, d = screwinsert_diameter + 2*wall);
    }

    // screw insert holes
    for (x = screw_positions) rotate([xa, -ya, 0])
        translate([x[0], x[1], wall + switch - reinforcement - screwinsert_length])
            cylinder(screwinsert_length + z, d = screwinsert_diameter);

    // trs hole
    translate([
        width + gap - trs_counterbore_dia - screwinsert_diameter/2 - wall - hole_spacing,
        backwall_offset - z/2,
        trs_counterbore_dia/2 + 2*wall
    ]) rotate([270, 0, 0]) { 
        cylinder(backwall_depth + z, d = trs_hole_dia);
        cylinder(trs_counterbore_depth + z, d = trs_counterbore_dia);
    }

    // usb hole
    translate([
        width + gap - usb_hole_width - screwhead_diameter - 2*wall - 2*hole_spacing - trs_counterbore_dia,
        backwall_offset,
        (trs_counterbore_dia - usb_hole_height)/2 + 2*wall
    ]) cube([usb_hole_width, backwall_depth + z, usb_hole_height]);
}

// usb shelf
translate([
    width + gap- usb_hole_width - screwhead_diameter - 2*wall -2*hole_spacing - trs_counterbore_dia, 
    backwall_offset + backwall_depth - usb_shelf_depth,
    0
]) cube([usb_hole_width, usb_shelf_depth, (trs_counterbore_dia - usb_hole_height)/2 + 2*wall ]);

// microcontroller guide
translate([(width-mc_width)/2, backwall_offset - mc_depth - wall, 0]) {
    cube([wall, mc_guide_length + wall, mc_guide_height + wall]);
    cube([mc_guide_length + wall, wall, mc_guide_height + wall]);
    translate([mc_width + wall, 0, 0]) cube([wall, mc_guide_length + wall, mc_guide_height + wall]);
    translate([mc_width + wall - mc_guide_length, 0, 0]) cube([mc_guide_length + wall, wall, mc_guide_height + wall]);
    translate([0, mc_depth - wall, 0]) cube([wall, mc_guide_length + wall, mc_guide_height + wall]);
    translate([mc_width + wall, mc_depth - wall, 0]) cube([wall, mc_guide_length + wall, mc_guide_height + wall]);
}
