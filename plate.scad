/*
    plate.scad

    Generate a 3D model for a keyboard case

    author: Colin O'Neill <colin@faokryn.com>
    date: 2020-05-19
*/

include <./variables.scad>;

module plate() {
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

        // screw holes
        for (x = [
            [z + screwhead_diameter/2, z + screwhead_diameter/2],
            [z + screwhead_diameter/2, depth - z - screwhead_diameter/2],
            [width - z - screwhead_diameter/2, depth - z - screwhead_diameter/2],
            [width - z - screwhead_diameter/2, z + screwhead_diameter/2]
        ]) {
            translate([x[0], x[1], 0]) {
                cylinder(d = screwshaft_diameter, plate + reinforcement);
                cylinder(d = screwhead_diameter, plate + reinforcement - wall);
            }
        }
    }
}

plate();
