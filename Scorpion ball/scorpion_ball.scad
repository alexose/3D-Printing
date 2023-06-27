use <threads.scad>

$fn=100;

pitch = 4;
tooth_angle = 55;
hole_size = 7;

thread_tolerance = 0.5;
cylinder_tolerance = 0.2;
r = 104 / 2;

t = r / 5; // shell thickness
th = 6; // threads height
tf = -4; // threads fudge factor. move the threads out a bit to give more room
gt = 3.5 / 2; // gasket cross-section thickness
gd = 93 / 2; // gasket diameter

ir = r - (t * 0.35); // inner sphere radius

eh = 4; // extra base height

render_inner_shell = 1;
render_outer_shell = 1;
render_bottom_half = 1;
render_wrench = 1;

if (render_outer_shell) rotate([180, 0]) translate([-r - t, 0, -r - th/2]) top_half_outer();
if (render_inner_shell) rotate([180, 0]) translate([-r - t, r*2, -r - th/2]) top_half_inner();
if (render_bottom_half) rotate([180, 0]) translate([r, 0, -r - th/2]) bottom_half();
if (render_wrench) translate([r*0.5, -r*1.7]) rotate([180, 180]) wrench();

module top_half_outer() {
    ScrewHole(r*2 - t - tf, th, pitch=pitch, tooth_angle=tooth_angle) {
        translate([0, 0, th]) difference() {
            difference(){
                union() {
                    translate([0, 0, r - t - eh]) base();
                    sphere(r);
                }
                translate([0, 0, -r - th]) cube(r*2, center=true);
            }
            union() {
                sphere(ir);
                translate([0,0,-gt*.2]) gasket_cutout();
                cylinder(r, r=hole_size + t/2 + cylinder_tolerance);
                translate([0, 0, r*2]) cube(r*2, center=true);
            }
        }   
    }             
}

module base() {
    hull() {
        cylinder(t+eh, r/2, r/2);
        translate([r/2, 0]) cylinder(t+eh, r/6, r/6);
        translate([-r/2, 0]) cylinder(t+eh, r/6, r/6);
    }
}


module wrench() {
    t2 = 14;
    difference() {
        union() {
            hull() { 
                cylinder(t+eh, r/2 + t2, r/2 + t2);
                translate([-r, 0]) cylinder(t+eh, r/3, r/3);
            }
            hull() {
                translate([-r, 0]) cylinder(t+eh, r/3, r/3);
                translate([-r*3, 0]) cylinder(t+eh, r/3, r/3);
            }
        }
        union() {
            translate([-r/8, 0, r + t]) scale(1.03) rotate([180, 0]) bottom_half();
            translate([-r/8, 0, 5]) base();
        }
    }
    
}

module top_half_inner() {
    translate([0, 0, th]) difference() {
        union() {
            difference(){
                sphere(ir);
                translate([0, 0, -r]) cube(r*2, center=true);
            }
            translate([0, 0, r - t]) cylinder(10, hole_size + t/2, hole_size + t/2);
        }
        union() {
            gasket_offset = -gt * 0.25; // Offset 25% of height for ideal fit
            sphere(r-t);
            translate([0,0,-gt*.2]) gasket_cutout();
            cylinder(r, hole_size, hole_size);
            // block off for gasket fit test
            // translate([0, 0, r - 16]) cube([r*2, r*2, r], center=true);
            // translate([0, 0, r - 75]) cube([r*2, r*2, r], center=true);     
        }
    }
}

module gasket_cutout() {
    difference() {
        cylinder(gt+1, gd, gd);
        cylinder(gt+1, gd-(gt*2), gd-(gt*2));
    }
}

module bottom_half() {
    o = 6; // offset
    translate([0, 0, o]) difference() {
        union() {
            difference(){
                union() {
                    translate([0, 0, r - t - eh]) base();
                    sphere(r);
                }
                translate([0, 0, -r + th]) cube(r*2, center=true);
                translate([0, 0, r*2 + th - o]) cube(r*2, center=true);
            }
            // Not sure why, but subtracting a sphere from the inside of a ScrewThread causes CGAL to hang
            translate([0, 0, 0]) ScrewThread(r*2 - t - tf, th, pitch=pitch, tooth_angle=tooth_angle, tolerance=thread_tolerance);
        }
        sphere(r-t);
    }
}


module inner_gasket() {
    r1 = r - t + gw;
    r2 = r - t;
    
    difference() {
        cylinder(gh, r1, r1); // Outer
        cylinder(gh, r2, r2); // Inner
    }
}

module outer_gasket() {
    r1 = r;
    r2 = r - gw;
    
    difference() {
        cylinder(gh, r1, r1); // Outer
        cylinder(gh, r2, r2); // Inner
    }
}

