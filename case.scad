$fn =10;

tol = 0.25;         // tolerance to fit the plate into the case
pt = 1.5;           // thickness of the plate
wt = pt * 2;        // thickness of the case wall
sh = 10;            // height of clearance of the switch (below plate)

h = sh + pt + wt;   // height of the case
lt = wt/2;          // thickness of the lip holding the plate

module mainplate() {
    hull() import("mainplate.dxf");
}

translate([wt/2, wt/2,0])
difference() {
    linear_extrude(h)
    minkowski() {
        mainplate();
        circle(wt/2);
    }

    #translate([0,0,h-pt])
    linear_extrude(pt)
    offset(tol)
    mainplate();

    translate([0,0,wt])
    linear_extrude(h-wt)
    offset(-lt)
    mainplate();
}
