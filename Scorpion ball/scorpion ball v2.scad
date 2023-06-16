use <threads.scad>

$fn=100;

pitch = 4;
tooth_angle = 55;
hole_size = 5;

r = 75;

t = r / 10; // shell thickness
th = 10; // threads height
tf = -1; // threads fudge factor
gh = 2; // gasket height
gw = 2; //gasket width

rotate([180, 0]) translate([-r - t, 0, -r - th]) top_half();
rotate([180, 0]) translate([r + t, 0, -r - th]) bottom_half();
// translate([0, r * 2, 0]) inner_gasket(); 
// translate([0, -r * 2, 0]) outer_gasket();
// translate([0, -r * 2, 0]) gasket_mold();


module top_half() {
    ScrewHole(r*2 - t + tf, th, pitch=pitch, tooth_angle=tooth_angle) {
        translate([0, 0, th]) difference() {
            difference(){
                union() {
                    translate([0, 0, r]) cube(r, center=true);
                    sphere(r);
                }
                translate([0, 0, -r - th]) cube(r*2, center=true);
            }
            union() {
                sphere(r-t);
                cylinder(r, hole_size, hole_size);
                translate([hole_size + t, 0]) cylinder(r, hole_size/2, hole_size/2); // Air hole
                translate([0, 0, r*2]) cube(r*2, center=true); // Water hole
            }
        }
        
    }
}

module bottom_half() {
    translate([0, 0, th]) difference() {
        union() {
            difference(){
                union() {
                    translate([0, 0, r/2]) cube(r, center=true);
                    sphere(r);
                }
                translate([0, 0, -r + th]) cube(r*2, center=true);
            }
            // Not sure why, but subtracting a sphere from the inside of a ScrewThread causes CGAL to hang
            ScrewThread(r*2 - t + tf, th, pitch=pitch, tooth_angle=tooth_angle, tolerance=0.2);
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