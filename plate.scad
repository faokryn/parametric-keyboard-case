/*
    plate.scad

    Generate a 3D model for a keyboard case

    author: Colin O'Neill <colin@faokryn.com>
    date: 2020-05-19
*/

// LAYOUT

sample_layout = [
    [1.5, 1, 1, 1, 1, 1, 1],
    [1.5, 1, 1, 1, 1, 1, 1],
    [1.5, 1, 1, 1, 1, 1, 1],
    [1.5, 1, 1, 1, 1, 1, 1],
    [1.5, 1.5, 1.25, 2.75]
];

layout = sample_layout;

// INDEPENDENT VARIABLES

r = 3;      // reinforcement thickness
z = 0.02;   // small value to help stop z-fighting

// CHERRY-DEFINED VARIABLES (not recommended to change)

u = 19.05;  // single key "unit"
s = 5.05;   // edge-to-edge case spacing
p = 1.5;    // plate thickness

e = 3.3;
f = 14.2;
g = 0.55;
h = 0.75;

// DEPENDENT VARIABLES (not recommended to change)

c = [
    for (x = layout) [
        for (i=[0:len(x)-1])
            let (sl = [ for (j=[0:i]) x[j] ])
            [ for (y=sl) 1]*sl
    ]
];
w = max([for(x=c) x[len(x)-1]]) * u + s;    // plate width
d = len(layout) * u + s;                    // plate depth

difference() {
    cube([w, d, p + r]);
    for (row = [0:len(layout)-1]) {
        for (key = [0:len(layout[row])-1]) {
            translate([(c[row][key] - layout[row][key]/2 - 1/2)*u, row*u, 0]) {
                translate([s, s, -z/2]) cube([u - s, u - s, p + z]);
                if (layout[row][key] < 2)
                    translate([3/4*s, 3/4*s, p])
                        cube([u - s/2, u - s/2, r + z]);
                else {
                    translate([s - 2*e,s-h,-z/2]) cube([e, f, p + z]);
                    translate([u+e,s-g,-z/2]) cube([e, f, p + z]);
                    translate([3/4*s - e*2, 3/4*s - g, p])
                        cube([u - s/2 + e*4, u + g - s/2, r + z]);
                }
            }
        }
    }
}
