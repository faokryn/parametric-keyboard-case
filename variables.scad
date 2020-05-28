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
wall = 3;             // thickness of the wall of the case
tol = 0.25;             // tolerance between the plate and the case
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
