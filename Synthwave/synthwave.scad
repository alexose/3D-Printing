use <threads.scad>

container_bottom_radius = 89 / 2;
container_top_radius = 112 / 2;
container_height = 135.3;

pump_mount_depth = 10;
pump_mount_height = container_height + 15;

rear_wall_depth = 5;
rear_wall_height = 15;

distance_between_containers = 30;

$fn = 80;

// base();
// back();
electrode_holder();
// cbracket();
// fancy_clip();

module base() {
    border_width = 10;
    h = 3;
    dr = container_bottom_radius;
    bw = border_width;
    
    w = dr * 2 + bw * 2 + distance_between_containers;
    d = dr + bw * 2;
    r = 20;
    
    dist = dr + distance_between_containers;
    
    pw = w - pump_mount_depth / 2 - 10;
    rw = d - 5;
    
    y = -12; // nudge forward
    
    // translate([dist, 0]) container();
    // translate([-dist, 0]) container();
    
    difference() {
        union() {
            hull() standoffs(h, w, d, r);
            translate([dist, y]) cylinder(40, r=dr+4);
            translate([-dist, y]) cylinder(40, r=dr+4);
            translate([pw, y]) pump_mount();
            translate([-pw, y]) pump_mount();
            translate([0, rw]) rear_wall();
        }
        translate([dist, y]) solenoid_funnel();
        translate([-dist, y]) solenoid_funnel();
    }
}

module back(){
    w = 85;
    h = 200;
    d = 2;
    r = 2.5;
    
    box_width = 266.7 / 2;
    box_height = 40;
    
    shelf_width = 100;
    shelf_depth = 58;
    
