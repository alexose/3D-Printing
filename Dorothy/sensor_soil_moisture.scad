use <threads.scad>


$fn=30;

render_top = true;
render_bottom = false;
render_pizza_saver = false;
render_battery_pack = false;
render_board_standoffs = false;

// Dimensions
width = 28;
thickness = 2;

inner_height = 6;
overhang = 4;

board_width = 36.8;
board_height = 19.1;

sensor_width = 10;
sensor_height = 60;
sensor_depth = 4;

standoff_thickness = 2.5;

battery_pack_height = 75;
standoff_height = 10;
pizza_saver_height = 17;
dome_height = 17;

tolerance = 0.2; // adjust if threads don't fit together
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
if (render_board_standoffs) translate([0, -100, 0]) board_standoffs();

module board_standoffs() {
    difference() {
        standoffs(4.5/2, 8, 5, 5);
        standoffs(2.5/2, 8, 5, 5);
    }
}

module bottom_piece(){
    h = inner_height;
    w = width;
    
    sw = sensor_width;
    sh = sensor_height;
    sd = sensor_depth;
    
    vt = standoff_thickness;
    vh = standoff_height;

    bw = 42;
    bd = 5;
    bh = 50;
    
    cutout_tolerance = 0.4;
   
    
    difference() {
        union() {
            radius = 1;
            translate([-bw / 2, -bd, h - radius]) roundedcube([bw, bd, bh], radius=radius);
            translate([0, 7]) ScrewThread(w*2 - thickness, h, pitch=pitch, tooth_angle=tooth_angle, tolerance=tolerance); 
        }
        union() {
            // Extra cutout to give space for chips
            hull() {
                translate([0, -2, 12]) roundedcube([12, 2.5, 40], true); 
                translate([0, -2, 32]) rotate([0, 45]) roundedcube([8.5, 2.5, 8.5], true);
            }

            translate([0, 0, -22.5]) rotate([90, 0, 0]) scale([1, 1, 0.7])  minkowski() {
                import("centered-sensor.stl");
                cylinder(1, cutout_tolerance, cutout_tolerance);
            }
            translate([0, -2, 30]) rotate([90, 0, 0]) standoffs(1, 3, 18.92, 36.71);
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
    
    ScrewHole(w*2 - thickness, threaded_section_height, pitch=pitch, tooth_angle=tooth_angle, tolerance=1) { 
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
    h = battery_pack_height;
    r = 25;
    cylinder(h, r=r);
}

module battery_18650() {
    cylinder(65, 9, 9);
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
