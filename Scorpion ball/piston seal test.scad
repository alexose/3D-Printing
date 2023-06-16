// Piston seal test
$fn = 100;


// User variables
gasket_outer_radius = 29 / 2;
gasket_diameter = 3.4;
tolerance = 0.275;
shell_thickness = 1.6;
height = 20;

// Script variables
d = gasket_diameter;
f = tolerance;
t = shell_thickness;
h = height;
r1 = gasket_outer_radius + t + f; // outer radius of sleeve
r2 = gasket_outer_radius; // outer radius of piston



difference() {
    ring(h, r1, t, t);
}

translate([r1*2, 0, 0])
difference() {
    t1 = d + t;
    h1 = h + 5;
    
    ring(h1, r2, t1);
    translate([0, 0, 7]) ring(d * 1.2, r2, d * .85);
}


module ring(h, r, t, o) {
    difference() {
        cylinder(h, r, r);
        translate([0, 0, o]) cylinder(h, r-t, r-t);
    }
}