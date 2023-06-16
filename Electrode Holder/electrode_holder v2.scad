r = 58/2; // outer radius of beaker
t = 2;
c = 10; // clamp height
d = 10; // drop
bt = 5.8; // beaker thickness

holder_width = 17;
holder_height = 12;
holder_depth = 7;

$fn=100;

inner();
clamps();
translate([50, 0]) holder();

module clamps() {
    difference(){
        cylinder(c, r=r + t);
        cylinder(c, r=r);
        cube([r*3, r*0.85, c*2], center = true);
        cube([r*0.85, r*3, c*2], center = true);
    }
}

module inner() {
    w1 = holder_height;
    w2 = holder_width;
    h2 = holder_depth;
    h1 = 4;
    
    probe_width = 15 + 1; // x-dimension of pH probe, plus added tolerance
    probe_height = 32 + 1; // y-dimension of pH probe, plus added tolerance
    tolerance = 0.6;
    corner_radius = 2;
    pw = probe_width/2 + tolerance - corner_radius/2;
    ph = probe_height/2 + tolerance - corner_radius/2;
   
    difference() {
        union() {
            cylinder(t, r=r);
            cylinder(t+d, r=r-bt);
        }
        translate([0, 9.4]) hull() standoffs(t+d, ph, pw, corner_radius); 
        translate([0, -7.4]) hull() standoffs(t+d, w2+tolerance, h2+tolerance, corner_radius);
    }
}



module standoffs(h, w, d, r) {
    translate([w-r, d-r]) cylinder(h, r, r);
    translate([w-r, -d+r]) cylinder(h, r, r);
    translate([-w+r, d-r]) cylinder(h, r, r);
    translate([-w+r, -d+r]) cylinder(h, r, r);
}

module holder() {
    w1 = holder_height;
    w2 = holder_width;
    h2 = holder_depth;
    wire_radius = 1.8/2;
    
    ew = 12; // electrode width
    ed = 1; // electrode thickness
    d = 20; // distance apart
    h = 30; // height
    
    difference() {
        union() {
            difference() {
                hull() standoffs(t+h, w2, h2, 2);
                translate([0, 0, t]) hull() standoffs(t+h, w2-t/2, h2-t/2, 2);
                translate([-d/2, 0]) cube([ed, ew, t*2], center=true);
                translate([-d/2, 0]) cube([ed, ew, t*2], center=true);
                translate([d/2, 0]) cube([ed, ew, t*2], center=true);
                cube([ed, ew, t*2], center=true);
            }
            translate([0, 0, h]) difference() {
                hull() standoffs(t, w2+1, h2+1, 2);
                hull() standoffs(t, w2, h2, 2);
            }
        }
        translate([0, 0, (h+t)/2 + t]) cube([w2*2 - 4 - t, w2*2, h+t], center=true);
    }
    translate([-d/2 + ed, 0, t*1.5]) cube([ed, ew, t*3], center=true);
    translate([d/2 - ed, 0, t*1.5]) cube([ed, ew, t*3], center=true);
    translate([ed, 0, t*1.5]) cube([ed, ew, t*3], center=true);
    
}