// Gate bracket!

w = 120;
h = 100;
t = 3;

$fn=40;

difference() {
    d = 27; // Distance from top and bottom
    union() {
        translate([w/2, h - d]) grab(t);
        translate([w/2, d]) rotate([0, 0, 180]) grab(t);
        base(w, h, t);
    }
    screw_holes(w, h, t);
}

module base(w, h, t){
    translate([w/2, h/2]) hull() standoffs(t, 5, w-10, h-10);
}

module grab(t,) {
    h = 27;
    ch = 9;
    bh = 5;
    w = 47;
    r = 5 * 1.1;
    f = 4; // flare
    difference () {
        hull() {
            translate([0, ch/2, h]) rotate([90, 0]) cylinder(ch, r+t+2, r+t+2);
            translate([0, 0, 1]) cube([w, ch+f, 1], center=true);   
        }
        translate([0, ch, h]) rotate([90, 0]) union() {
            cylinder(ch*2, r, r);
            cylinder(bh, 10, 10);
        }
    }
}

module screw_holes(w, h, t) {
    d1 = 12; // distance from outside
    d2 = 29;
    
    // Outer holes (corners)
    translate([d1, d1]) screw_hole(t);
    translate([w - d1, d1]) screw_hole(t);
    translate([w - d1, h - d1]) screw_hole(t);
    translate([d1, h - d1]) screw_hole(t);
    
    // Outer holes (middles)
    translate([w - d1, h/2]) screw_hole(t);
    translate([d1, h/2]) screw_hole(t);
    translate([w/2, h - d1]) screw_hole(t);
    translate([w/2, d1]) screw_hole(t);
    
    // Inner holes
    translate([d2, d2]) screw_hole(t);
    translate([w - d2, d2]) screw_hole(t);
    translate([w - d2, h - d2]) screw_hole(t);
    translate([d2, h - d2]) screw_hole(t);
    
    translate([w/2, h/2]) screw_hole(t);
}

module screw_hole(h) {
    translate([0, 0, h - 2.5]) cylinder(2.5, 3, 5);
    cylinder(h, 3, 3);
}

module standoffs(h, r, x, y){
    translate([x/2, y/2]) cylinder(h, r, r);
    translate([-x/2, y/2]) cylinder(h, r, r);
    translate([x/2, -y/2]) cylinder(h, r, r);
    translate([-x/2, -y/2]) cylinder(h, r, r);
}
