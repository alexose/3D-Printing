use <threads.scad>;

// TODO:
// I had this idea that the conductive plate could actually be two pieces.  The first is a flat plate with
// posts on it.  You would wrap the wire around the posts in a particular order.  Then, a second piece
// snaps down on top of it, locking the wire in place.
//
// The goal is to make it really easy to wind the wire, and also really durable.  More thinking on this is
// needed.

number_of_cells = 3;
distance_apart = 11;
plate_radius = 21.6;

// number_of_cells = 5;
// distance_apart = 18;
// plate_radius = 30;

$fn = 100;
plate_height = 4;
thread_height = plate_height*2;
tolerance = 0.3;
cell_height = 65;
cell_radius = 18 / 2 + tolerance;


// plate();
// translate([-plate_radius*2 - 3, 0]) cap();
translate([plate_radius*2 + 3, 0]) tube();

module plate() {
    p = distance_apart;
    h = plate_height;
    hole_radius = 1.5; // Size of hole in middle
    tab_radius = 6;
    
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
        r = tab_radius;
        th = h - 1; // Tab height
        w = 0.75; // Wire radius
        c = 5; // Cutout width.  This is the bit that needs to be bridged.
        bt = 0.6; // Bridge thickness
        bd = 3; // Bridge depth
        
        
        difference(){
            cylinder(th,r=r);
            r1 = r*2;
            translate([0, c/2, 0]) rotate([90, 0]) cylinder(c, r=r1);
        }
        translate([0, 0, th - bt/2]) cube([bd, r, bt] , center=true);
        
    }

    module cell_spacers() {
        hs = 20;
        rr = 2;
        difference() {
            scale([1, 1, 0.25]) hull() cells(0.1);
            r = 18 / 2;
            union() {
                cells(0.2);
                translate([0, 0, h/2]) cylinder(hs, r=5);
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
            
             // Cutout to give us a little more room
            radial_multiply(p) translate([0, 0, 0]) cylinder(3, r = tab_radius);

        }
        
    }
}
module cap() {
    t = 1.4; // thickness
    h = thread_height + t;
    r = plate_radius + tolerance + t;
    f = tolerance; // tolerance fudge factor for plate
    
    difference() {
        translate([0, 0, t]) ScrewHole(r*2 + f, thread_height, pitch=3, tooth_angle=55) {
            translate([0, 0, -t]) rounded_cylinder(r=r+t,h=h,n=2,$fn=60);
        }
        cylinder(h, r=t);
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
        hull() cells(1);
    }
    
    module middle_section() {
        r = 10 + t;  // 11.5 diameter
        p = distance_apart;
        r1 = plate_radius + t;
        r2 = r1 - 15;
        
        difference() {
            union() {
                cylinder(mh, r1, r2);
                hull() radial_multiply(p) cylinder(mh, r=r + 5);
                translate([0, 0, mh]) rotate([0, 180]) cylinder(mh, r1, r2);
            }
            difference() {
                cylinder(mh, r = r1 + 5);
                cylinder(mh, r = r1);
            }
        }
        

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
