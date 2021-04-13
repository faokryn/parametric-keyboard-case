$fn = 50;

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

reinforcement = 3;      // reinforcement thickness
wall = 2;               // thickness of the wall of the case

x_tol = 0.2;            // tolerance between the plate & the case on the x-axis
y_tol = 0.05;           // tolerance between the plate & the case on the y-axis

xa = 8;                 // tilt angle over the x-axis
ya = 0;                 // tilt angle over the y-axis

screwshaft_diameter = 3;
screwhead_diameter = 5;
screwinsert_diameter = 3;
screwinsert_length = 5;

trs_hole_dia = 8.5;
trs_counterbore_dia = 11;
trs_counterbore_depth = 2;

usb_hole_width = 8;
usb_hole_height = 4.5;
usb_shelf_depth = 10;

hole_spacing = 5;

mc_width = 31;
mc_depth = 18;
mc_guide_height = 6;
mc_guide_length = 4;

z = 0.02;               // small value to help stop z-fighting

// CHERRY-DEFINED VARIABLES (not recommended to change)

u = 19.05;              // single key "unit"
gap = 5.05;             // edge-to-edge case spacing
plate = 1.5;            // plate thickness
switch = 10;            // clearance height of the switch

stab_width = 3.3;       // stabilizer hole width
stab_height = 14.2;     // stabilizer hole height
stab_offset = 0.55;     // stabilizer vertical offset from key hole

// DEPENDENT VARIABLES (not recommended to change)

// 2D array the same dimensions as layout containing the cumulative distance
// (in Cherry "units") from the edge of the board instead of the size of the key
distance = [
    for (row = layout) [
        for (i=[0:len(row)-1])
            let (sub_array = [ for (j=[0:i]) row[j] ])
            [ for (x=sub_array) 1]*sub_array
    ]
];
width = max([for(row = distance) row[len(row) - 1]]) * u + gap; // plate width
depth = len(layout) * u + gap;                                  // plate depth

backwall_depth = wall*cos(90 - xa) + (wall + gap/2)*cos(xa);    // depth of case's back wall
backwall_offset = (depth + wall + y_tol - gap/2)*cos(xa) - wall*sin(xa); // offset of case's back wall

// UTILITY MODULES

module project_extrude() {
    for (i = [0 : 1 : $children - 1]) {
        hull() {
            children(i);
            linear_extrude(z) projection() children(i);
        }
    }
}
