$fn = 50;

plate_file = "plate.dxf";   // .dxf file of the switch plate
wall_t = 3;                 // thickness of the case wall
xa = 5;                     // angle of the main plate over the x-axis
ya = 5;                     // angle of the main plate over the y-axis

screw_l = 8;                // length of the screwhole
screw_r = 0.75;              // radius of the screwhole (default guide for 0-80)
supports = [                // Supports, in the form [x, y, hole]
                            // - x and y are the position in keyboard units
                            // - hole is true if a screwhole should be rendered
    [2,2,true],
    [4,2,true],
    [3,1,false],
    [3,3,false]
];

switch_h = 10;              // height of clearance of the switch (below plate)
plate_t = 1.5;              // thickness of the plate
h = switch_h + plate_t;     // height of the case
lip_t = wall_t/2;           // thickness of the lip holding the plate
tol = 0.25;                 // tolerance to fit the plate into the case
tiny = 0.0001;              // negligably small size

function kbu(x) = x * 19.05;

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

// case body
difference() {
    extrude_to_xy() case(wall_t/2);

    extrude_to_xy(wall_t) case(-lip_t);

    pos_at_angle()
    translate([0,0,h - plate_t - tol]) linear_extrude(plate_t + tol + tiny)
    offset(tol) plate();
    
    // aux slot
    translate([105,80,10.5])
    rotate([90,0,0])
    cylinder(10,4,4);
    
    // usb slot
    //translate([85,70,6])
    //cube([11.8,10,9.5]);
    
    // magnef slots
    translate([110.95, 10,   12])
    rotate([0,90,0])
    cylinder(1.5, 4.25, 4.25);
    
    translate([110.75, 22.5, 12])
    rotate([0,90,0])
    cylinder(1.5, 4.25, 4.25);
    
    translate([110.55, 35,   12])
    rotate([0,90,0])
    cylinder(1.5, 4.25, 4.25);
    
    translate([110.35, 47.5, 12])
    rotate([0,90,0])
    cylinder(1.5, 4.25, 4.25);
    
    translate([110.20, 60,   12])
    rotate([0,90,0])
    cylinder(1.5, 4.25, 4.25);
}



// supports
for (support = supports) {
    difference() {
        hull() {
            // supports
            extrude_to_xy() pos_at_angle()
            translate([kbu(support[0]), kbu(support[1]), h - plate_t])
            linear_extrude(tiny) circle(wall_t);

            // screw plugs
            if (support[2]) {
                pos_at_angle()
                translate([
                    kbu(support[0]),
                    kbu(support[1]),
                    h - plate_t - screw_l - wall_t / 2
                ])
                linear_extrude(screw_l + wall_t / 2) circle(wall_t);
                
                extrude_to_xy()
                pos_at_angle()
                translate([
                    kbu(support[0]),
                    kbu(support[1]),
                    h - plate_t - screw_l - wall_t / 2
                ])
                linear_extrude(screw_l + wall_t / 2) circle(wall_t);
            }
        }

        // screw holes
        if (support[2]) {
            pos_at_angle()
            translate([kbu(support[0]), kbu(support[1]), h - plate_t - screw_l])
            linear_extrude(screw_l + tiny*2) circle(screw_r);
        }
    }
}

// uncomment to render the switch plate for debugging:
// #pos_at_angle() translate([0,0,h - plate_t])
// linear_extrude(plate_t) import(plate_file);
