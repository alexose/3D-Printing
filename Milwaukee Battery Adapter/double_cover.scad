// This is a cover intended for two adapters, ideally seated in the 3002 weed whacker

// 10 inches wide
// 6.75 inches tall
// __ gap height

x = 78;
y = 252;
h = 170;
gw = 40; // gap width
gh = h - 90; // gap wall height
r = 1.6 / 2;
$fn = 30;

// Bottom
difference() {
    hull() corners([x, y]) sphere(r);
    translate([0, y/2 - 50, -1]) scale([1.75, 1, 1]) cylinder(10, r=6);
    translate([0, -y/2 + 50, -1]) scale([1.75, 1, 1]) cylinder(10, r=6);
}

// Fan-side walls
difference() {
    union() {
        translate([0, -y/2, h/2]) rotate([90, 0]) hull() corners([x, h]) sphere(r);
        translate([0, y/2, h/2]) rotate([90, 0]) hull() corners([x, h]) sphere(r);
    }
    translate([0, -y/2 + 10]) ventilation();
    translate([0, y/2 + 10]) ventilation();
}

// Pony walls, for stiffness
translate([-x/2, 0, gh/2]) rotate([0, 90]) hull() corners([gh, y]) sphere(r);
translate([x/2, 0, gh/2]) rotate([0, 90]) hull() corners([gh, y]) sphere(r);

// Other walls
w = y/2 - gw/2;
q = y/2 - w/2;
translate([x/2, q, h/2]) rotate([0, 90]) hull() corners([h, w]) sphere(r);
translate([-x/2, q, h/2]) rotate([0, 90]) hull() corners([h, w]) sphere(r);
translate([x/2, -q, h/2]) rotate([0, 90]) hull() corners([h, w]) sphere(r);
translate([-x/2, -q, h/2]) rotate([0, 90]) hull() corners([h, w]) sphere(r);


// Ventilation
module corners(dimensions=[1,1], o=0) {
    x = dimensions[0] / 2;
    y = dimensions[1] / 2;
  
    translate([-x, y]) children();
    translate([x, y]) children();
    translate([-x, -y]) children();
    translate([x, -y]) children();
}


module ventilation(n=5) {
    // A series of holes, arranged in a grid
    translate([-25, 0, 60]) rotate([90, 0]) for (i = [0:5]) {
        for (j = [0:5]) {
            translate([i*10, j*10]) hole();
        }
    }
}

module hole() {
    cylinder(r=3.5, h=20, $fn=10);
}
