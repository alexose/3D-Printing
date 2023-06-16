use <threads.scad>;
$fn=80;

hr = 20; // Handle radius
hh = 100; // Handle height
br = 20; // Barrel radius
ir = 10; // Inner radius
bh = 140;
tr = 12; // tube radius, leave a little extra to allow for air to move through
wr = 3; // wire radius

difference() {
    union() {
        handle();
        barrel();
        trigger();
    }
    union() {
        cylinder(hh, tr, tr);
        translate([0, 15, bh/2 + br + 7]) rotate([90, 0]) cylinder(bh*2, ir * 0.75, ir * 0.75);  
        translate([0, -hr - wr, 50]) cylinder(hh, wr, wr);
    }
}

trigger();

module handle() {
    // via http://www.imajeenyus.com/mechanical/20120508_bottle_top_threads/index.shtml
    d = 27.4 + 2.15; // Not sure what the deal is with my measurements...
    h = 5;
    p = 2.7;

    difference() {
        hull() standoffs(hh, hr, hr, 10);
        ScrewThread(d, h, pitch=p);    
    }
}

module barrel() {
    translate([0,0,hh-hr]) rotate([90, 0]){ 
        hull() standoffs(bh, br, br/3, 10);
        translate([0, hr/2, bh/2]) cube([hr*2, hr*2/2, bh], true);
    }

}

module trigger() {
    r = 2;
    jr = 8; // button radius
    jh = 6;
    t = 1;
    
    translate([0, -45, hh - br*2 - 4]) rotate([90, 90]) {
        difference() {
            scale(1.4) union () {
                hull() sphere_standoffs(br/2, br/2, r);
                translate([br/2 + r + 3.8, 0, -br/2 - r/2]) hull() rotate([0, 55]) sphere_standoffs(br*0.75, br/2, r);
            }
            translate([0, 0, -3]) cylinder(10, jr, jr);
        } 
    }
}


module standoffs(h, w, d, r) {
    translate([w-r, d-r]) cylinder(h, r, r);
    translate([w-r, -d+r]) cylinder(h, r, r);
    translate([-w+r, d-r]) cylinder(h, r, r);
    translate([-w+r, -d+r]) cylinder(h, r, r);
}

module sphere_standoffs(w, d, r) {
    translate([w-r, d-r]) sphere(r);
    translate([w-r, -d+r]) sphere(r);
    translate([-w+r, d-r]) sphere(r);
    translate([-w+r, -d+r]) sphere(r);
}
