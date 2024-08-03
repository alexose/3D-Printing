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

// TODO: 6s2p battery bank
// TODO: Feet design

starlink_mini_width = 259;
starlink_mini_height = 298.5;

battery_bank_width = 102;
battery_bank_height = 65;

//top();
bottom();


module starlink_mini() {
    rotate([270, 0]) import("Starlink_G4_Mini_Dish.stl");
}

module battery_bank() {
    // made via:
    // flexbatter(n=6,m=2,deepen=0.70,deepen=0.70,df=0.30,oh=ew,l=65.2,lcorr=0.3,d=18.4,hf=0.75,shd=0,eps=0.28);

    w = battery_bank_width / 2;
    h = battery_bank_height / 2;
    
    translate([-w, -h]) import("18650_X6.stl");
}

module battery_bank_cutout() {
    // TODO: this could be improved somewhat
    hull() scale([1.01, 1.01, 1.5]) battery_bank();
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
    y = starlink_mini_height /2;
    h = 50; // Height
    r = 10; // Corner radius
    o = 20; // Offset
    d = 50; // Depth
    
    //starlink_mini();
    
   
    
    difference() {
        hull() corners([x, y]) cylinder(h, r=r);
        translate([0, 0, 50]) {
            starlink_mini();
            rotate([0, 0, 180]) starlink_mini();
        }
        translate([0, 0, 18]) hull() corners([45, 20]) cylinder(100, r=r);
         translate([0, -30, -38]) rotate([-10, 0]) battery_bank_cutout();
    }
    
    color("blue") translate([0, -30, -23]) rotate([-10, 0]) battery_bank();
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
