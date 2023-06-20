/*

Dorothy Sensor
==============

(see also: Dorothy Hub)

The Dorothy Sensor Platform consists of four parts:

  1. Brain: A threaded disc on which the sensor and and CubecCell board is mounted
  2. Battery Pack:  Three 18650 cells placed in a Cylindrical Battery Holder (see: https://www.thingiverse.com/thing:6080710)
  3. Outer Shell: The threaded cylinder that covers the whole assembly and protects it from the elements
  4. Inner Shell (optional):  A hollow cylinder that fits around the Brain and helps snug everything in place

The Brain can come in many different shapes, depending on the type of sensor(s) you want to use.
This file includes variations for:

* US-100 ultrasonic sensor
* DHT22 temperature and humidity sensor
* Catnip Eletronics' soil moisture sensor (https://www.tindie.com/products/miceuz/i2c-soil-moisture-sensor/)

With more on the way!

*/


use <threads.scad>

// Parts
render_outer_shell = 1;
render_inner_shell = 1;
render_brain = 1;
brain_type = "us100";  // us100, dht22, or soil_moisture


// Adjustable dimensions
thickness = 2;       // Thickness of wall.  Recommend 2mm to make room for threads
width = 27;          // Outer radius.  With 2mm thick walls, the inside radius becomes 25mm
dome_height = 8;     // Controls "Roundness" of shell
overhang = 4;        // Extra shell height to allow for a bit of overhang
tolerance = 0.3;     // Can be adjusted if threads don't fit together
fit_tolerance = 0.6; // Can be adjusted if inner shell doesn't fit


// Non-adjustable dimensions
brain_height = 30; // Height of inner "brain" compartment
battery_pack_height = 83;
pitch = 2.8;
tooth_angle = 50;
seal_height = 6;

height = battery_pack_height 
    + brain_height 
    + seal_height
    + overhang;

offset = width * 2.25;
if (render_brain) translate([0, 0, 0]) brain();
if (render_outer_shell) translate([offset, 0, 0]) outer_shell();
if (render_inner_shell) translate([0, offset, 0]) inner_shell();

module brain() {
    if (brain_type == "us100") brain_us100();
    if (brain_type == "dht22") brain_dht22();
    if (brain_type == "soil_moisture") brain_soil_moisture();
}

module brain_us100() {
    seal();
}
module brain_dht22() {
    seal();
}

module brain_soil_moisture() {
    seal();
}

module seal(){

    ScrewThread(width*2 - thickness, seal_height, pitch=pitch, tooth_angle=tooth_angle, tolerance=tolerance);
}
 
module outer_shell(){
    h = height;
    w = width;
    t = thickness/2;
    
    $fn=150;

    total_height = height + dome_height;
    threaded_section_height = seal_height + overhang;
    
    translate([0, 0, total_height]) rotate([0, 180]) ScrewHole(w*2, threaded_section_height, pitch=pitch, tooth_angle=tooth_angle, tolerance=1) { 
        difference(){
            domed_cylinder(h,w + t*2);
            domed_cylinder(h-t,w);
        }
    }
}

module inner_shell(){
    h = brain_height;
    w = width - thickness - fit_tolerance;
    
    $fn=150;
    
    
    
    difference(){
        cylinder(h,r=w);
        cylinder(h,r=w - thickness);
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
    c = dome_height * 2;
    // translate([0, 0, h]) scale([1,1,0.5]) sphere(w);

    difference(){ 
        union(){ 
            translate([0, 0, h]) scale([1, 1, 0.5]) sphere(w); // Flattened sphere
            cylinder(h, w, w);
        }
        translate([0, 0, h+c]) cube([w*2, w*2, c], center=true);  // Cutoff
    }
 }
