use <threads.scad>

thruster_length=86;
thruster_radius=75/2;
thruster_elongation_factor=2;
wall_thickness=2;
handle_height = 160;
tube_radius = 30;
tube_length = 100;
$fn = 25;


difference() {
    union() {
        base();
        tube();
        top();
    }
    wire_tunnel();
    // for fit test: translate([0, 0, 165]) cube(200, true);
}

// cap();


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

module top() {
    r = tube_radius;
    t = wall_thickness / 2;

    h = 10;
    h2 = 7; // screw thread height
    
    translate([100,0]){
        ScrewThread(r*2+t*2, h2, pitch=2.8, tooth_angle=45) cylinder(h2,r=r+t*2);    
        translate([0, 0, h2]) hull() {    
            cylinder(h, r=r+t);
            translate([0, 0, h+r]) cylinder(h, r=r*2);
        }
    }
        
}

module tube() {
    
    h = tube_length * 2;
    r = tube_radius;
    t = wall_thickness / 2;
    battery_pack_height = 73;
    battery_pack_radius = 25 + 0.6;
    bh = battery_pack_height;
    br = battery_pack_radius;
    
    
    h2 = 7; // screw thread height
    o = 5; // camfer size
  
    translate([0, 100, 0]) {
        difference() {
            union() {
                translate([0, 0, 0]) ScrewHole(r*2+t*2, h2, pitch=2.8, tooth_angle=45) cylinder(h2,r=r+t*2);
                translate([0, 0, h2]) cylinder(h,r=r+t*2);
                translate([0, 0, h+h2]) ScrewHole(r*2+t*2, h2, pitch=2.8, tooth_angle=45) cylinder(h2,r=r+t*2);

            }
            translate([0, 0, h2]) cylinder(h,r=r);
        }
    }
}

module cap() {

    h = top_length;
    r = top_radius;
    t = wall_thickness / 2;
    h2 = 7; // screw thread height
    o = 27; // camfer size
    e = 20; // extra space

    translate([0, 70]) {
        difference() {
            ScrewHole(r*2+t*2, h2, pitch=2.8, tooth_angle=45) union() {
                cylinder(e, r=r+t*2);
                translate([0, 0, e]) camfered_cylinder(h2+t,r+t*2, o);
            }
            cylinder(e, r=r);
            translate([0, 0, e-t]) camfered_cylinder(h2+t,r, o);
        }
        
    }
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
        translate([0,0,i*f*1.3]) hull() {
            f = sin(i*5);
            translate([0, l/3 - f * 26, r]) sphere(r2 + f*10);
            translate([0, -l/3 + f * 26, r]) sphere(r2 + f*10);
        }
    }
    
    translate([0,0,230]) hull() {
        sphere(r2*2.1);
        translate([0,0,30]) cylinder(1, r=27);
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
