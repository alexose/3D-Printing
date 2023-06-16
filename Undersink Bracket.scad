// Sink bracket
h = 4;
$fn=100;
difference() {
    hull() {
        standoffs(h, 10, 35, 45);
    }
    
    translate([19, 0]) hull() {
        cylinder(h, r=20);
        translate([40, 0]) cylinder(h, r=30);
    }
    translate([-10, 0]) cylinder(h, r=4);
}

module standoffs(h, r, x, y){
    translate([x/2, y/2]) cylinder(h, r, r);
    translate([-x/2, y/2]) cylinder(h, r, r);
    translate([x/2, -y/2]) cylinder(h, r, r);
    translate([-x/2, -y/2]) cylinder(h, r, r);
}