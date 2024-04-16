// Nitrate sensor
//
// This is housing for an optical nitrate sensor that's meant to hang out underwater.
//
// There are two main parts:  The emitter module and the photodiode module.
// Both sit behind quartz discs that allow UV light to pass through.

quartz_radius = 10 + 0.3; // Radius of quartz disc, plus a bit extra for tolerance
quartz_thickness = 0.8; // Thickness of quartz disc
wall_thickness = 1.2;
gap_distance = 20; // Gap between emitter and photodiode
extra_height = 3;
base_height = 3; // Height of base
compartment_height = 20; // Height of compartment (enough to fit electronics)

x = 100/2;
y = 63/2;

r = quartz_radius;
t = wall_thickness;
g = gap_distance;
$fn = 50;

 translate([0, 0, base_height]) difference() {
    base();
    carveout();
    emitter_negatives();
}

union() {
    h = compartment_height;
    translate([0, x +  20, h]) {
        difference() {
            compartment(1, h);
            translate([0, 0, 1]) compartment(0, h);
            screw_holes(h, 2);
        }
        translate([0, 0, 0]) difference() {
            screw_holes(h-1, 3);
            screw_holes(h-1, 1);
        }
    }  
}
 
module base() {
    r = 25;
    h = base_height;
    p = 15;

    
    difference() {
        hull() {
            compartment();
            translate([0, 0, -1]) emitters(5, 5);
        }
        // compartment(-1);
        translate([0, 0, -1]) difference() {
            scale([0.85, 0.8, 1]) hull() {
                 compartment();
                 emitters(-5);
            }
            hull() {
                scale([1.3, 1, 1]) carveout();
                translate([0, 0, -100]) scale([1.3, 100, 1]) carveout();
            }
        }
         
        translate([gap_distance/2 + 5, 0, 13]) cube([2,27,14], true);
        translate([0, 0, -1]) screw_holes(h-1, 0.8);
        
        translate([gap_distance/2 + 1, 12, 0]) rotate([0, 90, 0]) cylinder(10, r=1);
        translate([gap_distance/2 + 1, -12, 0]) rotate([0, 90, 0]) cylinder(10, r=1);
        translate([-gap_distance/2 - 1, 12, 0]) rotate([0, 270, 0]) cylinder(10, r=1);
        translate([-gap_distance/2 - 1, -12, 0]) rotate([0, 270, 0]) cylinder(10, r=1);
    }
}

module compartment(o=0, h=base_height) {
    r = 2;
    translate([0, 0, -h]) linear_extrude(h) {
        hull() offset(o) {
            translate([x, y]) circle(r);
            translate([-x, y]) circle(r);
            translate([x, -y]) circle(r);
            translate([-x, -y]) circle(r);
        }
    }
}

module screw_holes(h, r=2) {
    translate([0, 0, -h]) linear_extrude(h) {
        union() {
            translate([x, y]) circle(r);
            translate([-x, y]) circle(r);
            translate([x, -y]) circle(r);
            translate([-x, -y]) circle(r);
        }
    }
}

module carveout() {
    h = gap_distance;
    r = r-2;
    hull() translate([-h/2, 0, 8]) {
        rotate([0, 90, 0]) scale([1,3,1]) cylinder(h, r=r);
        translate([0, 0, 16]) rotate([0, 90, 0]) scale([1,3,1]) cylinder(h, r=r);
    }
    translate([0, 0, 105]) cube([h, 200, 200], true);
}



module emitters(extra_distance=0, extra_radius=0) {
    translate([0, 0, extra_height]) {
        emitter_housing(extra_distance, extra_radius);
        mirror([1, 0, 0]) emitter_housing(extra_distance, extra_radius);
    }
}

module emitter_negatives() {
    translate([0, 0, extra_height-1]) {
        emitter_housing_cutouts();
        mirror([1, 0, 0]) emitter_housing_cutouts();
    }
}

module emitter_housing(extra_distance, extra_radius) {
    h1 = 10; // body height
    h2 = 1.5; // cap height
    h3 = quartz_thickness;

    translate([-h1-h2-g+extra_distance/2, 0, r+t]) rotate([0, 90]) {
        hull() {
            cylinder(h1, r=r+t);
            translate([0, 0, h1]) cylinder(h2, r=r+t - 0.5 + extra_radius);
        }
    }
}

module emitter_housing_cutouts(h1=10, h2=1.5, h3=quartz_thickness) {
    h1 = 10; // body height
    h2 = 1.5; // cap height
    h3 = quartz_thickness;

    translate([-h1-h2-g/2, 0, r+t]) rotate([0, 90]) {
        cylinder(h1, r=r);
        translate([0, 0, h1]) cylinder(h2, r=r-2);
        translate([0, 0, h1+h2-h3]) cylinder(h2, r=r);
    }
}
