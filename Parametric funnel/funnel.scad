top = 300 / 2; // mm
bottom = 53 / 2;
height = 150;
thickness = 4;

$fn = 200;

translate([0, 0, height]) rotate([0, 180, 0]) {

    difference() {
        cylinder(height*.1, bottom, bottom);
        cylinder(height*.1, bottom-thickness, bottom-thickness);
    }

    translate([0, 0, height*.1]) difference() {
        cylinder(height*.8, bottom, top);
        cylinder(height*.8, bottom-thickness, top-thickness);
    }

    translate([0, 0, height*.9]) difference() {
        cylinder(height*.1, top, top);
        cylinder(height*.1, top-thickness, top-thickness);
    }
}