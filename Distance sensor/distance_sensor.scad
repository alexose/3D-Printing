use <threads.scad>


//translate([50, 0, 0]) bottom_piece();
translate([-50, 0, 0]) top_piece();


// translate([0, -50, 0]) battery_pack();
//translate([0, 0, 0]) pizza_saver();

height = 35;
width = 32;
thickness = 3;

inner_height = 6;
tooth_height = 1.5;

board_width = 36.8;
board_height = 19.1;

sensor_width = 43.2 * 1.05; // fudged a bit
sensor_height = 18.8 * 1.07;

standoff_thickness = 2.5;

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
            translate([0, 0, inner_height]) standoffs(standoff_thickness, 10, board_height, board_width);
        }
        translate([0, 0, thickness]) standoffs(1, 15, board_height, board_width);
    }
}
 
module top_piece(){
    h = height;
    w = width * 1.025; // fudged a bit
    t = thickness / 2;


    
    color([0.5,0.5,0,0.8]) 
    difference(){
        domed_cylinder(h,w);
        domed_cylinder(h-t-1,w-t-1);
        union() {
            translate([0, 0, height-58]) import("BatHolder_18650_Top_Cap.stl");
            threaded_piece(inner_height + 4, 3);
        }
    } 
    
}

module pizza_saver(){
    // https://en.wikipedia.org/wiki/Pizza_saver
    d1 = 17;
    d2 = 3;
    w = board_width;
    h = board_height;
    pin_offset = 3.5;
    r1 = standoff_thickness;
    r2 = 1.2; // less than screw diameter
    r3 = 1.8; // less than screw head
    
    notch_height = 10;
    notch_offset = 4.1;

    difference() {
        union() {
            standoffs(r1, d1, h, w);
            hull() standoffs(3, d2, h-pin_offset*2, w-pin_offset);
        }
        translate([-h/2-r1, w/2 - r1*2 - .3, d1-notch_height]) cube([h+r1*2, notch_offset, notch_height]);
        standoffs(r3, d2, h, w);
        standoffs(r2, d1, h, w);

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
    