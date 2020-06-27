include <./variables.scad>;

module body() {
    rotate([xa, -ya, 0]) difference() {
        translate([wall, wall, 0]) minkowski() {
            sphere(wall);
            cube([width + 2*tol, depth + 2*tol, plate + switch]);
        }
        translate([-z/2, -z/2, -wall - z/2])
            cube([width + 2*tol + 2*wall + z, depth + 2*tol + 2*wall + z, wall + z]);
    }
}

module cavity() {
    rotate([xa, -ya, 0]) translate([wall + gap/2, wall + gap/2, wall])
        cube([width + 2*tol - gap, depth + 2*tol - gap, switch]);
}

difference() {
    hull() {
        body();
        linear_extrude(z) projection() body();
    }

    rotate([xa, -ya, 0]) translate([wall, wall, wall + switch - gap/2])
        cube([width + 2*tol, depth + 2*tol, plate + gap/2 + z]);

    hull() {
        cavity();
        translate([0, 0, wall]) linear_extrude(z)  projection() cavity();
    }
}
