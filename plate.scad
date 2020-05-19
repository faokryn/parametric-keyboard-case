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

//n = [1, 2, 3, 4];
//function sublist(list, to) = [ for (i=[0:to]) list[i] ];
//function sumsublist(list, to) = [ for (y=sublist(list, to)) 1]*sublist(list, to);
//function sumsublist(list, to) = let (l = sublist(list, to)) [ for (y=l) 1]*l;
//function sumsublist(list, to) = let (sl = [ for (i=[0:to]) list[i] ]) [ for (y=sl) 1]*sl;
//function sumallsublists(list) = [ for (i=[0:len(list)-1]) sumsublist(list,i) ];
//function sumallsublists(list) = [ for (i=[0:len(list)-1]) let (sl = [ for (j=[0:i]) list[j] ]) [ for (y=sl) 1]*sl ];
//c = [for (x = layout) sumallsublists(x)];
c = [for (x = layout) [ for (i=[0:len(x)-1]) let (sl = [ for (j=[0:i]) x[j] ]) [ for (y=sl) 1]*sl ]];

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
