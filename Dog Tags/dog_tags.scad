
$fn = 30;

scale(1.15) translate([0, 0]) {
    difference() {
        linear_extrude(3) scale(1.2) import("tag1.svg", center=true);
        union() {
            translate([0, 0, 2]) linear_extrude(3) scale(0.98) import("tag1.svg", center=true);
            translate([0, 0, 1]) linear_extrude(1) import("tag1.svg", center=true);
            translate([-1, 12, 0]) cylinder(5, r=1.7);
        }
    }
}

scale(.97) translate([40, 0]) {
    difference() {
        linear_extrude(3) scale(1.2) import("tag2.svg", center=true);
        union() {
            translate([0, 0, 2]) linear_extrude(3) scale(0.98) import("tag2.svg", center=true);
            translate([0, 0, 1]) linear_extrude(1) import("tag2.svg", center=true);
            translate([-3, 13, 0]) cylinder(5, r=2);
        }
    }
}