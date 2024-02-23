use <threads.scad>

h = 10; // Height (for each half)
r = 20; // Radius
t = 1.6; // Wall thickness
b = 4; // Base height
w = r + 10; // Thread diameter
pitch = 3;

$fn = 80;

base();
translate([r*2 + 2, 0]) top();

module base() {
    difference() {
        camfered_cylinder(h, r=r);
        translate([0,0,t]) screw(w+t, true);
        translate([8,0,0]) screw_hole(); 
        rotate([0, 0, 120]) translate([8,0,0]) screw_hole(); 
        rotate([0, 0, 240]) translate([8,0,0]) screw_hole(); 
    }
}

module top() {
    camfered_cylinder(b, r=r);
    translate([0,0,b]) screw(w+t);
}

module screw(diameter=w, tap=false) {
    tolerance = 0.4;
    if (tap) {
        // In threads.scad, the ScrewHole module simply multiplies the diameter by 1.01 and adds tolerance times 1.25.
        // Kind of cheezy, but we'll do the same here.
        ScrewThread(diameter * 1.01 + tolerance * 1.25, h-t+1, pitch=pitch, tolerance=tolerance);
    } else {  
        ScrewThread(diameter, h-t+1, pitch=pitch, tolerance=tolerance);
    }
}

// Camfer the bottoms slightly
module camfered_cylinder(h, r) {
    x = 1;
    union() {
        translate([0, 0, x]) cylinder(h-x, r=r);
        cylinder(x, r-x, r);
    }

}

module screw_hole() {
    r1 = 2;
    r2 = 3;
    h = 2;
    translate([0, 0, t - h]) cylinder(h, r1, r2);
    cylinder(t-h, r=r1);
}