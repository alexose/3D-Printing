use <threads.scad>

render_top = true;
render_bottom = true;
render_pizza_saver = false;
render_battery_pack = false;

// Dimensions
width = 28;
thickness = 2;

inner_height = 6;
overhang = 4;

board_width = 36.8;
board_height = 19.1;

sensor_width = 40 * 1.05; // fudged a bit
sensor_height = 16 * 1.07;
sensor_depth = 4;

standoff_thickness = 2.5;

battery_pack_height = 83;
standoff_height = 10;
pizza_saver_height = 10;
dome_height = 17;

tolerance = 0.1; // adjust if threads don't fit together
pitch = 2.8;
tooth_angle = 50;

// Height of outer shell, as determined by everything inside of it
height = battery_pack_height 
    + inner_height
    + standoff_height
    + pizza_saver_height;

// Needed to flip upside down
top_piece_height = height + overhang + (dome_height/2);


if (render_bottom) translate([50, 0, 0]) bottom_piece();
if (render_top) translate([-50, 0, top_piece_height]) rotate([0, 180]) top_piece();
if (render_pizza_saver) translate([0, 0, 0]) pizza_saver();
if (render_battery_pack) translate([0, -50, 0]) battery_pack();


module bottom_piece(){
    h = inner_height;
    w = width;
    
    sw = sensor_width;
    sh = sensor_height;
    sd = sensor_depth;
    
    vt = standoff_thickness;
    vh = standoff_height;

    bw = board_width;
    bh = board_height;

    
    difference() {
        union() {
            
            difference() {
                ScrewThread(w*2 - thickness, h, pitch=pitch, tooth_angle=tooth_angle, tolerance=tolerance);
                translate([0, 0, inner_height - (sd / 2) ]) {
                    translate([0, 0, 1]) {
                        cube([sw, sh, 3], center=true);
                    }
                }
                translate([4, 0]) cube([20, 16, 20], center=true);
                
            }
        }
        
        // Slice out a piece to make room for buttons
        slice_offset = -2;
        slice_height = 3;
        translate([bh, slice_offset, h+vh - 3]) rotate([0, 0, 90]) cube([bh, bw, vh]);
        
        union(){
            r = 1; // Mounting hole radius
            o = 4; // Mounting hole offset
            d = 5; // Mounting hole depth 
            d2 = 6; // Standoff mounting hole depth
            // translate([0, 0, inner_height - d]) standoffs(r, d, sw - o, sh - o);              
            translate([0, 0, inner_height - 2]) standoffs(r, d2, bh, bw);
        }
        
      
        
    }
}
 
module top_piece(){
    h = height + overhang;
    w = width;
    t = thickness/2;
    
    $fn=150;

    threaded_section_height = inner_height + overhang;
    compartment_height = inner_height + overhang + standoff_height + pizza_saver_height;
    
    //color([0.5,0.5,0,0.8]);
    
    ScrewHole(w*2 - thickness, threaded_section_height, pitch=pitch, tooth_angle=tooth_angle, tolerance=tolerance) { 
        difference(){
            domed_cylinder(h,w+t);
            translate([0, 0, compartment_height ]) battery_pack();
            cylinder(compartment_height, w-1, w-1);
        }
    } 
    
}

module pizza_saver(){
    // https://en.wikipedia.org/wiki/Pizza_saver
    d1 = pizza_saver_height;
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
        
        // Slice out a piece to make room for GPIO pins
        translate([-h/2-r1, w/2 - r1*2 - .3, d1-notch_height]) cube([h+r1*2, notch_offset, notch_height]);
        standoffs(r3, d2, h, w);
        standoffs(r2, d1, h, w);

   }
}

module battery_pack() {
    // Stand in for https://www.thingiverse.com/thing:2804374
    
    o = 12;
    h = battery_pack_height;
    h2 = 1;
    r = 15.4;
    r2 = r-1;
    
    hull() {
        triangle_thing(o, h, r);
        translate([0, 0, h]) triangle_thing(o, h2, r2+0.5);
        translate([0, 0, h+0.5]) triangle_thing(o, h2+0.5, r2-0.5);
    }
}

module battery_18650() {
    cylinder(65, 9, 9);
}

module triangle_thing(o, h, r) {
    rotate([0, 0, 30]) hull () {
        rotate([0, 0, 120]) translate([0, o]) cylinder(h, r, r);
        rotate([0, 0, 240]) translate([0, o]) cylinder(h, r, r);
        translate([0, o]) cylinder(h, r, r);
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

module domed_cylinder(h,w){
    $fs=3; // Don't set this to less than 1 unless you like freezing OpenSCAD
    $fa=0.1;
    $fn=150; // Again, careful here
    c = dome_height;
    // translate([0, 0, h]) scale([1,1,0.5]) sphere(w);

    difference(){ 
        union(){ 
            translate([0, 0, h]) scale([1, 1, 0.5]) sphere(w);
            cylinder(h, w, w);
        }
        translate([0, 0, h+c]) cube([w*2, w*2, c], center=true);
    }
 }
    
