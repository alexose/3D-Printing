use <threads.scad>;

number_of_cells = 3;
distance_apart = 11;
plate_radius = 21.6;

// number_of_cells = 5;
// distance_apart = 18;
// plate_radius = 30;

$fn = 60;
plate_height = 4;
thread_height = plate_height*2;
tolerance = 0.3;
cell_height = 65;
cell_radius = 18 / 2 + tolerance;
hole_radius = 2.2;

render_plate = 1;
render_cap_with_ring_cutout = 0;
render_cap_with_hole = 0;
render_cap = 1;
render_tube = 1;

if (render_plate) plate();
if (render_cap_with_ring_cutout) translate([-plate_radius*2 - 3, 0]) cap_with_ring_cutout();
if (render_cap_with_hole) translate([-plate_radius*2 - 3, 0]) cap_with_hole();
if (render_cap) translate([-plate_radius*2 - 3, 0]) cap();
if (render_tube) translate([plate_radius*2 + 3, 0]) tube();

module plate() {
    p = distance_apart;
    h = plate_height;
    tab_radius = 6;
    
    difference() {
        union() {
            lip();
            radial_multiply(p) tab();
            cell_spacers();
        }
        union() {
            cylinder(30, r=hole_radius);
        }
    } 
 
    module tab() {
        r = tab_radius;
        th = h - 1; // Tab height
        w = 0.75; // Wire radius
        c = 5; // Cutout width.  This is the bit that needs to be bridged.
        bt = 0.6; // Bridge thickness
        bd = 3; // Bridge depth
        
        
        difference(){
            cylinder(th,r=r);
            r1 = r*2;
            translate([0, c/2, 0]) rotate([90, 0]) cylinder(c, r=r1);
        }
        translate([0, 0, th - bt/2]) cube([bd, r, bt] , center=true);
        
    }

    module cell_spacers() {
        hs = 20;
        rr = 2;
        difference() {
            scale([1, 1, 0.25]) hull() cells(0.1);
            r = 18 / 2;
            union() {
                cells(0.15);
                translate([0, 0, h/2]) cylinder(hs, r=5);
            }
        }   
    }

    module torus(r, d) {
      $fn=50;
      rotate_extrude(convexity=10) {
        translate([r,0,0]) circle(d);
      }
    } 
    
    
    module lip() {
       // Create lip so that it's easier to pry out the plate with your fingernail
        difference() {
            cylinder(h/2, r=plate_radius);
            

            translate([0, 0, h/4]) difference() {
                hull() cells(7);       
                hull() cells(3);
            }
            
             // Cutout to give us a little more room
            radial_multiply(p) translate([0, 0, 0]) cylinder(3, r = tab_radius);

        }
    }
}

module cap_with_hole() {
    difference() {
        cap();
        cylinder(10, r=hole_radius);
    }
}

module cap(bottom_padding = 0) {
    t = 1.4; // thickness
    h = thread_height + t;
    r = plate_radius + tolerance + t;
    f = tolerance; // tolerance fudge factor for plate
    b = bottom_padding;
    
    translate([0, 0, t + b]) ScrewHole(r*2 + f, thread_height, pitch=3, tooth_angle=55) {
        translate([0, 0, -t - b]) rounded_cylinder(r=r+t,h=h+b,n=1,$fn=60);
    }
    
    module rounded_cylinder(r,h,n) {
      rotate_extrude(convexity=1) {
        offset(r=n) offset(delta=-n) square([r,h]);
        square([n,h]);
      }
    }
}

module cap_with_ring_cutout() {
    bw = 28;
    bd = 5;
    bh = 65;
    radius = 1;
    offset = 5; // Gives a little extra room for cubecell
    
    difference() {
        cap(3);
        translate([0, offset, -bh/2 + 3]) scale(1.02) roundedcube([bw, bd, bh], radius=radius, true);
        cylinder(10, 2, 2);
    }

}

module tube() {
    t = 1.4; // thickness
    f = tolerance;
    
    ph = plate_height/2;
    h = thread_height - ph;
    
    mh = cell_height - (ph * 2) - h; // Middle section height
    
    r = plate_radius + tolerance + t;
 
    difference() {
        union(){
            ScrewThread(r*2 + f, h, pitch=3, tooth_angle=45);
            translate([0, 0, h]) middle_section();
            translate([0, 0, h + mh]) ScrewThread(r*2 + f, h, pitch=3, tooth_angle=55);
        }
        hull() cells(0.92);
    }
    
    module middle_section() {
        r = 10 + t;  // 11.5 diameter
        p = distance_apart;
        r1 = plate_radius + t;
        r2 = r1 - 15;
        
        cylinder(mh, r1, r2);
        hull() radial_multiply(p) cylinder(mh, r=r);
        translate([0, 0, mh]) rotate([0, 180]) cylinder(mh, r1, r2);
    }
}

module cells(tolerance=0.3) {
    r = cell_radius;
    p = distance_apart;
    h = cell_height + plate_height;
    radial_multiply(p) cylinder(h, r=r + tolerance);
}

module radial_multiply(distance_apart) {
    p = distance_apart;    
    step =  360 / number_of_cells;
    
    for (i = [0 : step : 360 ]) {
        translate([p, 0]) children(0);
        rotate([0, 0, i]) translate([p, 0]) children();
        rotate([0, 0, i]) translate([p, 0]) children();
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
