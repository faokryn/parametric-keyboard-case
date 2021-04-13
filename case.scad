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
        depth  - 2*wall/3 - 2*y_tol,
        trs_counterbore_dia/2 + 2*wall
    ]) rotate([270, 0, 0]) {
        cylinder(1.5*wall + gap/2 + y_tol, d = trs_hole_dia);
        cylinder(trs_counterbore_depth, d = trs_counterbore_dia);
    }

    // usb hole
    translate([
        width + gap- usb_hole_width - screwhead_diameter - 2*wall -2*hole_spacing - trs_counterbore_dia,
        depth + wall/2 - gap/2,
        trs_counterbore_dia/2 + 2*wall - usb_hole_height/2
    ]) cube([usb_hole_width, wall + gap/2 + y_tol + wall/2, usb_hole_height]);
}

// usb shelf
translate([
    width + gap- usb_hole_width - screwhead_diameter - 2*wall -2*hole_spacing - trs_counterbore_dia,
    depth + wall/2 - gap/2 - usb_shelf_depth,
    0
]) cube([usb_hole_width, usb_shelf_depth, 2*wall + (trs_counterbore_dia - usb_hole_height)/2 ]);
