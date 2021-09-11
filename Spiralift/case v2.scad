use <spiral_extrude.scad>;

w = 2; // Track width
g = 1; // Track gap
h = 1.5; // Track height
rh = 16; // Ribbon height
s = 30;

scale([1,1,1.5]) union() {
    difference() {
        translate([-2,0,0]) cube([10,3,11]);
        translate([1,3,0.5]) rotate([90, 0, 0]) scale([1,0.9]) linear_extrude(5) polygon([
            [0,0],
            [0,2],
            [2,3],
            [2,11],
            [4,11],
            [4,3],
            [6,2],
            [6,0],
        ]);
    }
    translate([-10,0,0]) cube([10,3,11]);
    translate([-10,0,-10]) cube([10,3,11]);
}



