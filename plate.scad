/*
    plate.scad
    
    Generate a 3D model for a keyboard case
    
    author: Colin O'Neill <colin@faokryn.com>
    date: 2020-05-19
*/

// LAYOUT

sample_layout = [
    [1, 1, 1, 1],
    [1, 1, 1, 1]
];

layout = sample_layout;

// INDEPENDENT VARIABLES

r = 3;      // reinforcement thickness
z = 0.02;   // small value to help stop z-fighting

// CHERRY-DEFINED VARIABLES (not recommended to change)

u = 19.05;  // single key "unit"
s = 5.05;   // edge-to-edge case spacing
p = 1.5;    // plate thickness

// DEPENDENT VARIABLES (not recommended to change)

w = max([for (x = layout) [for(n=x) 1]*x]) * u + s; // plate width
d = len(layout) * u + s;                            // plate depth

difference() {
    color("blue") cube([w, d, p + r]);
    for (i = [0:len(layout)-1]) {
        for (j = [0:len(layout[i])-1]) {
            translate([s + j*u, s + i*u, -z/2])
                cube([u - s, u - s, p + z]);
            translate([3/4*s + j*u, 3/4*s + i*u, p])
                cube([u - s/2, u - s/2, r + z]);
        }
    }
}
