// Wine cradle
use <2d_points.scad>;
use <threads.scad>;

$fn=100;
min_thickness = 5;
ring_thickness = 1.6;
wine_bottle_diameter = 82;
wine_neck_diameter = 25;
wine_bottle_height = 300;
screw_diameter = 10;

ring_height = 10;
m = min_thickness;
d = 15; //diameter

/*
small_post();
tall_post();
screw();
crank();
big_ring();
small_ring();
nut();
linkage();
shapes();
topper();
*/

nut();

module rivnut() {
    f = 1.1;
    union() {
        cylinder(13.2 * f, 6.8/2 * f, 6.8/2 * f);
        cylinder(1.1 * f, 10/2 * f, 10/2 * f);
    }
}
module small_post() {

    tolerance = 0.01;
    d1 = screw_diameter / 2 + tolerance;
    
    points=[
        [0,0],
        [m + 0, 0],
        [m + 0, 0], 
        [m + 15, 0], 
        [m + 15, 7], 
        [m + 0, 7],
        [m + -2, 7],
        [m + -2, 19],
        [m + 0, 19],
        [m + 0, 20],
        [m + 0, 20], 
        [m + 12, 20],
        [m + 12, 20],
        [m + 12, 20],
        [m + 0, 20],
        [m + 0, 57],
        [m + -4, 60],
        [m + -4, 60],
        [m + 0, 62], 
        [m + 5, 62], 
        [m + 8, 62],
        [m + 10, 62], 
        [m + 10, 62], 
        [m + 5, 62], 
        [m + 0, 62],
        [m + 0, 64],
        [m + -5, 76],
        [m + -5, 76],
        [m + 0, 76],
        [m + 13, 80],
        [m + 13, 80],
        [m + 0, 95],
        [m + 0, 95],
        [0, 95]
    ];
    
    difference() {
        translate([0, 0, -3]) union() {
            translate([0, 50, 0]) scale([1, 1, 0.9]) rotate_extrude() polygon(polybezier_points([points], fn=200));
        }
        
        union() {
            w = 200;
            h = 10;
            // Bottom flattener
            translate([-w/2, -w/2, -h]) cube([w, w, h]);
            
            // Top hole
            translate([0, 60, 73]) rotate([90, 0]) cylinder(20, d1, d1);
            
            // Rivnut cutout
            translate([0, 50]) rivnut();
        }
    }

}
module tall_post() {
        points=[
        [0,0],
        [m + 0, 0], 
        [m + 0, 0],
        [m + 15, 0], 
        [m + 15, 7], 
        [m + 0, 7],
        [m + -2, 7],
        [m + -2, 19],
        [m + 0, 19],
        [m + 0, 20],
        [m + 0, 20], 
        [m + 12, 20],
        [m + 12, 20],
        [m + 12, 20],
        [m + 0, 20],
        [m + 0, 57],
        [m + -4, 60],
        [m + -4, 60],
        [m + 0, 62], 
        [m + 0, 62], 
        [m + 0, 62], 
        [m + 5, 62],
        [m + 5, 62], 
        [m + 5, 62],
        [m + 5, 62], 
        [m + 5, 62],
        [m + 5, 62], 
        [m + 5, 62],
        [m + 0, 62],
        [m + 0, 62],
        [m + 0, 62],
        [m + 0, 64],
        [m + 0, 78],
        [m + 0, 110],
        [m + 0, 110],
        [m + 0, 112], 
        [m + 0, 112], 
        [m + 0, 112],
        [m + 5, 112], 
        [m + 5, 112], 
        [m + 5, 112], 
        [m + 5, 112], 
        [m + 5, 92], 
        [m + 0, 92],
        [m + -3, 94],
        [m + 0, 95],
        [m + 0, 95],
        [m + 0, 155],
        [m + 0, 155],
        [m + -4, 180],
        [m + -4, 180],
        [m + 0, 182], 
        [m + 4, 182], 
        [m + 5, 182],
        [m + 5, 182], 
        [m + 5, 182], 
        [m + 4, 182], 
        [m + 0, 182],
        [m + 0, 184],
        [m + 0, 185],
        [m + 0, 185],
        [m + -5, 190],
        [m + 0, 190],
        [m + 5, 190],
        [m + 5, 200],
        [m + 0, 215],
        [m + 0, 215],
        [0, 215]
    ];
    
