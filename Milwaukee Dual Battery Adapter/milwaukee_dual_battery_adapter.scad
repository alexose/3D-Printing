// Milwaukee 3006-20 Dual Battery String Trimmer Battery Adapter
//
// This allows you to use any battery (18V or higher) to power the Milwaukee 3006-20 Dual Battery String Trimmer.
//
// You'll need the following:
// - 3D printed adapter
// - 2x MT20ML 18V battery adapter (check ebay)
// - 800W 30A DC-DC Step Down Module, sometimes called AP-D5830A (check ebay, also can be found on Amazon)
// - Screws

$fn = 60;
base_plate_height = 10;
base_plate_length = 110;
base_plate_radius = 16;

main_assembly();
// standoff();

module main_assembly() {
    distance_between_mounts = 87;
    d = (distance_between_mounts + base_plate_height * 2) / 2;
    h = base_plate_length / 2;

    translate([0, 0, h]) {
        translate([0, d]) rotate([90, 0, 0]) mount(); 
        translate([0, -d]) rotate([270, 180, 0]) mount();
    }

    dc_dc_module_base();
}

module dc_dc_module_base() {
    w = 78;
    l = 158;
    h = 5;
    r = 2;
    
    // Original measurements:
    // [0, 0]
    // [0, 147.5]
    // [64.5, 147.5]
    // [64.5, 0]
    
    // Centered and rotated
    screw_hole_coordinates = [
        [32.25, 73.75],
        [32.25, -73.75],
        [-32.25, -73.75],
        [-32.25, 73.75]
    ];

    difference() {
        base(r, w, l, h);
        for (screw_hole_coordinate = screw_hole_coordinates) {
            translate(screw_hole_coordinate) cylinder(10, r=1);
        }
    }
}

// Mounts on the bottom half of the MT20ML 18V battery adapter.
// (It would be cooler if I could print that part as well, but that would take a lot of time to figure out)
module mount() {

    // Original measurements:
    // [0, 0]
    // [7.5, 12.5]
    // [7.5, -12.5]
    // [84, 10.5]
    // [84, -10.5]
    
    // Centered and rotated
    screw_hole_coordinates = [
        [0.0, -36.6], 
        [-12.5, -29.1], 
        [12.5, -29.1], 
        [-10.5, 47.4], 
        [10.5, 47.4]
    ];

    difference() {
        union() {
            hull() {
                base();
                translate([0, -base_plate_length/2+1, -10]) base(0.1, 50, 0, 20);
            }
        }

        for (screw_hole_coordinate = screw_hole_coordinates) {
            translate([0, -3, -10]) translate(screw_hole_coordinate) screw_hole(1.5, 40);
        }

        // Holes for wires
        translate([5, 0]) cylinder(20, 2.5, 2.5);
        translate([-5, 0]) cylinder(20, 2.5, 2.5);
    }
}

module base(r = base_plate_radius, w = 50, l = base_plate_length, h = base_plate_height) {
    x1 = w/2-r;
    x2 = -w/2+r;
    y1 = l/2-r;
    y2 = -l/2+r;
    hull() {
        translate([x1, y1]) cylinder(h, r=r);
        translate([x2, y1]) cylinder(h, r=r);
        translate([x1, y2]) cylinder(h, r=r);
        translate([x2, y2]) cylinder(h, r=r);
    }
}


// This is a "negative", meant to be subtracted from the adapter.
module screw_hole(r1=1.5, h=10) {
    // r1 is radius of screw shaft
    r2 = 2 + 0.5; // radius of the screw head, plus a little extra
    h1 = h; // height of the screw
    h2 = 2 + 0.5; // height of the head, plus a little extra
    union() {
        cylinder(r=r1, h=h1);
        cylinder(r=r2, h=h2);
    } 
}

// 30mm tall standoff for long screw
module standoff() {
    r1 = 1.5; // radius of the screw shaft
    r2 = 3.5; // radius of the standoff itself
    h1 = 30; // height of the screw

    difference() {
        cylinder(r=r2, h=h1);
        cylinder(r=r1, h=h1);
    }
}
