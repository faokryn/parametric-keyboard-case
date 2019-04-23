$fn = 10;

plate_file = "plate.dxf";   // .dxf file of the switch plate
wall_t = 3;                 // thickness of the case wall
xa = 5;                     // angle of the main plate over the x-axis
ya = 5;                     // angle of the main plate over the y-axis

switch_h = 10;              // height of clearance of the switch (below plate)
plate_t = 1.5;              // thickness of the plate
h = switch_h + plate_t;     // height of the case
lip_t = wall_t/2;           // thickness of the lip holding the plate
tol = 0.25;                 // tolerance to fit the plate into the case
tiny = 0.0001;              // negligably small size

module extrude_to_xy(h = 0) {
    for (i = [0:1:$children-1]) {
        hull() {
            children(i);
            translate([0,0,h]) linear_extrude(tiny) projection() children(i);
        }
    }
}

module pos_at_angle() {
    translate([0,0,wall_t]) rotate([xa,-ya,0]) children();
}

module plate() {
    hull() import(plate_file);
}

module case(o = 0) {
    pos_at_angle() linear_extrude(h) offset(o) plate();
}

difference() {
    extrude_to_xy() case(wall_t/2);

    extrude_to_xy(wall_t) case(-lip_t);

    pos_at_angle()
    translate([0,0,h - plate_t - tol]) linear_extrude(plate_t + tol + tiny)
    offset(tol) plate();
}
