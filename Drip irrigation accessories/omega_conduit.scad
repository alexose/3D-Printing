h = 10; // height
w = 35; // flange width
fd = 8; // flange depth
d = 1.6; // thickness
r1 = 9; // outer radius
r2 = 1.8; // screw hole head radius
r3 = 0.8; // screw hole radius
d2 = 6; // screw hole head depth
o = 3.5; // screw hole offset (from outer edges)

b = 2; //vertical bump

$fn = 150;



translate([0, 0, h/2]) rotate([0, 90, 0]) difference() {
    union() {
        hull() standoffs(1, d, h, w);
        translate([0, 0, b]) rotate([90, 0, 90]) cylinder(h, r1+d, r1+d, center=true);
    }
    union() {
        translate([0, 0, b]) rotate([90, 0, 90]) cylinder(h, r1, r1, center=true);  
        translate([0, 0, -h]) cube([h, r1*2, h*2 + h/2], center=true);
        translate([0, w/2 - o, -d2]) cylinder(d + d2, r2, r2);
        translate([0, -w/2 + o, -d2]) cylinder(d + d2, r2, r2);
        translate([0, w/2 - o, -fd]) cylinder(fd + d, r3, r3);
        translate([0, -w/2 + o, -fd]) cylinder(fd + d, r3, r3);
    }
}


module standoffs(r, depth, height, width) {
    $fn = 20;
    d = depth + fd;
    x = height / 2 - r;
    y = width / 2 - r;
    
    translate([0,0,-fd]) union() { 
        translate([x, y]) cylinder(d, r, r);
        translate([x, -y]) cylinder(d, r, r);
        translate([-x, y]) cylinder(d, r, r);
        translate([-x, -y]) cylinder(d, r, r);
    }
}