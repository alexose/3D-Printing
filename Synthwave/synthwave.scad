use <threads.scad>

base_radius = 282 / 2; // inner diameter of 5 gallon bucket in mm

container_bottom_radius = 89 / 2;
container_top_radius = 112 / 2;
container_height = 135.3;

pump_mount_depth = 10;
pump_mount_height = container_height + 15;

rear_wall_height = 180;
rear_wall_width = 110; // needs to accomodate two breadboards
rear_wall_thickness = 3;

distance_between_containers = 24;

$fn = 50;

//base();
// electrode_holder();


module lid() {
    br = base_radius; 
    h = 3;
    r = 8;
    t = 1.6;
    
    cylinder(h, r=br);
    
    scale([1, 1, 0.75]) difference() {
        rotate_extrude() {
            translate([br + 5, 0]) lid_cutout_shape();
        }
        rotate_extrude() {
            translate([br + 5, 0]) scale(0.8) lid_cutout_shape();
        }
    }
}

module lid_cutout_shape() {
polygon([[-8,0/*1:0,0,0,0*/] ,[-7.87,1.02] ,[-7.73,2.12] ,[-7.61,3.12] ,[-7.48,4.19] ,[-7.34,5.26] ,[-7.19,6.48] ,[-7.05,7.59] ,[-6.9,8.82] ,[-6.77,9.83] ,[-6.64,10.9] ,[-6.49,12.06] ,[-6.34,13.29] ,[-6.17,14.6],[-6,16/*1:-2,-16,6,8*/] ,[-5.28,16.88] ,[-4.56,17.63] ,[-3.67,18.36] ,[-2.79,18.9] ,[-1.76,19.33] ,[-0.76,19.53] ,[0.36,19.52] ,[1.41,19.31] ,[2.38,18.94] ,[3.27,18.46] ,[4.16,17.83] ,[4.97,17.13] ,[5.66,16.4],[6,16],[8,0]]);

}

module base() {
    border_width = 10;
    dr = container_bottom_radius;
    bw = border_width;
    
    d = dr + bw * 2;
    r = 20;
    
    dist = dr + distance_between_containers;
    
    pw = 116;
    rw = 56;
    
    y = -12; // nudge forward
    
    // translate([dist, 0]) container();
    // translate([-dist, 0]) container();
    
    difference() {
        union() {
            lid();
            translate([dist, y]) cylinder(40, r=dr+4);
            translate([-dist, y]) cylinder(40, r=dr+4);
            translate([pw, y]) pump_mount();
            translate([-pw, y]) pump_mount();
            translate([0, rw]) rear_wall();
            band();
            mirror() band();

        }
        translate([dist, y]) solenoid_funnel();
        translate([-dist, y]) rotate([180, 180]) solenoid_funnel();
        translate([0, rw-2, 90]) rotate([90, 270, 0]) linear_extrude(1.2) text("synthwave", size=20, halign="center", valign="center");

    }

    module rear_wall() {
        h = rear_wall_height;
        o = rear_wall_thickness;
        w = rear_wall_width / 2;
        
        r = 1.5;
        w2 = 110;
        h2 = 60;
   
        hull() standoffs(h, w, o, r);
        
        difference() {
            translate([0, 0, h-50]) {
                hull() {
                    translate([0, 0, h2+30]) standoffs(0.1, w2, o, r);
                    translate([0, 0, h2]) standoffs(0.1, w2, o, r);
                }
                hull() {
                    translate([0, 0, h2]) standoffs(0.1, w2, o, r);
                    standoffs(0.1, w, o, r);
                }
            }
            
            // These holes should be exactly 25mm above the shelf
            // translate([-84, 1, 190 + 25]) solenoid_screw_holes();
            // translate([84, 1, 190 + 25]) solenoid_screw_holes();
        }
        
        // Lower shelf
        translate([0, 0, 150]) difference() {
            shelf_brackets();
            translate([-60, -16, 30]) rotate([0, 90]) cylinder(120, r=5);
        }
        
        // Upper shelf
        translate([0, 0, 185]) shelf_brackets();
        
            
        
    }
}

module solenoid_screw_holes () {
    x = 38; // distance apart
    r = 2;
    
    rotate([90, 0]) translate([0, 0, -5]) {
        translate([x/2, 0]) cylinder(10, r=r);
        translate([-x/2, 0]) cylinder(10, r=r);
    }
}

module shelf_brackets() {
    translate([50, 0]) shelf_bracket();
    translate([-50, 0]) shelf_bracket();
}

