w = 165;
h = 110;
t = 1.2;
$fn = 10;

difference() {
    middle(h, 0);
    middle(h-t, t);
    lengthwise_cutout();
}

module lengthwise_cutout() {
    o = 50;
    s = h / 1.1;
    hull() {
        translate([0, 0, -o]) radial_multiply(3, s) cylinder(1, r=5);
        translate([0, 0, w+o]) radial_multiply(3, s) cylinder(1, r=5);
    }
    
    
    translate([0, 0, 80]) rotate([0, 0, 60]) radial_multiply(3, 30) cube(h, true);
}


module middle(distance_apart, t) {
    hull() {
        translate([0, 0, t]) radial_multiply(3, distance_apart) sphere(30);
        translate([0, 0, w-t]) radial_multiply(3, distance_apart) sphere(30);
    }   
}

module radial_multiply(num, distance_apart) {
    p = distance_apart;    
    step =  360 / num;
    
    for (i = [0 : step : 360 ]) {
        translate([p, 0]) children(0);
        rotate([0, 0, i]) translate([p, 0]) children();
        rotate([0, 0, i]) translate([p, 0]) children();
    }
}