include <./variables.scad>;

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

module cantilever() {
    translate([wall - cant_thickness, 0, 0])
        cube([cant_thickness, cant_width, plate + switch + cant_tol]);
    translate([
        2*wall - cant_thickness,
        cant_width,
        switch + plate + cant_tol
    ]) rotate([90,0,0]) rotate_extrude(angle=180) square([wall, cant_width]);
}

difference() {
    hull() {
        body();
        linear_extrude(z) projection() body();
    }

    // plate
    rotate([xa, -ya, 0]) translate([wall, wall, wall + switch - gap/2])
        cube([width + x_tol, depth + y_tol, plate + gap/2 + z]);

    // cavity
    hull() {
        cavity();
        translate([0, 0, wall]) linear_extrude(z)  projection() cavity();
    }

    // cantilever gaps
    rotate([xa, -ya, 0]) {
        translate([width*cos(ya) - width - z/2, wall + gap/2, wall])
            cube([wall + gap/2 + width - width*cos(ya) + z, cant_width + 2*cant_gap, wall + switch + plate]);

        translate([width + wall + x_tol - gap/2 - z/2, wall + gap/2, wall])
            cube([wall + gap/2 + z, cant_width + 2*cant_gap, wall + switch + plate]);

        translate([width*cos(ya) - width - z/2, depth + wall + y_tol - gap/2 - cant_width - 2*cant_gap, wall])
            cube([wall + gap/2 + width - width*cos(ya) + z, cant_width + 2*cant_gap, wall + switch + plate]);

        translate([width + wall + x_tol - gap/2 - z/2, depth + wall + y_tol - gap/2 - cant_width - 2*cant_gap, wall])
            cube([wall + gap/2 + z, cant_width + 2*cant_gap, wall + switch + plate]);
    }
}

rotate([xa, -ya, 0]) {
    translate([0, wall + gap/2 + cant_gap, wall]) cantilever();
    translate([
        0,
        depth + y_tol + wall - gap/2 - cant_width - cant_gap,
        wall
    ]) cantilever();
    mirror([1, 0, 0]) translate([
        -(width + wall*2 + x_tol),
        wall + gap/2 + cant_gap,
        wall
    ]) cantilever();
    mirror([1, 0, 0]) translate([
        -(width + wall*2 + x_tol),
        depth + y_tol + wall - gap/2 - cant_width - cant_gap,
        wall
    ]) cantilever();
}
