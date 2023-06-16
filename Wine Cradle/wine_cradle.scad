use <threads.scad>

handle_wheel_radius = 15;
handle_wheel_depth = 3;

x_distance_apart = 60;
y_distance_apart = 60;

translate([x_distance_apart, 0, 0]) big_tower();
translate([-x_distance_apart, 0, 0]) big_tower();
translate([0, y_distance_apart, 0]) small_tower();
translate([0, -y_distance_apart, 0]) small_tower();

translate([0, y_distance_apart *2, 0]) handle();

big_circle();
translate([ 0, -30, 0 ]) big_circle();
small_circle();
sides(); 

module sides() {
    t = 7;
    x = 40;
    translate([-x, 0, 0])  side(t);
    translate([x, 0, t]) rotate([0, 180, 0]) side(t);
}

module big_circle(r, t) {
    linear_extrude(7) scale(.2) import("big_circle.svg", center = true, dpi = 96);
}

module small_circle(r, t) {
    linear_extrude(7) scale(.2) import("small_circle.svg", center = true, dpi = 96);
}

module side(t) {
    linear_extrude(t) scale(.2) import("side.svg", center = true, dpi = 96);
}



// TODO: Pretty victorian towers
module small_tower(){
    hull() {
        translate([0, 0, 0]) torus(1, 10);
        translate([0, 0, 5]) torus(1, 5);
    }
    hull() {
        translate([0, 0, 5]) torus(1, 5);
        translate([0, 0, 20]) torus(1, 4);
    }
    hull() {
        translate([0, 0, 20]) torus(1, 4);
        translate([0, 0, 50]) torus(1, 3.3);
    }
}

module big_tower(){
    hull() {
        translate([0, 0, 0]) torus(1, 10);
        translate([0, 0, 5]) torus(1, 4);
    }
    hull() {
        translate([0, 0, 5]) torus(1, 4);
        translate([0, 0, 40]) torus(1, 3);
    }
    hull() {
        translate([0, 0, 40]) torus(1, 3);
        translate([0, 0, 100]) torus(1, 2.3);
    }
}

module torus(r=1, d=5) {
    rotate_extrude(convexity = 10, $fn=100)
    translate([d, 0, 0])
    circle(r, $fn = 100);
}


module handle() {
    r = handle_wheel_radius;
    d = handle_wheel_depth;
    $fn = 50;
    h = 15;
    
    gap = 0.4 / 2;
    // Gap for handle
    r1 = d/4 + gap;
    r2 = r1 + gap*2;
    r3 = r2 - gap;
    
    difference() {
        union() {
            spoke(r, d);
            rotate([0, 0, 90]) spoke(r, d);
            
            // Outer ring
            difference() {
                cylinder(d, r, r);
                translate([0, 0, -.5]) cylinder(d+1, r-d, r-d);
            }
        }
        
        // Gap so that handle can rotate freely
        translate([r-d/2, 0, 0]) {
            cylinder(d+1, r1, r1);
            cylinder(gap*2, r2, r2);
        }
    }
    
    // Handle
    translate([r-d/2, 0, 0]) {
        cylinder(d+1, d/4, d/4);
        cylinder(gap*2, r3, r3);
        hull() {
            translate([0, 0, d + gap]) torus(.5, 1.2);
            translate([0, 0, d + gap + h]) torus(.5, 1.4);
        }
    }
}

module spoke(r,d) {
    hull() {
        translate([r-d, 0, 0]) cylinder(d, d/2, d/2);
        translate([-r+d, 0, 0]) cylinder(d, d/2, d/2);
    }
}