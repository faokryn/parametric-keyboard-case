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

reinforcement = 3;      // reinforcement thickness
z = 0.02;               // small value to help stop z-fighting

// CHERRY-DEFINED VARIABLES (not recommended to change)

u = 19.05;              // single key "unit"
gap = 5.05;             // edge-to-edge case spacing
plate = 1.5;            // plate thickness

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

difference() {
    cube([width, depth, plate + reinforcement]);
    for (row = [0:len(layout)-1]) {
        for (key = [0:len(layout[row])-1]) {
            translate([
                (distance[row][key] - layout[row][key]/2 - 1/2)*u,
                row*u,
                0
            ]) {
                translate([gap, gap, -z/2]) cube([u - gap, u - gap, plate + z]);
                if (layout[row][key] < 2)
                    translate([3/4*gap, 3/4*gap, plate])
                        cube([u - gap/2, u - gap/2, reinforcement + z]);
                else {
                    translate([gap - 2*stab_width, gap - stab_offset, -z/2])
                        cube([stab_width, stab_height, plate + z]);
                    translate([stab_width + u, gap - stab_offset, -z/2])
                        cube([stab_width, stab_height, plate + z]);
                    translate([
                        3/4*gap - 2*stab_width,
                        3/4*gap - stab_offset,
                        plate
                    ])
                        cube([
                            4*stab_width + u - gap/2,
                            u + stab_offset - gap/2,
                            reinforcement + z
                        ]);
                }
            }
        }
    }
}
