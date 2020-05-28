include <./variables.scad>;

difference() {
    cube([
        width + 2*wall + 2*tol,
        depth + 2*wall + 2*tol,
        plate + switch + wall
    ]);
    translate([wall + tol, wall + tol, wall + switch - reinforcement]) cube([
        width + 2*tol,
        depth + 2*tol,
        plate + reinforcement + z
    ]);
    translate([wall + gap/2 + tol, wall + gap/2 + tol, wall]) cube([
        width - gap,
        depth - gap,
        switch
    ]);
}
