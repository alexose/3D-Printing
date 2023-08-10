use <threads.scad>

thruster_length=86;
thruster_radius=75/2;
thruster_elongation_factor=2;
wall_thickness=2;
handle_height = 160;
top_radius = 30;
top_length = 100;

$fn = 80;

/*
difference() {
    union() {
        base();
        top();
    }
    wire_tunnel();
    // for fit test: translate([0, 0, 165]) cube(200, true);
}
*/

// cap();
// translate([0, 27]) potentiometer_stalk();
extendo();

module base() {
    
    l = thruster_length;
    r = thruster_radius;
    e = thruster_elongation_factor;
    t = wall_thickness;
    o = 7;
    
    difference() {
        union() {
            nacelle(l,r,e,t);
            translate([0,0,-5]) handle();
        }
        nacelle(l,r,e,0);
        
        // Cut a slice so it can bend around the thruster for installation
        slice(o,r,t,l);
        
        // Screw holes
        o2 = -10;
        r2 = 3.5;
        r3 = 4;
        h2 = r + 8;
        
        translate([-o2-3, l/4, h2]) rotate([90,0, 90]) cylinder(3, r=r3, $fn=20);
        translate([-o2-3, -l/4, h2]) rotate([90,0, 90]) cylinder(3, r=r3, $fn=20);
        translate([-o2-3, 0, h2]) rotate([90,0, 90]) cylinder(3, r=r3, $fn=20);

        translate([o2, l/4, h2]) rotate([90,0, 90]) cylinder(3, r=r2, $fn=6);
        translate([o2, -l/4, h2]) rotate([90,0, 90]) cylinder(3, r=r2, $fn=6);
        translate([o2, 0, h2]) rotate([90,0, 90]) cylinder(3, r=r2, $fn=6);
        
        translate([o2, -l/4, h2]) rotate([90,0, 90]) cylinder(20, r=2, $fn=15);
        translate([o2, 0, h2]) rotate([90,0, 90]) cylinder(20, r=2, $fn=15);
        translate([o2, l/4, h2]) rotate([90,0, 90]) cylinder(20, r=2, $fn=15);
        
        // Cut off part that intersects with top
        translate([0, thruster_length/2, handle_height + top_radius*2 - 8]) rotate([90, 0]) 
            camfered_cylinder(top_length-t/2,top_radius-t/2,o);
        
        // Hole for annoying protrusion
        translate([0, 0, -thruster_radius - 1]) indentation();
    }
}



// TODO: make this nicer
module indentation() {
    fit_tolerance = 2;
    w = 10 + fit_tolerance;
    l = 50 + fit_tolerance - w;
    
    hull() {
        translate([0, l/2]) cylinder(10, r=w/2);
        translate([0, -l/2]) cylinder(10, r=w/2);
    }
}

module wire_tunnel() {
    h = handle_height;
    translate([0, -70]) rotate([-20, 0]) translate([0, 22, thruster_radius]) cylinder(h + 30, r=4.5);
}

// A watertight cylinder with room for a battery pack, ESC, and servo tester. Secured by a threaded cap

module top() {
    
    h = top_length;
    r = top_radius;
    t = wall_thickness / 2;
    battery_pack_height = 73;
    battery_pack_radius = 25 + 0.6;
    bh = battery_pack_height;
    br = battery_pack_radius;
    
    
    h2 = 7; // screw thread height
    o = 27; // camfer size
  
    translate([0, thruster_length/2, handle_height + top_radius*2 - 8]) rotate([90, 0]) {
        // Main compartment
        difference() {
            union() {
                ScrewThread(r*2+t*2, h2, pitch=2.8, tooth_angle=45);
                translate([0, 0, h2]) camfered_cylinder(h,r+t,o);
            }
            translate([0, 0, h-bh-t]) camfered_cylinder(bh,br,br-2);
            translate([0, 0, -1]) cylinder(h-bh+t, r-t, br); 
        }
    }
}

module extendo() {
    h = 20;
    r = top_radius;
    t = wall_thickness / 2;
    battery_pack_height = 73;
    battery_pack_radius = 25 + 0.6;
    bh = battery_pack_height;
    br = battery_pack_radius;
    
    
    h2 = 10; // screw thread height
    h3 = 12; // middle height
    // Main compartment
    translate([0, 0, h2 + h3]) ScrewHole(r*2+t*2, h2, pitch=2.8, tooth_angle=45) union() {
        cylinder(h2, r=r+t*2);
    }
    
    translate([0, 0, h2]) difference() {
        cylinder(h3, r=r+t*2);
        cylinder(h3, r=r-t); 
        
    }
    
    difference() {
        ScrewThread(r*2+t*2, h2, pitch=2.8, tooth_angle=45);
        cylinder(h2, r=r-t); 
    }
}

module cap() {

    h = top_length;
    r = top_radius;
    t = wall_thickness / 2;
    h2 = 7; // screw thread height
    o = 27; // camfer size
    e = 50; // extra space
    
    p = 3 + wall_thickness/2 + 0.3;

    translate([0, 70]) {
        difference() {
            ScrewHole(r*2+t*2, h2, pitch=2.8, tooth_angle=45) union() {
                cylinder(e, r=r+t*2);
                translate([0, 0, e]) camfered_cylinder(h2+t,r+t*2, o);
            }
            cylinder(e, r=r);
            translate([0, 0, e-t]) camfered_cylinder(h2+t,r, o);
            
            // Hole for potentiometer stalk
            translate([0, -20, 50]) rotate([90, 0]) cylinder(r, r=p);
        }
    }
}

module potentiometer_stalk() {
    fit_tolerance = 0.3;
    h = 12;
    ih = 6; // inner height
    ir = 5.95 / 2;
    or = 3 + wall_thickness/2;
    
    difference() {
        union () {
            cylinder(h, or, or);
            cylinder(10, r=or*2);
        }
        translate([0, 0, h-ih]) {
            difference() {
                cylinder(ih, r=ir);
                // translate([-10, 1.5 + fit_tolerance]) cube(100);
            }
        }
    }
    
    /*
    translate([20, 0]) difference() {
        cylinder(5, r=or*2);
        cylinder(ih, r=ir+fit_tolerance);
    }
    */
}

module camfered_cylinder(h,r,o) {
    union(){
        hull() {
            cylinder(h, r=r);
            translate([0,0,h]) cylinder(o, r=r-o);
        }
    }
}

module slice(o,r,t,l) {
    translate([r+o, 0, r - l/2 + 18]) difference() {
        cube(l, true);
        translate([t/4, 0, -t/4]) cube(l, true);
        translate([0,0,-l/2]) cube(l, true);
    }
}

module handle() {
    
    l = thruster_length;
    r = thruster_radius;
    e = thruster_elongation_factor;
    t = wall_thickness;
    h = handle_height;
    s = 15;
    
    r2 = 10;

    for (i = [0 : s]) {
        hull() {
            hulled_spheres(i, r, r2, l);
            hulled_spheres(i+2, r, r2, l);
        }
    }
    
    module hulled_spheres(i, r, r2, l){
        f = (h - r2) / s-1;
        translate([0,0,i*f]) hull() {
            f = sin(i*10);
            translate([0, l/3 - f * 8, r]) sphere(r2 - f*4);
            translate([0, -l/3 + f * 8, r]) sphere(r2 - f*4);
        }
    }
}


module nacelle(l, r, e, t) {
    difference() {
        scale([1,e,1]) sphere(r+t/2);
        
        // Cut off edges
        translate([0, l/2 + r]) cube(r*2, true);
        translate([0, -l/2 - r]) cube(r*2, true);
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
