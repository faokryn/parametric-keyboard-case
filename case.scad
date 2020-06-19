include <./variables.scad>;

difference() {
    translate([wall, wall, 0]) minkowski() {
        sphere(wall);
        cube([width + 2*tol, depth + 2*tol, plate + switch]);
    }
    translate([-z/2, -z/2, -wall - z/2])
        cube([width + 2*tol + 2*wall + z, depth + 2*tol + 2*wall + z, wall + z]);

    translate([wall, wall, wall + switch - reinforcement])
        cube([width + 2*tol, depth + 2*tol, plate + reinforcement + z]);

    translate([wall + gap/2, wall + gap/2, wall])
        cube([width - gap, depth - gap, switch]);
}
