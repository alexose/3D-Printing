use <threads.scad>


// Piston seal test
$fn = 100;


// User variables
gasket_outer_radius = 29 / 2;
gasket_diameter = 3.4;
tolerance = 0.275;
shell_thickness = 1.6;
height = 12;
pitch = 5;
tooth_angle = 55;

// Script variables
d = gasket_diameter;
f = tolerance;
t = shell_thickness;
h = height;
r1 = gasket_outer_radius + t + f; // outer radius of sleeve
r2 = gasket_outer_radius; // outer radius of piston
rh = 8;

translate([0, 0, rh]) ScrewHole(r1*2 - t*2, h, pitch=pitch, tooth_angle=tooth_angle, tolerance=0.2) {
    cylinder(h, r1, r1);
}

ring(rh, r1, t);
cylinder(t, r1, r1);
cylinder(t+d, r2-d-f, r2-d-f);


t1 = d + t;
h1 = h + 5;
translate([r1*2, 0, 0]){
    difference() {
        union() {
            ScrewThread(r2*2, h, pitch=pitch, tooth_angle=tooth_angle, tolerance=0.2);
            translate([0, 0, h]) cylinder(h*2, r2 - t, r2 - t);
        }
        cylinder(h*3, r2-d, r2-d);
    }
    
}#



module ring(h, r, t, o) {
    difference() {
        cylinder(h, r, r);
        translate([0, 0, o]) cylinder(h, r-t, r-t);
    }
}