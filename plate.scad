/*
    plate.scad
    
    Generate a 3D model for a keyboard case
    
    author: Colin O'Neill <colin@faokryn.com>
    date: 2020-05-19
*/

sample_layout = [
    [1, 1, 1, 1],
    [1, 1, 1, 1],
    [1, 1, 1, 1]
];

layout = sample_layout;

u = 19.05;
s = 5.05;
w = max([for (x = layout) [for(n=x) 1]*x]) * u + s;
d = len(layout) * u + s;
h = 1.5;
r = 3;


difference() {
    color("blue") cube([w, d, h]);
    for (i = [0:len(layout)-1]) {
        for (j = [0:len(layout[i])-1]) {
            translate([s + j*u, s + i*u, -0.01])
                cube([u-s, u-s, h+0.02]);
        }
    }
}

translate([0, 0, h])
    cube([3/4*s, d, r]);
translate([0, 0, h])
    cube([w, 3/4*s, r]);
for (i = [1:len(layout)-1]) {
    translate([0, u*i + s/4, h])
        cube([w, s/2, r]);
    for (j = [1:len(layout[i])-1]) {
        translate([j*u + s/4, 0, h])
            cube([s/2, d, r]);
    }
}
translate([w - 3/4*s, 0, h])
    cube([3/4*s, d, r]);
translate([0, d - 3/4*s, h])
    cube([w, 3/4*s, r]);
