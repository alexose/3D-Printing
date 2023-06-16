use <threads.scad>


height = 70;
width = 34;
thickness = 3;

inner_height = 6;
tooth_height = 1.5;

board_width = 36.8;
board_height = 19.1;

sensor_width = 43.2 * 1.05; // fudged a bit
sensor_height = 18.8 * 1.07;

table_width = 40;
table_height = 40;

standoff_thickness = 2.5;
standoff_offset = width;
standoff_distance = width - 6;
standoff_depth = 1.5;

pizza_saver_height = 18;
clearance = 2 + standoff_depth;


// translate([50, 0, 0]) bottom_piece();
// translate([-50, 0, 0]) top_piece();
// translate([0, -50, 0]) battery_pack();
translate([-20, 0, 0]) pizza_saver(standoff_thickness);


module bottom_piece(){
    h = inner_height;
    t = thickness;
    w = width - t + tooth_height;
    
    sw = sensor_width;
    sh = sensor_height;
    
    difference() {
        union() {
            difference() {
                threaded_piece(h);
                translate([0, 0, h - (t / 2) ]) {
                    translate([0, 0, 1]) {
                        cube([sw, sh, 3], center=true);
                        oval_cutout();
                    }
                }
                sensor_holes(h);
                
            }
        }
        union(){
            r = 0.6; // Mounting hole radius
            o = 3; // Mounting hole offset
            translate([0, 0, 1]) standoffs(0.8, 3, sw - o, sh - o);
            
            sd = standoff_depth;
            st = standoff_thickness;
            ph = pizza_saver_height;
            
            translate([0, 0, ph + h + sd]) rotate([0, 180]) pizza_saver(st * 1.06);
        }
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

module pizza_saver(r){
    // https://en.wikipedia.org/wiki/Pizza_saver
    t = thickness;
    
    r2 = 0.8; // Mounting hole radius
    r3 = 1.8; // Less than screw head
    
    h = pizza_saver_height; // height of standoffs
    
    // Cubecell measurements
    ch = board_height;
    cw = board_width;
    co = 12; // Offset from center
    cd = 10; // Depth
    
    // Battery pack measurements
    bw = 41;
    bh = 19;
    
    bw2 = bw - (r3 * 2);
    bh2 = bh - (r3 * 2);
    
    bt = 2; // wall thickness
    bo = -11; // Offset from center
    bd = 15; // Depth


    // Battery box holders
    translate([bw/2 - (r/2), bo + bh / 2 - (r/2), bd-bt]) rounded_thing(r, bt);
    translate([-bw/2 + (r/2), bo - bh / 2 + (r/2), bd-bt]) rounded_thing(r, bt + clearance + (h - bd));
    translate([-bw/2 + (r/2), bo + bh / 2 - (r/2), bd-bt]) rotate([0,0,90]) rounded_thing(r, bt);
    translate([bw/2 - (r/2), bo - bh / 2 + (r/2), bd-bt])  rotate([0,0,90]) rounded_thing(r, bt + clearance + (h - bd));
    
    
    difference() {
        translate([0, co]) rounded_standoffs(r, 1, cw+bt-(r/2), ch+bt-(r/2));
        translate([0, co]) standoffs(r2, 1, cw-(r2/2), ch-(r2/2));
    }
   

    difference() {
        union(){ 
            battery_box(r, bd, bw2, bt, bh2, bo);
            cubecell_holder(co, ch, bt, r, cd, clearance, cw, h);
        }
        // Notch for side buttons
        translate([ch/2+2, -4, -2]) cube([5, 30, 4]);
    }
}

module battery_box(r, bd, bw2, bt, bh2, bo) {
    difference() {   
        translate([0, bo]) hull() standoffs(r, bd, bw2+bt, bh2+bt);
        translate([0, bo, -1]) hull() standoffs(r-(bt/2), bd+1, bw2+bt, bh2+bt);
    }
}

module cubecell_holder(co, ch, bt, r, cd, clearance, cw, h) {
    difference() {   
        union(){
            translate([0, co]) hull() standoffs(r, cd, cw+bt-(r/2), ch+bt-(r/2));
            translate([-ch, co + (ch/2), 0]) rotate([0,0,90]) rounded_thing(r, h + clearance);
            translate([ch, co + (ch/2), 0]) rounded_thing(r, h + clearance);
        }
        union () {
            translate([-cw, co, -2]) rotate([0, 90, 0]) cylinder(cw*2, ch/2-2, ch/2-2, $fn=100);
            translate([0, co, -1]) hull() standoffs(r-(bt/2), cd+1, cw+bt-(r/2), ch+bt-(r/2));
        }
    }
}


// Cube with one rounded side
module rounded_thing(w, d=1) {
    $fn = 30;
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
    