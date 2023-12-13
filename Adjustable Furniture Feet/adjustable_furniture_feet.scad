use <threads.scad>

h = 20; // Height (for each half)
r = 20; // Radius
t = 1.6; // Wall thickness
b = 5; // Base height
w = r + 10; // Thread diameter
pitch = 2;

$fn = 80;

base();
translate([r*2 + 4, 0]) top();

module base() {
    difference() {
        cylinder(h, r=r);
        translate([0,0,t]) screw(w+t + 0.5);
    }
}

module top() {
    cylinder(b, r=r);
    translate([0,0,b]) screw(w+t, 0);
}

module screw(diameter=w, tolerance=0.6) {
    ScrewThread(diameter, h-t+1, pitch=pitch, tolerance=tolerance);
}