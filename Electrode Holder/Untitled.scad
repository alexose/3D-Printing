// Electrode holder for an electrochemistry experiment I'm doing.
// This is bad, but whatever

w = 15;
h = 70;
t = 1.2;
r = 1;
d = 10; // distance apart
b = 30; // approx. width of beaker
a = 30; // approx. height of alligator clips

ew = 12; // electrode width
ed = 1; // electrode depth

$fn = 50;

difference() {
    cube([w, h, t]);
    translate([w/2, d/2 + h/2]) cylinder(t, r=r);
    translate([w/2, -d/2 + h/2]) cylinder(t, r=r);
}

translate([0, h/2 + b/2 - t/2, t]) cube([w, t, a]);
translate([0, h/2 - b/2 - t/2, t]) cube([w, t, a]);

difference() {
    translate([0, h/2 - b/2 - t/2, t + a]) cube([w, b + t, t]);
    translate([w/2 - ew/2, d/2 + h/2, t + a]) cube([ew, ed, t]);
    translate([w/2 - ew/2, -d/2 + h/2, t + a]) cube([ew, ed, t]);
}