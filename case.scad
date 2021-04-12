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
}