module pump_mount() {
    h = pump_mount_height;
    w = pump_mount_depth;
    d = 25;
    r = 3;

    hull() standoffs(h, w, d, r);
}

module pump_bracket() {
    t = 1.6;
    h = 20;
    y = 22;
    r = 24 / 2;  // outer diameter of pump
    g = 5; // gap
    r1 = 1.5;
    o = 4;
    
    
    difference() {
        union() {
            translate([0, -r + -t]) difference() {
                // translate([0, 5]) cube([t, h, h]);
                cylinder(h, r=r+t);
                cylinder(h, r=r);
            }
            translate([0, 0, h/2]) rotate([90, 0]) hull() standoffs(t, y, h/2, 2);
        }
        translate([-g/2, -10]) cube([g, h, h]);
        pump_bracket_screw_holes();
    }
}

module pump_bracket_screw_holes(r=1.5) {
    h = 20;
    r = 1.5;
    o = 4;
    y = 22;
    
    translate([-y + o, 0]) {
        translate([0, 0, h - o]) rotate([90, 0]) cylinder(10, r=r);
        translate([0, 0, o]) rotate([90, 0]) cylinder(10, r=r);
    }
    translate([y - o, 0]) {
        translate([0, 0, h - o]) rotate([90, 0]) cylinder(10, r=r);
        translate([0, 0, o]) rotate([90, 0]) cylinder(10, r=r);
    }
}

module band() {
    // this is such a hack, but oh well
    r = 70;
    translate([56, -11, 100]) scale(1) intersection() {
        difference() {
            linear_extrude(200) circle(r);
            linear_extrude(200) circle(r - 7);
            translate([0, 0, -10]) rotate([45, 0]) cube(r*2);
            translate([0, r + 35, -r - 45]) rotate([45, 0]) cube(r*2);
        }
        cube(r);
    }       
}

module electrode_grip() {
    h = 20;
    r = 1;
    
    hull () {
        translate([2, 0]) cylinder(h, r=r);
        translate([-2, 0]) cylinder(h, r=r);
    }
    hull () {
        translate([2, 20]) cylinder(h, r=r);
        translate([-2, 20]) cylinder(h, r=r);
    }
}
    
module electrode_holder() {
    w = 20;
    h = 12;
    d = 5;
    r = 1;
    
    difference() {
        hull() standoffs(h, w, d, r);
        translate([0, d/2 + 1.75]) nickel_strip_cutout();
        translate([0, -d/2 - 1.75]) rotate([0, 0, 180]) nickel_strip_cutout();
    }
 
    translate([0, w]) scale(0.6) clip();
}

module nickel_strip_cutout() {
    d = 0.4;
    h = 12;
    w = 35;
    
    translate([0, 0, h/2 + 1]) {
        cube([w, d, h], center=true); // strip
        translate([0, d+1 / 2]) cube([w-2, d+1, h-1], center=true); // window 
        // translate([2, 0, -h/2 + 4]) cylinder(h, r=1.5); // make room for wire
        // translate([2, 5.2, -1.5]) sphere(r=7); // make room for solder blob
    }
}

module shelf_bracket() {
    w = 0.5;
    scale(30) translate([-w/2, 0]) rotate([0, -90, 180]) linear_extrude(w) polygon([[0,0],[1,0],[1,1]]);
}

