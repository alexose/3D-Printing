magnet_diameter = 20;
magnet_height = 1.4;
outer_diameter = 29;

standoff = 0.9;
thickness = 2;

$fn = 100;

module hook() {
    h = magnet_height + thickness + standoff;
    d = outer_diameter;
    
    translate([standoff, -d/4, h]) rotate([0, 90]) linear_extrude(5)
        polygon([[-4,0],[-4,8],[-4,16],[0,16],[0,14],[-2,13],[-2,8],[-2,5],[1,0],[1,-6]]);

}

module base() {
    d = outer_diameter;
    h = magnet_height + thickness;
    cylinder(h, d/2, d/2);
}

module magnet() {
    d = magnet_diameter;
    h = magnet_height;
    cylinder(h, d/2, d/2);
}

hook();
rotate([0, 0, 180]) hook();

difference() {
    base();
    magnet();
}