// Starlink Mini Magnet Battery Mount
//
// A rechargable, 18650-powered battery mount for the Starlink Mini, designed to be quickly and easily secured
// to any metallic surface using neodymium magnets.
//
// The mount is designed to be 3D printed in two parts:
//
// 1. The bottom, which houses the batteries, BMS, and four magnetic "feet" that are attached with captive ball sockets
// 2. The top, which is made to secure and protect the Starlink Mini against the bottom.
//
// The top and the bottom are joined together using four M3 screws, which are inserted from the bottom and secured with
// M3 nuts.  See the assembly instructions for more information.
//
// This project is licensed under the terms of the MIT license.
// See LICENSE for more information.

// TODO: Makita battery holder design.  Let's recreate it in openscad
// TODO: Wire routing from battery to starlink
// TODO: Feet design.  Use threads?  I think that could be neat.

starlink_mini_width = 259;
starlink_mini_height = 298.5;

battery_bank_width = 102;
battery_bank_height = 65;

//top();
bottom();
//rotate([270, 0]) battery_mount();
//makita_cutout();


module starlink_mini() {
    rotate([270, 0]) import("Starlink_G4_Mini_Dish.stl");
}

module battery_mount() {
    // via https://www.thingiverse.com/thing:352094/comments
    scale(24.5) rotate([180, 0]) import("Makita_Battery_Mount_Final.stl");
}

module battery_mount_cutout() {
    // TODO: this could be improved somewhat
    hull() scale([1.01, 1.01, 1.5]) battery_bank();
}

module makita_cutout() {
    x1 = 23;
    y1 = 10;
    x2 = 18;
    y2 = 20;
    
    translate([-3, 0, 0]) {
        translate([-7, 0]) hull() corners([x1, y1]) cylinder(10, r=1);
        hull() corners([x2, y2]) cylinder(10, r=1);
    }
    
    //
}

module top() {
    x = starlink_mini_width / 2;
    y = starlink_mini_height /2;
    h = 10; // Height
    r = 10; // Corner radius
    o = 20; // Offset
    d = 50; // Depth
    
    //starlink_mini();
    difference() {
        hull() corners([x, y]) cylinder(h, r=r);
        hull() corners([x-d, y+d]) cylinder(h, r=r);
        hull() corners([x+d, y-d]) cylinder(h, r=r);
        hull() corners([x-o, y-o]) cylinder(h, r=r);
        starlink_mini();
    }
}

module bottom() {
    x = starlink_mini_width / 2;
    y = starlink_mini_height / 2;
    h = 50; // Height
    r = 10; // Corner radius
    o = 20; // Offset
    d = 40; // Depth
    a = -12; // Angle
    f = 10; // Additional height
    
    /*
    difference() {
        translate([0, 0, d]) rotate([a, 0]) hull() corners([x, y]) cylinder(1, r=r);
        rotate([a, 0]) hull() translate([0, 0, 40])  starlink_mini();
    }
    */
    
    difference() {
        hull() {
            corners([x, y+o]) cylinder(1+f, r=r);
            translate([0, 0, d]) rotate([a, 0]) corners([x, y+o]) cylinder(1+f, r=r);
        }
        translate([0, 10, d+f]) {
            rotate([a, 0]) hull() starlink_mini();
        }
        translate([0, -y - 12, 38]) color("blue") {
            hull() battery_mount();
            translate([30, 0]) hull() rotate([0, 180]) battery_mount();
        }
    }
    
    translate([0, -y - 12, 38]) color("blue") battery_mount();
}

// Places a child module in each corner of a square, specified by the dimensions parameter. 
module corners(dimensions=[1,1], o=0) {
    x = dimensions[0];
    y = dimensions[1];
  
    translate([-x, y]) children();
    translate([x, y]) children();
    translate([-x, -y]) children();
    translate([x, -y]) children();
}