    rotate([-90, 0]) {
        difference() {
            union() {
                translate([0, 0, 14]) hull() scale(0.99) standoffs(h,w,d,r);
                translate([0, 0, h - box_height/2]) hull() scale(0.99) standoffs(box_height,box_width,d,r);
                mount_points(0.99);
                translate([0, 62/2, h + box_height/2 - 3]) cube([w, 62, 5], center=true);
                translate([-6/2 + 30, 0, h + box_height/2 - 3]) rotate([0, 90]) linear_extrude(6) scale(3) polygon([[0,0],[8,0],[0,8]]);
                translate([-6/2 - 30, 0, h + box_height/2 - 3]) rotate([0, 90]) linear_extrude(6) scale(3) polygon([[0,0],[8,0],[0,8]]);

            }
            translate([0, 2, 105]) rotate([90, 270, 180]) linear_extrude(1.2) text("synthwave", size=18, halign="center", valign="center");
        }
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

module cbracket() {
    // quarter circle
    r = 70;
    intersection() {
        difference() {
            linear_extrude(10) circle(r);
            linear_extrude(10) circle(r - 3);
        }
        cube(r);
    }
    
    
}

module clip() {
    y1 = 6;
    y2 = 14;
    linear_extrude(35) polygon([[-15,2],[-2,2],[-2,4],[15,y1],[15,2],[16,2],[16,0],[-16,0],[-60,-5],[-60,-3],[-18,2/*1:0,0,0,0*/] ,[-17.21,2.65] ,[-16.45,3.38] ,[-15.7,4.2] ,[-15.05,5.03] ,[-14.42,5.96] ,[-13.87,7] ,[-13.45,8.12] ,[-13.21,9.11] ,[-13.11,10.15] ,[-13.18,11.24] ,[-13.43,12.35] ,[-13.89,13.49] ,[-14.42,14.43] ,[-15.12,15.37] ,[-16,16.32] ,[-16.78,17.04] ,[-17.68,17.76],[-18,18/*1:11,-8,-3,1*/] ,[-19.13,18.24] ,[-20.2,18.4] ,[-21.53,18.57] ,[-22.68,18.71] ,[-23.96,18.85] ,[-25.34,19] ,[-26.83,19.15] ,[-27.86,19.25] ,[-28.93,19.36] ,[-30.04,19.46] ,[-31.16,19.57] ,[-32.32,19.68] ,[-33.49,19.79] ,[-34.68,19.89] ,[-35.88,20] ,[-37.09,20.11] ,[-38.3,20.22] ,[-39.52,20.32] ,[-40.73,20.43] ,[-41.94,20.53] ,[-43.14,20.63] ,[-44.33,20.73] ,[-45.5,20.83] ,[-46.65,20.93] ,[-47.78,21.02] ,[-48.88,21.11] ,[-49.95,21.2] ,[-50.99,21.28] ,[-51.99,21.37] ,[-53.41,21.48] ,[-54.72,21.58] ,[-55.92,21.68] ,[-56.99,21.76] ,[-58.19,21.86] ,[-59.29,21.94],[-60,22],[-60,24],[-16,20],[16,20],[16,18],[15,18],[15,y2],[-2,16],[-2,18/*1:0,0,0,0*/] ,[-3.05,18] ,[-4.15,18] ,[-5.18,18] ,[-6.34,18] ,[-7.39,18] ,[-8.47,18] ,[-9.56,18] ,[-10.62,18] ,[-11.64,18] ,[-12.73,18] ,[-13.81,18] ,[-14.87,18],[-15,18/*1:2,0,10,-8*/] ,[-14.15,17.28] ,[-13.41,16.56] ,[-12.57,15.61] ,[-11.89,14.66] ,[-11.37,13.73] ,[-10.91,12.58] ,[-10.65,11.46] ,[-10.56,10.37] ,[-10.62,9.32] ,[-10.81,8.32] ,[-11.18,7.18] ,[-11.66,6.13] ,[-12.22,5.18] ,[-12.81,4.33] ,[-13.5,3.48] ,[-14.2,2.73] ,[-14.95,2.04]]);
}

module fancy_clip() {
    linear_extrude(35) polygon([[-15,2/*1:5,4,3,0*/] ,[-13.91,2] ,[-12.8,2] ,[-11.7,2] ,[-10.7,2] ,[-9.66,2] ,[-8.6,2] ,[-7.55,2] ,[-6.53,2] ,[-5.4,2] ,[-4.38,2] ,[-3.27,2] ,[-2.23,2],[-2,2],[-2,4],[15,4],[15,2],[16,2],[16,0],[-16,0],[-70,-13/*1:0,0,0,0*/] ,[-70,-12],[-70,-11/*1:0,0,0,0*/] ,[-68.81,-10.7] ,[-67.59,-10.4] ,[-66.43,-10.11] ,[-65.08,-9.77] ,[-64.08,-9.52] ,[-63.01,-9.25] ,[-61.87,-8.97] ,[-60.67,-8.67] ,[-59.42,-8.35] ,[-58.11,-8.03] ,[-56.75,-7.69] ,[-55.35,-7.34] ,[-53.91,-6.98] ,[-52.44,-6.61] ,[-50.94,-6.24] ,[-49.42,-5.86] ,[-47.89,-5.47] ,[-46.34,-5.08] ,[-44.78,-4.69] ,[-43.22,-4.31] ,[-41.66,-3.92] ,[-40.11,-3.53] ,[-38.58,-3.14] ,[-37.06,-2.76] ,[-35.56,-2.39] ,[-34.09,-2.02] ,[-32.65,-1.66] ,[-31.25,-1.31] ,[-29.89,-0.97] ,[-28.58,-0.65] ,[-27.33,-0.33] ,[-26.12,-0.03] ,[-24.99,0.25] ,[-23.92,0.52] ,[-22.92,0.77] ,[-21.57,1.11] ,[-20.41,1.4] ,[-19.19,1.7] ,[-18.14,1.97],[-18,2/*1:0,0,0,0*/] ,[-17.21,2.65] ,[-16.45,3.38] ,[-15.7,4.2] ,[-15.05,5.03] ,[-14.42,5.96] ,[-13.87,7] ,[-13.45,8.12] ,[-13.21,9.11] ,[-13.11,10.15] ,[-13.18,11.24] ,[-13.43,12.35] ,[-13.89,13.49] ,[-14.42,14.43] ,[-15.12,15.37] ,[-16,16.32] ,[-16.78,17.04] ,[-17.68,17.76],[-18,18/*1:11,-8,-3,1*/] ,[-19.03,18.3] ,[-20.21,18.64] ,[-21.34,18.94] ,[-22.65,19.3] ,[-23.62,19.56] ,[-24.66,19.84] ,[-25.77,20.14] ,[-26.94,20.45] ,[-28.17,20.77] ,[-29.45,21.11] ,[-30.77,21.47] ,[-32.14,21.83] ,[-33.55,22.2] ,[-34.99,22.58] ,[-36.46,22.97] ,[-37.95,23.36] ,[-39.47,23.76] ,[-40.99,24.16] ,[-42.53,24.56] ,[-44.08,24.97] ,[-45.62,25.38] ,[-47.17,25.78] ,[-48.7,26.18] ,[-50.22,26.58] ,[-51.73,26.97] ,[-53.21,27.36] ,[-54.66,27.74] ,[-56.09,28.11] ,[-57.47,28.47] ,[-58.82,28.83] ,[-60.12,29.17] ,[-61.37,29.49] ,[-62.56,29.8] ,[-63.7,30.1] ,[-64.77,30.38] ,[-65.78,30.64] ,[-67.14,31] ,[-68.33,31.3] ,[-69.31,31.56] ,[-70.3,31.82],[-71,32],[-71,34],[-16,20],[16,20],[16,18],[15,18],[15,16/*1:0,0,0,0*/] ,[13.97,16] ,[12.89,16] ,[11.75,16] ,[10.67,16] ,[9.5,16] ,[8.27,16] ,[7.26,16] ,[6.25,16] ,[5.23,16] ,[3.98,16] ,[2.79,16] ,[1.67,16] ,[0.66,16] ,[-0.39,16] ,[-1.43,16],[-2,16/*1:0,0,0,0*/] ,[-2,17],[-2,18/*1:0,0,0,0*/] ,[-3.05,18] ,[-4.15,18] ,[-5.18,18] ,[-6.34,18] ,[-7.39,18] ,[-8.47,18] ,[-9.56,18] ,[-10.62,18] ,[-11.64,18] ,[-12.73,18] ,[-13.81,18] ,[-14.87,18],[-15,18/*1:2,0,5,-5*/] ,[-14.29,17.28] ,[-13.56,16.49] ,[-12.84,15.67] ,[-12.19,14.86] ,[-11.61,14.02] ,[-11.12,13.13] ,[-10.94,12.13],[-11,12],[-2,12],[-2,15],[15,15],[15,5],[-2,5],[-2,8],[-11,8/*1:0,0,0,0*/] ,[-10.98,6.99] ,[-11.32,6.05] ,[-11.87,5.14] ,[-12.5,4.35] ,[-13.23,3.56] ,[-14.04,2.81] ,[-14.85,2.12]]);

}

module container() {
    r1 = container_bottom_radius;
    r2 = container_top_radius;
    h = container_height;
    cylinder(h, r1, r2);
}

module rear_wall() {
    h = rear_wall_height;
    d = rear_wall_depth;
    w = 80;
    r = 3;
    
    difference() {
        hull() standoffs(h, w, d, r);
        mount_points();
    }
}

module mount_points(s=1) {
    translate([17, 0, 5]) scale(s) mount_point();
    translate([50, 0, 5]) scale(s) mount_point();
    translate([-17, 0, 5]) scale(s) mount_point();
    translate([-50, 0, 5]) scale(s) mount_point();
}

module mount_point() {
    hull() standoffs(10, 10, 2, 2.5);
}

module pump_mount() {
    h = pump_mount_height;
    w = pump_mount_depth;
    d = 25;
    r = 3;
    
    hull() standoffs(h, w, d, r);
}

module solenoid_funnel() {
    h = 10;
    r1 = 15;
    r2 = container_bottom_radius;
     
    translate([0, 0, h]) cylinder(h, r1, r2 - 15);
    translate([0, 0, h*2]) container();
    
    translate([0, 0, h]) rotate([180, 0]) ScrewThread(26.670, h, pitch=1.814);
    // english_thread(diameter=1.05, threads_per_inch=14, length=3/4, taper=1/16);
}

module standoffs(h, w, d, r) {
    translate([w-r, d-r]) cylinder(h, r, r);
    translate([w-r, -d+r]) cylinder(h, r, r);
    translate([-w+r, d-r]) cylinder(h, r, r);
    translate([-w+r, -d+r]) cylinder(h, r, r);
}
