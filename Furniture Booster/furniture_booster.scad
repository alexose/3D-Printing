// Furniture Booster - measurements in mm

// Leg type: "round" or "square"
leg_type = "round";

// Round leg cavity settings
cavity_base_diameter = 32;
cavity_top_diameter = 34;

// Square/rectangular leg cavity settings
cavity_base_width = 32;   // X dimension at bottom
cavity_base_length = 32;  // Y dimension at bottom
cavity_top_width = 34;    // X dimension at top (slight taper for easy fit)
cavity_top_length = 34;   // Y dimension at top
corner_radius = 2;        // Radius for rounded corners (0 for sharp corners)

// Common settings
cavity_depth = 10;

// Main body
thickness = 5 / 2;
// For round legs
base_diameter = cavity_base_diameter + thickness;
top_diameter = cavity_top_diameter + thickness;
// For square legs
base_width = cavity_base_width + thickness * 2;
base_length = cavity_base_length + thickness * 2;
top_width = cavity_top_width + thickness * 2;
top_length = cavity_top_length + thickness * 2;

booster_height = 25.4 * 1.75;

// Angle settings
back_leg_angle = 15;

$fn = 100;

// Rounded rectangle module
module rounded_rect(w, l, r) {
    if (r > 0) {
        offset(r) square([w - 2*r, l - 2*r], center = true);
    } else {
        square([w, l], center = true);
    }
}

// Module for creating a riser with optional angle
module riser(o = 0) {
    if (leg_type == "round") {
        // Round leg riser
        difference() {
            cylinder(h = booster_height, d1 = base_diameter, d2 = top_diameter);

            translate([0, -o, booster_height - cavity_depth])
                hull() {
                    linear_extrude(0.1) circle(cavity_base_diameter / 2);
                    translate([0, 0 + o, cavity_depth]) linear_extrude(0.1) circle(cavity_top_diameter / 2);
               }
        }
    } else {
        // Square/rectangular leg riser
        difference() {
            // Outer body - tapered rectangular prism with rounded corners
            hull() {
                linear_extrude(0.1) rounded_rect(base_width, base_length, corner_radius);
                translate([0, 0, booster_height])
                    linear_extrude(0.1) rounded_rect(top_width, top_length, corner_radius);
            }

            // Inner cavity - tapered rectangular hole
            translate([0, -o, booster_height - cavity_depth])
                hull() {
                    linear_extrude(0.1) rounded_rect(cavity_base_width, cavity_base_length, corner_radius);
                    translate([0, 0 + o, cavity_depth])
                        linear_extrude(0.1) rounded_rect(cavity_top_width, cavity_top_length, corner_radius);
               }
        }
    }
}



// Front legs (straight)
riser();

// Back legs (offset)
translate([40, 0, 0]) riser(1.5);