use <threads.scad>;
$fn=80;

translate([50,0]) nozzle();
manifold();

module nozzle() {

    // via https://www.gewinde-normen.de/en/npt-pipe-thread.html
    d = 21.223;
    h1 = 16;
    h2 = 30;
    h3 = 20;
    pitch = 1.814;
    opening = 3;
    t = 3;
    t2 = 4;

    difference() {
        union() {
            translate([0, 0, h1]) cylinder(h1+h2+h3, d/2 + t, d/2 + t);
            ScrewThread(d, h1, pitch=pitch);
        }
        union() {
            cylinder(h1+h2, d/2 - t2, d/2 - t2);
            translate([0, 0, h1+h2+h3]) cylinder(h3, d/2 - t2, opening);
        }
    }
}

module manifold() {
    // via https://www.gewinde-normen.de/en/npt-pipe-thread.html
    d = 21.223;
    h1 = 10;
    h2 = 30;
    h3 = 20;
    pitch = 1.814;
    opening = 5;
    t = 3;
    
    // via http://www.imajeenyus.com/mechanical/20120508_bottle_top_threads/index.shtml
    d2 = 27.4;
    h4 = 8;
    pitch2 = 2.7;

    difference() {
        union() {
            hull() {
                cylinder(h2+h3, d/2 + t, d/2 + t);
                translate([0, -h2-h3, h2+h3 - d/2 -t]) 
                    rotate([270, 0])
                    cylinder(h2+h3, d2/2 + t, d2/2 + t);
                translate([0, d-7, d2 - t]) rotate([90, 0]) cube([d2, h2+h3, t], center=true);
                translate([0, -h1 - 8, h2+h3+t]) cube([d2, h2+h3 + 10, t], center=true);
            }
        }
        union() {
            translate([0, -h2-h3, h2+h3 - d/2 -t]) 
                rotate([270, 0])
                ScrewThread(d2 + 2.15, h4, pitch=pitch2);  // Not sure what's wrong with my measurements here...
            cylinder(h2+h3 -t , d/2 - t, d/2 - t);
            translate([0, 0, h2+h3 - d/2 - t]) rotate([90, 0]) cylinder(h2+h3, d/2 - t, d/2 - t);
            translate([0, 0, -3]) ScrewThread(d, h1, pitch=pitch);
        }
    }
    
    
    
}