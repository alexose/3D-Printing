width = 162;
height = 73;
depth = 76;
thickness = 1.6;
roundness = 5;
fit_tolerance = 0.5;

lid_depth = depth * 0.3;

battery_pack_radius = 25;
battery_pack_height = 75; 
space_between_batteries = 50;

board_standoff_distance_x = 45;
board_standoff_distance_y = 66;
board_standoff_height = 50;

button_hole_radius = 8.4;
window_radius = 3.5;
distance_between_button_and_window = 27;

//translate([0, height/2 + thickness]) slice() shell();
//translate([0, - height/2 - thickness]) slice() lid();
window();


module window() {
    f = 0.1;
    $fn = 50;
    t = thickness;
    r = window_radius;
    difference(){ 
        union() {
            cylinder(t, r=r + f);
            translate([0, 0, t]) cylinder(t+f, r=r - f*4);
            translate([0, 0, t*2+f]) cylinder(t, r=r);
        }
        translate([0, 0, t*2+f]) cube([t, 10, t*2 + f*2], center=true);
    }
    

}

module lid() {
    f = fit_tolerance;
    t = thickness;
    
    w1 = width + t*2 + f;
    h1 = height + t*2 + f;
    d1 = lid_depth;
    
    w2 = w1 - t*2;
    h2 = h1 - t*2;
    d2 = d1 - t*2;
    r = roundness;
    s = space_between_batteries/2 + battery_pack_radius + t*2;
    
    r2 = button_hole_radius;
    o = distance_between_button_and_window / 2;
    
    r3 = battery_pack_radius + t + f + f;
    
    union() {
        translate([0, 0, d1/2]) difference() { 
            roundedcube([w1, h1, d1], center=true, radius=r);
            roundedcube([w2, h2, d2], center=true, radius=r);
            translate([0, 0, d1/2]) cube([w1,h1,r*2], center=true);
            

            // Button hole
            translate([o, 0, -d1/2]) cylinder(t*2, r=button_hole_radius);
        
            // LED window
            translate([-o, 0, -d1/2]) cylinder(t*2, r=window_radius);
        
            // Text
            translate([0, 0, -d1/2]) branding();
        
        }
        translate([-s, 0, t]) battery_holder(13, r3, true);
        translate([s, 0, t]) battery_holder(13, r3, true);
     }
}

module branding() {   
    translate([76, 13, -0.1]) linear_extrude(0.8) rotate([0, 180]) text("Fill-o-tron 9000", size=15, font="DejaVu Sans:style=bold");
    translate([-20, -25, -0.1]) linear_extrude(0.8) rotate([0, 180]) text("By OSELABS", size=6, font="DejaVu Sans:style=bold");;
}

module shell() {
    r = roundness;
    t = thickness;
    
    w1 = width;
    h1 = height;
    d1 = depth + r + t*2;

    w2 = w1 - t*2;
    h2 = h1 - t*2;
    d2 = d1 - t*2;
    
    x = board_standoff_distance_x;
    y = board_standoff_distance_y;
    z = board_standoff_height;

    s = space_between_batteries/2 + battery_pack_radius + t*2;
    
    difference() {
        union() {
            translate([0, 0, d1/2]) difference() { 
                main_shape();
                translate([0, 0, d1/2]) cube([w1,h1,r*2], center=true);
                translate([0, 0, -d1/2]) solenoid_hole();
            }
            
             intersection() {
                translate([0, 0, d1/2]) roundedcube([w1, h1, d1], center=true, radius=r);
                union() {
                    translate([-s, 0, t]) battery_holder();
                    translate([s, 0, t]) battery_holder();
                }
             }
            solenoid_standoffs(1, t - .8);
         }
         solenoid_standoffs(-1, t);

    }
    
    translate([0, 0, t]) {
        intersection() {
             translate([0, 0, 50]) roundedcube([w1, h1, 100], center=true, radius=r);
            difference() {
                standoffs(4, z, x, y);
                standoffs(1, z, x, y);
            }
        }
    }
    
    module main_shape() {
        th = height;
        tw = 19;
        tl = 18;
        to = 7;
        $fn = 80;
        difference() {
            roundedcube([w1, h1, d1], center=true, radius=r);
            roundedcube([w2, h2, d2], center=true, radius=r);
            translate([0, th/2, -th/2 - tw/2 - to]) rotate([90, 0]) cylinder(tl, r=tw-t/2);
            translate([0, -th/2 + tl, -th/2 - tw/2 - to]) rotate([90, 0]) cylinder(tl, r=tw-t/2);
        }  
        
        intersection() {
            difference() {
                union() {
                    translate([0, th/2, -th/2 - tw/2 - to]) rotate([90, 0]) cylinder(tl, r=tw);
                    translate([0, -th/2 + tl, -th/2 - tw/2 - to]) rotate([90, 0]) cylinder(tl, r=tw);
                }
                translate([0, th/2 + t, -th/2 - tw/2 - to]) rotate([90, 0]) cylinder(tl, r=tw-t/2);
                translate([0, -th/2 + tl - t, -th/2 - tw/2 - to]) rotate([90, 0]) cylinder(tl, r=tw-t/2);
            }
            roundedcube([w1, h1, d1], center=true, radius=r);
        }

    }
}



module slice() {
    // Something about the roundedcube math is off, requires us to cut off the bottom
    // to make sure everything is even
    r = roundness;
    w = width;
    h = height;
    
    difference() {
        union() children();
        translate([0, 0, -r + 0.1]) cube([w,h,r*2], center=true);
    }   
}
    
module battery_holder(h=battery_pack_height, r=battery_pack_radius + fit_tolerance, cutout=false) {
    $fn = 60;
    t = thickness;
    w = 20;
    f = fit_tolerance;
    
    difference() {
        cylinder(h, r=r+t+f);
        cylinder(h+t, r=r+f);
        if (cutout) cube([r*3, 45, h*2+t], center=true);
    }
}

module solenoid_standoffs(radius_offset=0, t=thickness) {
    // The solenoids I use have four screws holding them together.  This design makes use
    // of those screws, and allows you to poke them through the shell for a secure fit.
    distance_between_screw_holes = 25;
    screw_hole_radius = 3 + radius_offset;
    
    h = distance_between_screw_holes;
    r = screw_hole_radius;
    
    scale([1, 1, 2]) standoffs(r, t, h, h);
}

module solenoid_hole() {
    hull() solenoid_standoffs(-1);
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
