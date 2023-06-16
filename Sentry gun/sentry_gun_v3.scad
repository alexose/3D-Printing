
r1 = 100; // Tank lower radius
r2 = 30; // Tank upper radius
h = 80; // Tank height
bh = 10; // Base height
fn = 10; // Number of sides
t = 2; // Tank thickness
hw = 20; // Hole width

difference() {
    shell();
    translate([0, 0, t+bh]) cylinder(h, hw, hw);
}

module shell() {
    difference() {
        base();
        base_inner();
    }
}

module base() {
   translate([0,0,bh]) cylinder(h, r1, r2, $fn=fn);
   cylinder(bh, r1, r1, $fn=fn);
}

module base_inner() {
   translate([0,0,bh-t]) cylinder(h-t, r1-t, r2-t, $fn=fn);
   translate([0,0,t]) cylinder(bh-t, r1-t, r1-t, $fn=fn);
}