// Milwaukee Battery Adapter
//
// This allows you to use any battery (18V or higher) to power a Milwaukee 18V Tool
//
// You'll need the following:
// - 3D printed adapter
// - MT20ML 18V battery adapter (check ebay)
// - 800W 30A DC-DC Step Down Module, sometimes called AP-D5830A (check ebay, also can be found on Amazon)
// - Screws

$fn = 60;
base_plate_height = 3;
base_plate_length = 110;
base_plate_radius = 19;

main_assembly();
// standoff();

module main_assembly() {
    distance_between_mounts = 87;
    d = (distance_between_mounts + base_plate_height * 2) / 2;
    h = 10;
    y = 30;

    difference() {
        hull (){
            translate([0, y, h]) {
                base();       
            }
            dc_dc_module_base();
        }
        translate([0, y, 0]) base_screw_holes();
        dc_dc_module_screw_holes();
        translate([0, y*2 + 60, -15]) rotate([70, 0, 0]) scale([2, 1, 1]) cylinder(100, r=5);
    }
    
    
}

module dc_dc_module_base() {
    w = 78;
    l = 158;
    h = 6;
    r = 3;

    base(r, w, l, h);
}

module dc_dc_module_screw_holes() {
    
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
    
    for (screw_hole_coordinate = screw_hole_coordinates) {
        translate([0, 0, -1]) translate(screw_hole_coordinate) cylinder(5, r=1.2);
    }
}


module base_screw_holes() {
    // Original measurements:
    // [0, 0]
    // [7.5, 12.5]
    // [7.5, -12.5]
    // [84, 10.5]p
    // [84, -10.5]
    
    // Centered and rotated
    screw_hole_coordinates = [
        [0.0, -36.6], 
        [-24.5, -28.8], 
        [24.5, -28.8], 
        [-15.5, 48], 
        [15.5, 48]
    ];

    translate([0, 0, -5]) for (screw_hole_coordinate = screw_hole_coordinates) {
        union() {
            translate([0, -5, -10]) translate(screw_hole_coordinate) cylinder(40, r=1.5); // screw shaft
            translate([0, -5, 14]) translate(screw_hole_coordinate) cylinder(3, 4, 1.5); // transition
            translate([0, -5, -26]) translate(screw_hole_coordinate) cylinder(40, r=4); // head
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

module base_plate_polygon() {
    polygon([[0,8/*1:0,4,0,-8*/] ,[0.06,6.86] ,[0.22,5.83] ,[0.55,4.74] ,[0.99,3.8] ,[1.63,2.86] ,[2.36,2.1] ,[3.17,1.48] ,[4.12,0.94] ,[5.07,0.55] ,[6.07,0.26] ,[7.09,0.07],[8,0],[16,0/*1:0,0,0,0*/] ,[17.07,0.1] ,[18.15,0.31] ,[19.17,0.64] ,[20.12,1.06] ,[21.07,1.64] ,[21.85,2.3] ,[22.57,3.11] ,[23.17,4.1] ,[23.57,5.09] ,[23.85,6.23] ,[23.98,7.3],[24,8/*1:0,-8,0,8*/] ,[24,9.2] ,[24,10.4] ,[24,11.6] ,[24,12.8] ,[24,14] ,[24,15.2] ,[24,16.4] ,[24,17.6] ,[24,18.8] ,[24,20] ,[24,21.2] ,[24,22.4] ,[24,23.6] ,[24,24.8] ,[24,26] ,[24,27.2] ,[24,28.4] ,[24,29.6] ,[24,30.8],[24,32/*1:0,-8,0,8*/] ,[23.94,33.14] ,[23.78,34.17] ,[23.45,35.26] ,[23.01,36.2] ,[22.37,37.14] ,[21.64,37.9] ,[20.83,38.52] ,[19.88,39.06] ,[18.93,39.45] ,[17.93,39.74] ,[16.91,39.93],[16,40],[8,40/*1:0,0,0,0*/] ,[6.93,39.9] ,[5.85,39.69] ,[4.83,39.36] ,[3.88,38.94] ,[2.93,38.36] ,[2.15,37.7] ,[1.43,36.89] ,[0.83,35.9] ,[0.43,34.91] ,[0.15,33.77] ,[0.02,32.7],[0,32/*1:0,8,0,-8*/] ,[0,30.77] ,[0,29.75] ,[0,28.7] ,[0,27.63] ,[0,26.54] ,[0,25.44] ,[0,24.32] ,[0,23.2] ,[0,22.09] ,[0,20.97] ,[0,19.86] ,[0,18.77] ,[0,17.7] ,[0,16.64] ,[0,15.62] ,[0,14.38] ,[0,13.21] ,[0,12.1] ,[0,11.06] ,[0,9.94] ,[0,8.8]]);
}
