$fn = 100;
fudge_factor = 1.05;

battery_length = 66 * fudge_factor;
battery_diameter = 18 * fudge_factor;

wall_thickness = 1.2;

wire_diameter = 2;
wire_height = 2;

tray_length = battery_length + wall_thickness * 2;
tray_width = battery_diameter + wall_thickness * 2;
tray_depth = tray_width;
tray_radius = 2;

// shorthand
bl = battery_length;
bd = battery_diameter;
tl = tray_length;
tw = tray_width;
td = tray_depth;
tr = tray_radius;
t = wall_thickness;
wd = wire_diameter;
wh = wire_height;


translate([bl/2 + t, 0, bd/2 - t/2]) rotate([180, 180]) cap();
translate([-bl/2 - t, 0, bd/2 - t/2]) cap();


difference(){ 
    hull(){
        roundedcube([tl, tw, tr*2], radius=tr, center=true);
        rotate([0, 90, 0]) translate([-bd/2 + tr - t, 0, -bl/2 - t*2]) cylinder(bl + t*4, d=bd + t*2);
    }
    union() {
        translate([0, 0, bd]) cube([tl + t*4, tw, td/2], center=true);
        
        // Battery compartment
        rotate([0, 90, 0]) translate([-bd/2, 0, -bl/2 - t*2]) cylinder(bl+t*4, d=bd);

    }
}



module cap() {
  groove_width = 6;
  groove_diameter = 30;
  holder_height = 2;
  holder_depth = 0.8;
  gd = groove_diameter;
  gw = groove_width;
  hh = holder_height;
  hd = holder_depth;
          

  difference() {
  
      translate([-t, 0]) {
          difference(){
              rotate([0, 90, 0]) cylinder(t*2, d=bd + t*2);  
              rotate([90, 90, 0]) translate([0, gd/2 + t, -gw/2]) cylinder(gw, d=gd);
          }
          translate([t*2 - hd/2, 0]) cube([hd, bd-2, hh], true);
      }
      
      // Hole for wire to poke out
      rotate([0, 90, 0]) translate([5, 0, -bl/2 - 5]) cylinder(bl + 10, d=wd);
    }
}


// via https://danielupshaw.com/openscad-rounded-corners/
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