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

difference() {
    hull() {
        body();
        linear_extrude(z) projection() body();
    }

    rotate([xa, -ya, 0]) translate([wall, wall, wall + switch - gap/2])
        cube([width + x_tol, depth + y_tol, plate + gap/2 + z]);

    hull() {
        cavity();
        translate([0, 0, wall]) linear_extrude(z)  projection() cavity();
    }
}
