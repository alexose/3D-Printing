include <roundedcube.scad>;
difference() {
    roundedcube(20, true, 3);
    translate([0,0,10]) scale([1,3,3]) roundedcube(10, true);
}