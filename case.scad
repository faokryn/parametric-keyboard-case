$fn =10;

tol = 0.25;         // tolerance to fit the plate into the case
sh = 10;            // height of clearance of the switch (below plate)
xa = 5;             // angle of the main plate over the x-axis
ya = 5;             // angle of the main plate over the y-axis
pt = 1.5;           // thickness of the plate
wt = pt * 2;        // thickness of the case wall

h = sh + pt;        // height of the case
lt = wt/2;          // thickness of the lip holding the plate

module mainplate() {
    hull() import("mainplate.dxf");
}

module flatcase() {
    translate([sin(ya)*h,sin(xa)*h,wt])
    rotate([xa,-ya,0])
    linear_extrude(h)
    minkowski() {
        mainplate();
        circle(wt/2);
    }
}

module caseshell() {
    translate([sin(ya)*h,sin(xa)*h,wt])
    rotate([xa,-ya,0])
    linear_extrude(h)
    offset(-lt)
    mainplate();
}

translate([wt/2,wt/2,0])
difference() {
    hull() {
        flatcase();

        linear_extrude(0.0001)
        projection()
        flatcase();
    }

    hull() {
        caseshell();

        translate([0,0,wt])
        linear_extrude(0.0001)
        projection()
        caseshell();
    }

    translate([sin(ya)*h,sin(xa)*h,wt])
    rotate([xa,-ya,0])
    translate([0,0,h-pt-tol])
    linear_extrude(pt+tol+0.0001)
    offset(tol)
    mainplate();
}
