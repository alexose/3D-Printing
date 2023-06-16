use <threads.scad>

$fn=100;

pitch = 4;
tooth_angle = 55;
hole_size = 10;

r = 75;

t = r / 6; // shell thickness
th = 12; // threads height
sh = 5; // screw height
f = 1.5; // fitting fudge factor.  this shaves Xmm off of each side
gh = 3; // gasket height
gw = 2.6; //gasket width
sr = r*2 - t + 3; // screw radius

rotate([180, 0]) translate([-r - t, 0, -r - th]) top_half_preview();
rotate([180, 0]) translate([r + t, 0, -r - th]) bottom_half_preview();
// translate([0, r * 2, 0]) inner_gasket(); 
// translate([0, -r * 2, 0]) outer_gasket();
// translate([0, -r * 2, 0]) gasket_mold();


module top_half_preview() {
    difference() {
        union() {
            top_half();
            // translate([0, 0, 28]) cylinder(2, r, r);
        }
        translate([0, 0, 30]) cylinder(100, r, r);
    }
}

module bottom_half_preview() {
    difference() {
        bottom_half();
        translate([0, 0, 30]) cylinder(100, r, r);
    }
}

module top_half() {
    taper = 2; // Taper opening for a more snug fit
    
    ScrewHole(sr, sh, pitch=pitch, tooth_angle=tooth_angle, tolerance=0.2) {
        translate([0, 0, th]) difference() {
            difference(){
                union() {
                    translate([0, 0, r]) cube(r*1.4, center=true);
                    sphere(r);
                }
                translate([0, 0, -r - th]) cube(r*2, center=true);
            }
            union() {
                sphere(r-t);
                cylinder(r, hole_size, hole_size);  // Water hole 
                translate([hole_size + t, 0]) cylinder(r, hole_size/2, hole_size/2); // Air hole
                translate([0, 0, r*2]) cube(r*2, center=true);
            }
           r2 = r - t / 2;
           translate([0, 0, -th]) cylinder(th, r2 + f, r2 + f - taper);
        }
    }
}

module bottom_half() {
    r1 = r - t/2;
    r2 = r - t / 2 - gw;
    translate([0, 0, th]) 
    difference() {
        union() {
            difference(){
                union() {
                    translate([0, 0, r]) cube(r*1.4, center=true);
                    sphere(r);
                }
                translate([0, 0, -r + th]) cube(r*2, center=true);
            }
                        
            translate([0, 0, th - sh]) ScrewThread(sr, sh, pitch=pitch, tooth_angle=tooth_angle, tolerance=0.2);
            cylinder(th, r1 - 0.5, r1 - 0.5);
        }

        union() {
            // Cutout for upper gasket
            translate([0, 0, 2]) difference() {
                cylinder(gh, r2 + 5, r2 + 5);
                cylinder(gh, r2, r2);
            }


            
            sphere(r-t);
            
            // Cutoff for bottom
            translate([0, 0, r*2]) cube(r*2, center=true);
        }
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
    f = 0.98;
    r1 = r * f;
    r2 = (r - gw) * f;
    
    difference() {
        cylinder(gh, r1, r1); // Outer
        cylinder(gh, r2, r2); // Inner
    }
}

module gasket_mold() {
    difference() {
        r1 = r + t;
        r2 = r * .75;
        cylinder(gh*2, r1, r1);
        union() {
            translate([0, 0, gh]) outer_gasket();
            translate([0, 0, gh]) inner_gasket();
            cylinder(gh*2, r2, r2);
        }
    }
}