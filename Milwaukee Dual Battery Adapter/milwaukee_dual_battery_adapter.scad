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

    difference() {
        union() {
            translate([0, 0, h]) {
                translate([0, d, 4]) rotate([90, 0, 0]) mount(); 
                translate([0, -d, 4]) rotate([270, 180, 0]) mount();
            }

            dc_dc_module_base();
        }
        
        // Holes for wires
        wire_hole();
        mirror([0, 1, 0]) wire_hole();
        
    }
    
    module wire_hole() {
        rotate([-23, -15, 0]) translate([16, -65, -50]) scale([2, 1, 1]) cylinder(100, r=3.3);
    }
}

module dc_dc_module_base() {
    w = 78;
    l = 158;
    h = 6;
    r = 3;
    
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
            translate([0, 0, -1]) translate(screw_hole_coordinate) cylinder(5, r=1.2);
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
        [-25, -29.1], 
        [25, -29.1], 
        [-15.5, 48], 
        [15.5, 48]
    ];

    difference() {
        union() {
            hull() {
                base();
                rotate([90, 0]) translate([0, -8, base_plate_length/2 - 2]) base(3, 78, 35, 1);
            }
        }

        for (screw_hole_coordinate = screw_hole_coordinates) {
            translate([0, -5, -10]) translate(screw_hole_coordinate) cylinder(40, r=1.5); // screw shaft
            translate([0, -5, -33]) translate(screw_hole_coordinate) cylinder(40, r=4); // head
        }
    }
    
    
}



module base(r = base_plate_radius, w = 70, l = base_plate_length, h = base_plate_height) {
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

// 28mm tall standoff for long screw
module standoff() {
    r1 = 2; // radius of the screw shaft
    r2 = 4; // radius of the standoff itself
    h1 = 28;

    difference() {
        cylinder(r=r2, h=h1);
        cylinder(r=r1, h=h1);
    }
}