module clip() {
    y1 = 6;
    y2 = 14;
    linear_extrude(35) polygon([[-15,2],[-2,2],[-2,4],[15,y1],[15,2],[16,2],[16,0],[-16,0],[-60,-5],[-60,-3],[-18,2/*1:0,0,0,0*/] ,[-17.21,2.65] ,[-16.45,3.38] ,[-15.7,4.2] ,[-15.05,5.03] ,[-14.42,5.96] ,[-13.87,7] ,[-13.45,8.12] ,[-13.21,9.11] ,[-13.11,10.15] ,[-13.18,11.24] ,[-13.43,12.35] ,[-13.89,13.49] ,[-14.42,14.43] ,[-15.12,15.37] ,[-16,16.32] ,[-16.78,17.04] ,[-17.68,17.76],[-18,18/*1:11,-8,-3,1*/] ,[-19.13,18.24] ,[-20.2,18.4] ,[-21.53,18.57] ,[-22.68,18.71] ,[-23.96,18.85] ,[-25.34,19] ,[-26.83,19.15] ,[-27.86,19.25] ,[-28.93,19.36] ,[-30.04,19.46] ,[-31.16,19.57] ,[-32.32,19.68] ,[-33.49,19.79] ,[-34.68,19.89] ,[-35.88,20] ,[-37.09,20.11] ,[-38.3,20.22] ,[-39.52,20.32] ,[-40.73,20.43] ,[-41.94,20.53] ,[-43.14,20.63] ,[-44.33,20.73] ,[-45.5,20.83] ,[-46.65,20.93] ,[-47.78,21.02] ,[-48.88,21.11] ,[-49.95,21.2] ,[-50.99,21.28] ,[-51.99,21.37] ,[-53.41,21.48] ,[-54.72,21.58] ,[-55.92,21.68] ,[-56.99,21.76] ,[-58.19,21.86] ,[-59.29,21.94],[-60,22],[-60,24],[-16,20],[16,20],[16,18],[15,18],[15,y2],[-2,16],[-2,18/*1:0,0,0,0*/] ,[-3.05,18] ,[-4.15,18] ,[-5.18,18] ,[-6.34,18] ,[-7.39,18] ,[-8.47,18] ,[-9.56,18] ,[-10.62,18] ,[-11.64,18] ,[-12.73,18] ,[-13.81,18] ,[-14.87,18],[-15,18/*1:2,0,10,-8*/] ,[-14.15,17.28] ,[-13.41,16.56] ,[-12.57,15.61] ,[-11.89,14.66] ,[-11.37,13.73] ,[-10.91,12.58] ,[-10.65,11.46] ,[-10.56,10.37] ,[-10.62,9.32] ,[-10.81,8.32] ,[-11.18,7.18] ,[-11.66,6.13] ,[-12.22,5.18] ,[-12.81,4.33] ,[-13.5,3.48] ,[-14.2,2.73] ,[-14.95,2.04]]);
}

module container() {
    r1 = container_bottom_radius;
    r2 = container_top_radius;
    h = container_height;
    cylinder(h, r1, r2);
    // translate([0, 0, h]) cylinder(h, r2, r2);
}

// translate([100, 0]) solenoid_funnel();

module solenoid_funnel() {
    h = 15;
    r1 = 15;
    r2 = container_bottom_radius;
     
    translate([0, 0, h]) cylinder(h, r1, r2 - 15);
    translate([0, 0, h*2]) container();
    
    translate([0, 0, h]) rotate([180, 0]) ScrewThread(26.670, h, pitch=1.814);
    
    // Hole for drain line
    translate([0, 0, 20]) rotate([90, 0, 90]) cylinder(100, r=4.85);
    
    // english_thread(diameter=1.05, threads_per_inch=14, length=3/4, taper=1/16);
}

module standoffs(h, w, d, r) {
    translate([w-r, d-r]) cylinder(h, r, r);
    translate([w-r, -d+r]) cylinder(h, r, r);
    translate([-w+r, d-r]) cylinder(h, r, r);
    translate([-w+r, -d+r]) cylinder(h, r, r);
}

module screw_brackets(h, w, d, r) {
    translate([w-r, d-r]) rotate([180, 180]) screw_bracket();
    translate([w-r, -d+r]) screw_bracket();
    translate([-w+r, d-r]) rotate([180, 180]) screw_bracket();
    translate([-w+r, -d+r]) screw_bracket();
}

breadboard_cover();

 
module breadboard_cover() {
    f = 3; // fit tolerance
    t = 1.6; // wall thickness
    h = 20;
    r = 2;
    
    x = 55 + f;
    y = (165 + f) / 2;
    
    difference() {
        union() {
            hull() standoffs(h, x+t/2, y+t/2, r);
            translate([0, 0, h]) mirror([0,0,1]) screw_brackets(h, x/2, y+t/2, r);
        }
        translate([0, 0, t]) hull() standoffs(h, x, y, r);
        translate([-y, x, h]) rotate([0, 90]) cylinder(y*2, r=3.5);
        translate([-y, -x, h]) rotate([0, 90]) cylinder(y*2, r=3.5);
        breadboard_cover_screw_holes();
    }
}

module screw_bracket() {
    w = 1;
    scale(15) difference() {
        translate([w/2, 0, w]) rotate([0, 90, 180]) linear_extrude(w) polygon([[0,0],[1,0],[1,1]]);
        scale(0.8) translate([w/2, -0.2, w+0.2]) rotate([0, 90, 180]) linear_extrude(w) polygon([[0,0],[1,0],[1,1]]);
    }
}

module breadboard_cover_screw_holes() {
    f = 3; // fit tolerance
    t = 1.6; // wall thickness
    h = 40;
    r = 2;
    
    x = 55 + f;
    y = (165 + f) / 2 + 8;
    
    standoffs(h, x/2, y+t/2, r);
}
