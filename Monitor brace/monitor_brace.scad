w = 35;
h = 35;
d = 220;
r = 3;
cutout = 18;
$fn = 100;



difference() {
    post(w, h, d);
    cutout();
    void(w-3, h-3, d-50);
}

module post(w,h,d) {
    hull() {
        translate([-w/2, -h/2]) cylinder(d, r, r); 
        translate([-w/2, h/2]) cylinder(d, r, r);
        translate([w/2, h/2]) cylinder(d, r, r);
        translate([w/2, -h/2]) cylinder(d, r, r);
    }
}

module void(w,h,d){
    hull() {
        translate([0, 0, d + w/2]) sphere(5);
        translate([-w/2, -h/2]) cylinder(d, r, r); 
        translate([-w/2, h/2]) cylinder(d, r, r);
        translate([w/2, h/2]) cylinder(d, r, r);
        translate([w/2, -h/2]) cylinder(d, r, r);
    }
}

module cutout() {
    offset_height = 20;
    offset_width = 6;
    translate([0, -d/2 + offset_width, d * 1.5 - offset_height]) cube([cutout, d, d], center = true);
}