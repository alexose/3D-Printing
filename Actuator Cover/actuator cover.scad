r = 20; // Motor cover radius
h = 60; // Motor cover height

x = 60; // Cube width
y = 100; // Cube length
z = 40; // Cube height;

t = 1.2;

// Upper shell


difference() {
    union() {
        cylinder(h, r=r);
        translate([0, -20, h + z/2]) roundedcube(x,y,z,10);
    }
    translate([0, -20, h + z/2 + t]) roundedcube(x-t*2,y-t*2,z,10);
    translate([0, 0, t]) cylinder(h+t, r=r-t/2);   
}

module roundedcube(w,h,d,r){
    hull() {
        translate([0, 0, d/2 - r]) spheres(0.1);
        translate([0, 0, -d/2 + r]) spheres(r);
    }
    
    module spheres(r) {
        translate([w/2 - r, h/2 - r]) sphere(r);
        translate([-w/2 + r, h/2 - r]) sphere(r);
        translate([w/2 - r, -h/2 + r]) sphere(r);
        translate([-w/2 + r, -h/2 + r]) sphere(r);
    }
}