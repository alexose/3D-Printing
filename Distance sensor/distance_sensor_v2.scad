use <threads.scad>

translate([50, 0, 0]) bottom_piece();
// translate([-50, 0, 0]) top_piece();
// translate([0, -50, 0]) battery_pack();
rotate([180, 0, 0]) translate([-20, 0, -3]) pizza_saver();

height = 70;
width = 34;
thickness = 3;

inner_height = 6;
tooth_height = 1.5;

board_width = 36.8;
board_height = 19.1;

sensor_width = 43.2 * 1.05; // fudged a bit
sensor_height = 18.8 * 1.07;

standoff_thickness = 2.5;
standoff_offset = width;
standoff_distance = width - 6;

module bottom_piece(){
    h = inner_height;
    w = width - thickness + tooth_height;
    
    difference() {
        union() {
            difference() {
                threaded_piece(inner_height);
                translate([0, 0, inner_height - (thickness / 2) ]) {
                    translate([0, 0, 1]) {
                        cube([sensor_width, sensor_height, 3], center=true);
                        oval_cutout();
                    }
                }
                sensor_holes(h);
                
            }
        }
        rotate([0, 0, 60]) translate([0, 0, inner_height - 1.5]) tripod_standoffs(standoff_thickness * 1.07, 10, standoff_distance);
    }
}
 
module top_piece(){
    h = height;
    w = width * 1.025; // fudged a bit
    t = thickness / 2;

    difference(){
        domed_cylinder(h,w);
        domed_cylinder(h-t,w-t);
        threaded_piece(inner_height + 4, 3);
    }   
}

module pizza_saver(){
    // https://en.wikipedia.org/wiki/Pizza_saver
    d = 3; // depth
    b = 3; // border thickness
    t = thickness;
    
    r1 = width - t; // somewhat less than internal width of capsule
    r2 = 0.8; // less than screw diameter
    r3 = 1.8; // less than screw head
    
    h = 18;
    board_offset = 12;
    
    rotate([0, 0, 20]) translate([0, 0, thickness - h]) tripod_standoffs(standoff_thickness, h, standoff_distance);
    
    // Battery pack dimensions
    bw = 42 - (r3 * 2);
    bh = 20  - (r3 * 2);
    bt = 1.6; // wall thickness
    bd = 12;
    bo = -11;

    translate([0, bo, -bd]) rounded_standoffs(r3+.5, t, bw, bh);
    
    difference() {
    
        union(){
            translate([0, board_offset, 0]) rounded_standoffs(r3, d, board_width, board_height);
            difference(){
                union() {
                    cylinder(d, r1, r1);
                    translate([0, board_offset, 0]) standoffs(r3, d, board_width, board_height);
                    translate([0, bo, -bd]) hull() standoffs(r3, bd, bw+bt, bh+bt);
                }
                translate([0, board_offset, -.5]) hull() standoffs(r3, d+1, board_width, board_height);
            }
        }
        translate([0, bo, bd - 20]) hull() standoffs(r3, bd+10, bw, bh);
        translate([0, board_offset, 0]) standoffs(r2, d, board_width, board_height);
    }

}


// Cube with one rounded side
module rounded_thing(w, d=1) {

    l = w/2;

    translate([0, 0, d/2]) union() {
        translate([l, -l]) cube([w, w, d], center=true);
        translate([-l, l]) cube([w, w, d], center=true);
        cylinder(d, w, w, center=true);
    }
}

module battery_pack() {
    // battery_18650();
    flexbatter18650(n=2);
}

module battery_18650() {
    cylinder(65, 9, 9);
}

module sensor_holes(h){
    hole_radius = 16/2 * 1.01;
    hole_distance = 23.75;
    f = 1.05;
    
    translate([hole_distance/2, 0, 0]) cylinder(h*2, hole_radius*f, hole_radius*f);
    translate([-hole_distance/2, 0, 0]) cylinder(h*2, hole_radius*f, hole_radius*f);
}


module tripod_standoffs(r, depth, dist) {
    $fn = 20;
    
    rotate([0, 0, 30]) union() { 
        rotate([ 0, 0, 0 ]) translate([dist, 0]) cylinder(depth, r, r);
        rotate([ 0, 0, 120 ]) translate([dist, 0]) cylinder(depth, r, r);
        rotate([ 0, 0, 240 ]) translate([dist, 0]) cylinder(depth, r, r);
    }
}


module rounded_standoffs(r, depth, height, width) {
    $fn = 20;
    d = depth;
    x = height / 2;
    y = width / 2;
    
    union() { 
        translate([x, y]) rotate([0, 0, 0]) rounded_thing(r, d);
        translate([x, -y]) rotate([0, 0, 270]) rounded_thing(r, d);
        translate([-x, y]) rotate([0, 0, 90]) rounded_thing(r, d);
        translate([-x, -y]) rotate([0, 0, 180]) rounded_thing(r, d);
    }
}


module standoffs(r, depth, height, width) {
    $fn = 20;
    d = depth;
    x = height / 2;
    y = width / 2;
    
    union() { 
        translate([x, y]) cylinder(d, r, r);
        translate([x, -y]) cylinder(d, r, r);
        translate([-x, y]) cylinder(d, r, r);
        translate([-x, -y]) cylinder(d, r, r);
    }
}

module oval_cutout(){
    hull() translate([0, 0, -3.5]) standoffs(2, 2, 8, sensor_height-3);
}

module threaded_piece(h, tolerance=0.4){
    w = width * 2 - thickness / 2;
    t = tooth_height;
    ScrewThread(w, h, 3, tooth_height=t, tolerance=tolerance);
    
    // english_thread(1.375, 24, 0.2);
}

module domed_cylinder(h,w){
    $fs=3; // Don't set this to less than 1 unless you like freezing OpenSCAD
    $fa=0.1;
    // translate([0, 0, h]) scale([1,1,0.5]) sphere(w);
    translate([0, 0, h]) sphere(w);
    cylinder(h, w, w);
}
    