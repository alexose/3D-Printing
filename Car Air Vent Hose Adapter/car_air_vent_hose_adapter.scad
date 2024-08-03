// Air vent hose adapter for F150.  I use this to redirect the flow of A/C to my thermally
// challenged Comma 3x during the hotter months.

h = 55;
d = 100;
w = 55;
t = 2;

main();

module main(){
    difference() {
        box();
        box(-t);
        tube();
        // logo();
    }
    connector();
    scoop();
    corners([60, 40]) translate([0, 0, h]) rotate([0, 180, 90]) clip();
}

// Box that interfaces with vent
module box(o=0) {
    hull() {
        translate([0, 0, (w+o+5)/2]) corners([d+o, w+o]) sphere(10);
        corners([d+o, w+o+5]) half_sphere(10);
    }
}

// Hollow bit that redirects air
module scoop() {
    r1 = 70/2;
    difference() {
        box(-t);
        hull() {
            translate([-55/2, 0, -30/2]) sphere(r1, true);
            translate([40, -20/2, -30/2]) sphere(r1+20, true);
        }
        tube();
    }
}

module connector() {
    difference() {
        tube(t/2);
        tube();
        box(-t);
    }
}

module tube(o=0) {
    r = (23.8)/2 + o;
    translate([30, 0, r+10-o]) rotate([90, 0, 35]) cylinder(60-o, r=r);
}

module half_sphere(radius) {
    difference() {
        sphere(radius);
        translate([0, 0, -radius]) cube(radius*2, true);
    }
}

module logo(){
    translate([105, 0, 64]) rotate([0, 0, 270]) linear_extrude(2) text("3X", size=80, font="Monument Extended:style=bold, sans-serif", direction="ttb");
}

module corners(dimensions=[1,1], o=0) {
    x = dimensions[0]/2;
    y = dimensions[1]/2;
  
    translate([-x, y]) children();
    translate([x, y]) children();
    translate([-x, -y]) children();
    translate([x, -y]) children();
}

// The thingies that clis onto the vent fins
module clip() {
    r = 6;
    t = 2;
    h = h + 10;
    
    translate([0, 0, 16]) difference() {
        cylinder(h, r=r);
        hull() {
            translate([0, 0, h - 25]) cube([h, t+1, 1], true);
            translate([0, 0, h - 5 ]) cube([h, t, 1], true);
        }
        hull() {
            translate([0, 0, h - 5 ]) cube([h, t, 1], true);
            translate([0, 0, h]) cube([h, t+1, 1], true);
        }
    }
}
