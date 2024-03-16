// Single motor dual axis tracking mount

$fn = 100;
r1 = 30;
r2 = 3;
h1 = 6;
t1 = 10; // Thickness of housing.  Trades off between strength and range of motion

render_stylus = 0;
render_housing = 0;
render_ball_without_stylus = 1;
render_track_cylinder = 0;

if (render_stylus) stylus(r1, r2, h);
if (render_housing) housing(r1, h1, r2, t1);
if (render_ball_without_stylus) ball_without_stylus(r1, r2, h1);
if (render_track_cylinder) track_cylinder(r1, h1, r2, t1);

module track_cylinder(r1, h1, r2, t1) {
    difference() {
        hollow_sphere_slice(r1 + h1, r2, t1);
        spiral_track(r1, r2, h1);
    }
}

module hollow_sphere_slice(inner_radius, thickness, offset) {
    outer_radius = inner_radius + thickness + 1;
    tolerance = 0.2; // Gap between the hollow sphere slice and the housing
    difference() {
        rotate([90,0]) cylinder(outer_radius + 5, r = outer_radius);
        union() {
            sphere(inner_radius);
            translate([0, outer_radius - (offset/2 + tolerance)]) cube(outer_radius * 2, true);
        }
    }    
}

module ball_with_stylus(r1, r2, h) {
    sphere(r1);
    rotate([90, 0]) {
        cylinder(r1 + h1, r2, r2);
        ball(r1, r2, h1);
    }
}

module ball_without_stylus(r1, r2, h) {
    difference() {
        sphere(r1);
        union() {
            rotate([90, 0]) {
                cylinder(r1 + h1, r2, r2);
                ball(r1, r2, h1);
            }
            rotate([270, 0]) {
                cylinder(r1 + h1, r2, r2);
                ball(r1, r2, h1);
            }
        }
        translate([0, r1*1.5]) cube(r1*2, true);
    }
}


module stylus(r1, r2, h) {
    tolerance = 0.1;
    cylinder(r1 + h1, r = r2 - tolerance);
    ball(r1, r2 - tolerance, h1);
}


// TODO: improve the math here
// maybe https://openhome.cc/eGossip/OpenSCAD/ArchimedeanSpiral.html
module spiral_track(r1, r2, h1) {
    begin = 300;
    div = 14;
    increment = 10;
    total = (360 * div) / 4;
    for ( i = [begin:increment:total]) { 
        hull() {
            rotate([i/div,i,0]) ball(r1, r2, h1);
            rotate([(i+increment)/div,i+increment,0]) ball(r1, r2, h1);
        }
    }
            
}

module ball(r1, r2, h1) {
    $fn = 20;
    translate([0, 0, r1 + h1]) sphere(r2);
}


// Housing that immobilizes the sphere
module housing(r1, h1, r2,  t1) {
    t = 5;
    r = r1 + h1 + r2;
    d = r * 2 + t;
    base = 22;
    shaft_radius = 1;
    shaft_length = 5;
    tolerance = 0.2;
    
    difference() {
        cube([d, t1, d], true);
        union() {
            sphere(r1 + tolerance);
            difference() {
                rotate([90, 0]) cylinder(t/2, r = r + 1 + tolerance);
                rotate([90, 0]) cylinder(t/2, r = r1+h1 - tolerance);
            }
        }
    } 
}