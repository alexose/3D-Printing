// Drain meant for outdoor shower
t = 1.2;
r = 30; // 60mm width
w = 50;
l = 165 - r; // 165mm length
d = 50;

overlap = 10;
drain_pipe_height = 20;
drain_pipe_radius = 18;

$fn = 100;


drain();


module drain() {
    h1 = drain_pipe_height;
    r1 = drain_pipe_radius;

    difference() {
        union() {
            top();
            half_cylinder(l, r);
            translate([0, -t, -r - h1/2]) pipe(drain_pipe_height, drain_pipe_radius);
        }
        
        union() {
            translate([0, -t]) full_cylinder(l - t*2, r - t);
            
            // Hole for drain pipe
            translate([0, -t, -r]) cylinder(h1, r=r1 - t);
            translate([0, -r]) slice(l - t*2, r -t);
        }
    }

}

module top() {
    o = overlap;
    translate([0, -l/2 + o*2]) hull() standoffs(t, r + o, l/2 + o*2, 10);
}

module slice(h, r) {
    o = 6;
    
    difference() {
        rotate([90, -90]) cylinder(h, r=r);
        translate([0, -r*4, -r - o - t*2]) cube([r*2, h*2, r*2], center=true);
    }
}

module half_cylinder(h, r) {
    rotate([90, -90]) difference(){
        union() {
            cylinder(h, r=r);
            sphere(r);
        }
        translate([0, -r, -0.5]) cube([r*2, r*2, h+1]);
    }
}

module full_cylinder(h, r) {
    union() {
        cylinder(h, r=r);
        sphere(r);
        translate([0, 0, r*2 + t]) cube(r*4, center=true);
    }
    rotate([90, -90]) cylinder(h, r=r);
}


module standoffs(h, w, d, r) {
    translate([w-r, d-r]) cylinder(h, r, r);
    translate([w-r, -d+r]) cylinder(h, r, r);
    translate([-w+r, d-r]) cylinder(h, r, r);
    translate([-w+r, -d+r]) cylinder(h, r, r);
}

module pipe(h, r) {
    difference(){
        cylinder(h, r=r);
        cylinder(h, r=r-t);
    }
}