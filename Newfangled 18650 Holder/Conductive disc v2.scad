use <threads.scad>;

number_of_cells = 3;
distance_apart = 11;
plate_radius = 21;

// number_of_cells = 5;
// distance_apart = 18;
// plate_radius = 30;

$fn = 100;
plate_height = 4;
thread_height = plate_height*2;
tolerance = 0.3;
cell_height = 65;
cell_radius = 18 / 2 + tolerance;


plate();
translate([-plate_radius*2 - 3, 0]) cap();
translate([plate_radius*2 + 3, 0]) tube();

module plate() {
    p = distance_apart;
    h = plate_height;
    hole_radius = 1.5; // Size of hole in middle
    
    difference() {
        union() {
            lip();
            radial_multiply(p) tab();
            cell_spacers();
        }
        union() {
            cylinder(30, r=hole_radius);
        }
    } 
 
    module tab() {
        r = 5; // Tab radius
        w = 0.5; // Wire radius
        difference(){
            cylinder(h,r=r);
            
            union() {
                translate([0, 0, h + 0.3]) torus(r*0.7, w+0.1);
        
                // Kind of a cheesy way of doing this, but oh well
                translate([-1, 3.27, 4.5]) rotate([110, 0, -64]) cylinder(r+1, r=w);
                translate([-1, -3.27, 4.5]) rotate([110, 0, -116]) cylinder(r+1, r=w);
            }
        }

    }

    module cell_spacers() {
        hs = 20;
        rr = 2;
        difference() {
            scale([1, 1, 0.1]) hull() cells(0.7);
            r = 18 / 2;
            union() {
                cells();
                translate([0, 0, h/2]) cylinder(hs, r=4.5);
            }
        }   
    }

    module torus(r, d) {
      $fn=50;
      rotate_extrude(convexity=10) {
        translate([r,0,0]) circle(d);
      }
    } 
    
    
    module lip() {
       // Create lip so that it's easier to pry out the plate with your fingernail
        difference() {
            cylinder(h/2, r=plate_radius);
            translate([0, 0, h/4]) difference() {
                hull() cells(7);
                hull() cells(3);
            }
        }
    }
}
module cap() {
    t = 1.4; // thickness
    h = thread_height + t;
    r = plate_radius + tolerance + t;
    f = tolerance; // tolerance fudge factor for plate
    
    translate([0, 0, t]) ScrewHole(r*2 + f, thread_height, pitch=3, tooth_angle=55) {
        translate([0, 0, -t]) rounded_cylinder(r=r+t,h=h,n=2,$fn=60);
    }
    
    module rounded_cylinder(r,h,n) {
      rotate_extrude(convexity=1) {
        offset(r=n) offset(delta=-n) square([r,h]);
        square([n,h]);
      }
    }

}
module tube() {
    t = 1.4; // thickness
    f = tolerance;
    
    ph = plate_height/2;
    h = thread_height - ph;
    
    mh = cell_height - (ph * 2) - h; // Middle section height
    
    r = plate_radius + tolerance + t;
 
    difference() {
        union(){
            ScrewThread(r*2 + f, h, pitch=3, tooth_angle=45);
            translate([0, 0, h]) middle_section();
            translate([0, 0, h + mh]) ScrewThread(r*2 + f, h, pitch=3, tooth_angle=55);
        }
        hull() cells(0.8);
    }
    
    module middle_section() {
        r = 10 + t;  // 11.5 diameter
        p = distance_apart;
        r1 = plate_radius + t;
        r2 = r1 - 15;
        
        cylinder(mh, r1, r2);
        hull() radial_multiply(p) cylinder(mh, r=r);
        translate([0, 0, mh]) rotate([0, 180]) cylinder(mh, r1, r2);
    }
}

module cells(tolerance=0.3) {
    r = cell_radius;
    p = distance_apart;
    h = cell_height + plate_height;
    radial_multiply(p) cylinder(h, r=r + tolerance);
}

module radial_multiply(distance_apart) {
    p = distance_apart;    
    step =  360 / number_of_cells;
    
    for (i = [0 : step : 360 ]) {
        translate([p, 0]) children(0);
        rotate([0, 0, i]) translate([p, 0]) children();
        rotate([0, 0, i]) translate([p, 0]) children();
    }
}
