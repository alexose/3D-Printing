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
render_outer_shell = 0;
render_inner_shell = 1;
render_brain = 1;
brain_type = "soil_moisture";  // us100, dht22, or soil_moisture


// Adjustable dimensions
thickness = 2;       // Thickness of wall.  Recommend 2mm to make room for threads
width = 27;          // Outer radius.  With 2mm thick walls, the inside radius becomes 25mm
dome_height = 8;     // Controls "Roundness" of shell
overhang = 4;        // Extra shell height to allow for a bit of overhang
tolerance = 0.3;     // Can be adjusted if threads don't fit together
fit_tolerance = 0.6; // Can be adjusted if inner shell doesn't fit
seal_padding = 0.5;  // Extra padding to allow annular seal to fit


// Non-adjustable dimensions
brain_height = 55; // Height of inner "brain" compartment
battery_pack_height = 83;
pitch = 2.8;
tooth_angle = 50;
seal_height = 6;
inner_shell_width = width - thickness - seal_padding - 1;

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

// The soil moisture sensor must be mounted vertically.  To make this work, the 'brain' is separated
// into two pieces that snap together:  The bottom piece (referred to as 'seal' in this code)

module brain_soil_moisture() {
    h = seal_height;
    w = width;

    bw = 28;
    bd = 5;
    bh = 55;
    
    cutout_tolerance = 0.4;
    cutout = 8.5;
    t = 2.5;
    
    radius = 1;
    
    ww = 6;
    wd = 8;
    f = fit_tolerance;
    
    rotate([90, 0]) translate([0, bd/2, 0]) difference() {
        sled();
        union() {
        
            // Sensor cutout, with a little extra tolerance
            translate([0, 2.5, -50]) rotate([90, 0, 0]) scale([1, 1, 0.7])  minkowski() {
                import("soil_moisture_sensor.stl");
                cylinder(1, cutout_tolerance, cutout_tolerance);
            }
            
            // Extra cutout to give space for chips
            translate([0, 1, -8.5]) roundedcube([12, t+2.5, 30], true); 
        }
    }

    translate([-w*2, 0]) difference() {
        seal();
        offset = 5; // Gives a little extra room for cubecell
        voffset = 2.52; // Fudged this... room for improvement here
        
        translate([0, offset, bh/2 - voffset]) scale(1.02) sled();
    } 
    
    module sled() {
        difference() {
            union() {
                roundedcube([bw, bd, bh], radius=radius, true);
                translate([bw/2, 0, -bh/2 + bd]) roundedcube([wd, bd, ww], radius=radius, true);
                translate([-bw/2, 0,  -bh/2 + bd]) roundedcube([wd, bd, ww], radius=radius, true);
            }
                        
            // Slice 3mm off bottom of roundedcube so that everything lines up nicely
            translate([0, 0, -bh+3]) cube([bw + wd * 2, bd, bh], true);
            translate([0, 0, 5]) rotate([90, 0, 0]) standoffs(1, 3, 18.92, 36.71);
        }
    }
}


module seal(){
    w = inner_shell_width;
    
    difference() {
        ScrewThread(width*2 - thickness, seal_height, pitch=pitch, tooth_angle=tooth_angle, tolerance=tolerance);
        translate([0, 0, seal_height]) rotate([0, 180]) linear_extrude(3) solid_circle(w);
    }
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
    w = inner_shell_width;
    
    $fn=100;
    
    twist = 80;
    bar = 5;
    
    linear_extrude(height=bar) solid_circle(w);
    translate([0, 0, bar]) {
        linear_extrude(height=h - bar*2, twist=twist) dotted_circle(w);
        linear_extrude(height=h - bar*2, twist=-twist) dotted_circle(w);
    }
    translate([0, 0, h-bar]) linear_extrude(height=bar) solid_circle(w);

}

module dotted_circle(w){
    $fn = 100;
    difference(){
        solid_circle(w);
        union() {
            num = 10;
            angle = 360/num;
            for (i = [0 : num - 1]) {
                rotate([0, 0, i * angle]) square([11.5, 60], center=true);
            }
        }
    }
}

module solid_circle(w,t=thickness) {
    $fn = 100;
    difference(){
        circle(r=w + t/4);
        circle(r=w - t/4);
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
 
 // More information: https://danielupshaw.com/openscad-rounded-corners/
module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
    $fs = 0.15;
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							sphere(r = radius);
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							rotate(a = rotate)
							cylinder(h = diameter, r = radius, center = true);
						}
					}
				}
			}
		}
	}
}