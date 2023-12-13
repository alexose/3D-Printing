// Testing which shape and size of holes works best for M2 and M3 screws

h = 5;
w = 20;
d = 100;

c = 2.5;

cylinder_height = 4;
cylinder_radius = 0.75;
distance_between = 6;
number_of_cylinders = 13; // Set the number of cylinders you want

$fn = 50;

difference() {
    cube([w,d,h]);
    translate([w/2, 5, 1]) {
        cylinders(7.5, 0);
        cylinders(1, 0.25);
        cylinders(-5, 0.5);
    }
}

module cylinders(offset, taper) {
    for(i = [0 : number_of_cylinders - 1]) {
        bottom = max(cylinder_radius + i/20 - taper, 0);
        top  = cylinder_radius + i/20;
        translate([offset, i * (cylinder_radius * 2 + distance_between), 0]){
            cylinder(h = cylinder_height, bottom, top,);
            translate([0, 0, 3]) linear_extrude(5) rotate([0, 0, 270]) translate([0.1, -3.5]) text(str(bottom*100), 2.8, halign="center");
        }
    }
}
