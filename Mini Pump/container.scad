/*

Mini Pump
=========

*/

$fn = 20;

use <threads.scad>

// Parts
render_outer_shell = 1;
render_brain = 1;
brain_type = "pump";  // distance, temperature_humidity, or soil_moisture


// Adjustable dimensions
thickness = 1;       // Thickness of wall.  Recommend 1mm to make room for threads
width = 27;          // Outer radius.  With 1mm thick walls, the inside radius becomes 25mm
dome_height = 8;     // Controls "Roundness" of shell
overhang = 4;        // Extra shell height to allow for a bit of overhang
tolerance = 0.3;     // Can be adjusted if threads don't fit together
fit_tolerance = 0.6; // Can be adjusted if inner shell doesn't fit
seal_padding = 0.5;  // Extra padding to allow annular seal to fit


// Non-adjustable dimensions
battery_pack_height = 95;
pitch = 2.8;
tooth_angle = 50;
seal_height = 6;
board_width = 28;
board_depth = 5;
thread_offset = 1.2;
sled_offset = 10;

// Note that while the board_height is 64mm, it goes through the 6mm "seal" and sticks about 3mm 
// into the battery pack.  So the total height of the brain ends up being 55mm.
board_height = 64;
    
// Height of inner "brain" compartment.  This needs to be a standard height so that shells are all
// compatible with one another.  
brain_height = 58; 


// The outer shell height should add up to the total height of all components smooshed together
height = battery_pack_height 
    + brain_height 
    + seal_height
    + overhang;

offset = width * 2.25;
if (render_brain) translate([0, 0, 0]) brain();
if (render_outer_shell) translate([offset, 0, 0]) outer_shell();

module brain() {
    if (brain_type == "pump") pump();
}

module pump() {
    
    h = seal_height;
    w = width;
    
    r1 = 27/2;
    r2 = 5;
    r3 = 1;
    
    d = 31.56; // distance apart

    difference() {
        seal();
        translate([-4, 0]) {
            cylinder(10, r=r1);
            translate([0, -d/2, 0]) cylinder(10, r=r3);
            translate([0, d/2, 0]) cylinder(10, r=r3);
        }
        translate([17, 0]) cylinder(10, r=r2);
    }
}

module seal(){
    t = thickness;
    w = width - t*2;
    ScrewThread(w*2 + thread_offset, seal_height, pitch=pitch, tooth_angle=tooth_angle, tolerance=tolerance);
}
 
module outer_shell(){
    h = height;
    t = thickness;
    w = width - t*2;
    
    total_height = height + dome_height;
    threaded_section_height = seal_height + overhang;
    
    difference() {
        translate([0, 0, total_height]) rotate([0, 180]) ScrewHole(w*2 + thread_offset, threaded_section_height, pitch=pitch, tooth_angle=tooth_angle, tolerance=tolerance) { 
            difference(){
                domed_cylinder(h,w + t*2);
                domed_cylinder(h-t,w);
            }
        }
        cylinder(10, r=12.9/2);
        translate([w - t*2, 0, h-53]) rotate([0, 90]) cylinder(10, r=6);
    }
}

module clips(height, width) {
    x = height / 2;
    y = width / 2;
    
    union() { 
        translate([x, y]) clip();
        translate([x, -y]) rotate([0, 0, 180])  clip();
        translate([-x, y]) clip();
        translate([-x, -y]) rotate([0, 0, 180])  clip();
    }
}

module clip() {
    translate([-2, 0]) rotate([90, 0, 90]) linear_extrude(4) polygon([[2,9],[1,10],[-2,9],[-2,8],[-1,8],[0,7],[-1,6],[-1,-2],[1,-2]]);
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
