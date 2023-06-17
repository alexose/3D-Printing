/*

Dorothy Sensor
==============

(see also: Dorothy Hub)

The Dorothy Sensor consists of three parts:

1. Brain: A threaded disc on which the sensor and and CubecCell board is mounted.
2. Battery Pack:  Three 18650 cells placed in a Cylindrical Battery Holder (see: https://www.thingiverse.com/thing:6080710)
3. Shell: The threaded cylinder that covers the whole assembly and protects it from the elements

The Brain can come in many different shapes, depending on the type of sensor(s) you want to use.
This file includes variations for:

* US-100 ultrasonic sensor
* DHT22
* Catnip Eletronics' soil moisture sensor (https://www.tindie.com/products/miceuz/i2c-soil-moisture-sensor/)

With more on the way!

*/


use <threads.scad>

// Parts
render_shell = 1;
render_brain = 1;

// Adjustable dimensions
thickness = 2;     // Thickness of wall.  Recommend 2mm to make room for threads
width = 27;        // Outer radius.  With 2mm thick walls, the inside radius is 25mm
tolerance = 0.3;   // Adjust if threads don't fit together
dome_height = 17;  // Controls "Roundness" of shell
overhang = 4;      // Extra shell height to allow for a bit of overhang

// Non-adjustable dimensions
battery_pack_height = 83;
pitch = 2.8;
tooth_angle = 50;
brain_height = 6;  // Height of inner "brain" compartment


// Total height of outer shell, as determined by everything inside of it
height = battery_pack_height 
    + brain_height 
    + overhang;

if (render_brain) translate([width + thickness*2, 0, 0]) brain();
if (render_shell) translate([-width - thickness*2, 0, 0]) rotate([0, 180]) shell();


module brain(){

    board_width = 36.8;
    board_height = 19.1;

    sensor_width = 43.2 * 1.05; // fudged a bit
    sensor_height = 18.8 * 1.07;
    sensor_depth = 3;

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
                        oval_cutout();
                    }
                }
                sensor_holes(h);
                
            }
            translate([0, 0, h]) standoffs(vt, vh, bh, bw);
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
            translate([0, 0, inner_height - d]) standoffs(r, d, sw - o, sh - o);              
            translate([0, 0, inner_height + vh - d2]) standoffs(r, d2, bh, bw);
        }
    }
}
 
module shell(){
    h = height + overhang;
    w = width;
    t = thickness/2;
    
    $fn=150;

    threaded_section_height = inner_height + overhang;
    compartment_height = inner_height + overhang + standoff_height + pizza_saver_height;
    
    //color([0.5,0.5,0,0.8]);
    
    ScrewHole(w*2 - thickness, threaded_section_height, pitch=pitch, tooth_angle=tooth_angle, tolerance=1) { 
        difference(){
            domed_cylinder(h,w+t);
            translate([0, 0, compartment_height ]) battery_pack();
            cylinder(compartment_height, w-1, w-1);
        }
    } 
    
}

module sensor_holes(h){
    hole_radius = 16/2 * 1.01;
    hole_distance = 23.75;
    f = 1.05;
    $fn = 150;
    
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
    hull() translate([0, 0, -3.5]) standoffs(2, 2, 10, sensor_height-3);
}

module domed_cylinder(h,w){
    $fs=3; // Don't set this to less than 1 unless you enjoy freezing OpenSCAD
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