    // Tall post
    difference() {
        translate([0, 0, -3]) union() {
            translate([50, 0, 0]) scale([1.5, 1.5, 0.85]) rotate_extrude() polygon(polybezier_points([points], fn=200));
        }
        
        union() {
            w = 200;
            h = 10;
            // Bottom flattener
            translate([-w/2, -w/2, -h]) cube([w, w, h]);
            
            // Top hole
            translate([40, 0, 168]) rotate([90, 0, 90]) cylinder(100, 1.2, 1.2);
            
            // Rivnut cutout
            translate([50, 0]) rivnut();
            
            // Top span cutout
            translate([55, 0, 178]) cube([20, 3, 10], center=true);
        }
    }
    
    
}
module screw() {
    h1 = 70;
    h2 = 100;
    f = 0.95;
    d1 = screw_diameter / 2 * f;
    union() {
        cylinder(h1 + h2 + 10, d1, d1);
        translate([0, 0, h1 - 10])  cylinder(5, d1, d1 + 3.5); // Bottom collar
        translate([0, 0, h1 - 5]) ScrewThread(d, h2, pitch=5, tooth_angle=45);
    }
    cylinder(h1 + h2 + 10, 2.8, 2.8);
}
module nut() {
    h = 3;
    t = 14;
    r = 2;
    
    ScrewHole(d, t, pitch=5, tooth_angle=45, tolerance=0.6)
        translate([-.6, .6]) cylinder(t, d/2 + 2, d/2 + 2, $fn=40);
    
    scale([1, 1, 0.935]) translate([-h/2, t - 5, 15])  rotate([0, 90]) {
        difference() {
            hull() {
                cube([d, d/2, h]);
                translate([d-r, d/2]) cylinder(h, r, r);
                translate([r, d/2]) cylinder(h, r, r);
            }
            translate([d/2, 5]) cylinder(h, 1.6, 1.6);
        }
    }        
}
module linkage() {
    d=4;
    h=100;
    f=1.1; // Fudge factor
    fw = 1.6; // Filament width
    rotate([90, 0, 90]) {
        difference() {
            cylinder(h, d, d);
            union() {
                cube([3*f, d*2*f, 15], center=true);
                translate([-d, 0, 4]) rotate([0, 90]) cylinder(d*2, fw, fw);
                translate([0, 0, h]) {
                    cube([3*f, d*2*f, 15], center=true);
                    translate([-d, 0, -4]) rotate([0, 90]) cylinder(d*2, fw, fw);
                }
            }
        }
        
    }
}
module crank() {
    d1 = screw_diameter;
    t = 2;
    h = 6;
    r1 = 7;
    r2 = 6;
    l = 35;

    
    difference() {
        union() {
            hull(){
                cylinder(h, r1, r1);
                translate([r1*2, 0, 0]) cylinder(h, r2, r2);
            }
            hull(){
                translate([r1, 0, 0]) cylinder(h, r2, r2);
                translate([l-r1, 0, 0]) cylinder(h, r2, r2);
            } 
            translate([l, 0]) hull(){
                cylinder(h, d1/2 + t, d1/2 + t);
                translate([-r1*2, 0, 0]) cylinder(h, r2, r2);
            }
        }
        translate([l, 0]) cylinder(h, d1/2, d1/2); // Hole
    }
    
    scale(0.5) translate([0, 0, 100]) rotate([0, 180]) handle();    
}
module handle() {
    //cylinder(50, 4, 4);
    
    points=[
        [0,0],
        [m + 0, 0],
        [m + 0, 0], 
        [m + 15, 0], 
        [m + 15, 7], 
        [m + 12, 20],
        [m + 12, 20],
        [m + 12, 20],
        [m + 0, 20],
        [m + 0, 57],
        [m + -4, 60],
        [m + -4, 60],
        [m + 0, 62], 
        [m + 5, 62], 
        [m + 8, 62],
        [m + 10, 62], 
        [m + 10, 62], 
        [m + 5, 62], 
        [m + 0, 62],
        [m + 0, 64],
        [m + -5, 78],
        [m + -5, 80],
        [m + 0, 80],
        [m + 10, 80],
        [m + 10, 80],
        [m + 0, 95],
        [m + 0, 95],
        [0, 95]
    ];
    rotate_extrude() polygon(polybezier_points([points], fn=200));
}
module shapes() {
    scale(0.8) linear_extrude(20) import("./shapes.svg");
}
module topper() {
    translate([-100, -150]) scale(0.8) linear_extrude(2.9) import("./topper.svg");
}