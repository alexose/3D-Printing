$fn=30;

module standoffs(h, r, x, y){
    translate([x/2, y/2]) cylinder(h, r, r);
    translate([-x/2, y/2]) cylinder(h, r, r);
    translate([x/2, -y/2]) cylinder(h, r, r);
    translate([-x/2, -y/2]) cylinder(h, r, r);
}

t = 2;
w = 120;
h = 75;
d = 20;

standoffs(d, 3, w, h);
difference() {
    hull() standoffs(d, 3, w, h);
    translate([0, 0, t]) hull() standoffs(d, 3, w-t, h-t);
}

module mount(h, w, d, t) {
    difference() {
        translate([-w, -h, d/2]) rotate([270, 0, 0]) linear_extrude(d) polygon([
            [0,0],
            [0,h],
            [w,h],
            [w,h/1.5],
        ]);
        translate([-w/2, 0, t]) cylinder(d, 3, 3);
        translate([-w/2, 0, -t]) cylinder(d, 1, 1);
    }
    
}

translate([w/2 + 10 + t*1.5, h/4]) mount(10, 10, 20, t);
translate([w/2 + 10 + t*1.5, -h/4]) mount(10, 10, 20, t);
rotate([180, 180]) translate([w/2 + 10 + t*1.5, h/4]) mount(10, 10, 20, t);
rotate([180, 180]) translate([w/2 + 10 + t*1.5, -h/4]) mount(10, 10, 20, t);