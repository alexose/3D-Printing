use <threads.scad>;

$fn = 100;
plate_radius = 22;
plate_height = 5;
thread_height= plate_height*2;
tolerance = 0.3;

// plate();
translate([-plate_radius*2 - 2, 0]) cap();
// translate([plate_radius*2 + 2, 0]) tube();

module plate() {
    r = 8;; // Tab radius
    p = 12; // Distance apart
    h = plate_height;
    hole_radius = 1.5; // Size of hole in middle
    
    difference() {
        union() {
            cylinder(h/2, r=plate_radius);
            translate([p, 0]) tab();
            rotate([0, 0, 120]) translate([p, 0]) tab();
            rotate([0, 0, 240]) translate([p, 0]) tab();
        }
        cylinder(h, r=hole_radius);
    } 
 
    module tab() {
        scale([0.8, 0.8, 1]) difference(){
            cylinder(h,r=r);
            union() {
                translate([0, 0, h + 0.5]) torus(r*0.7, 0.9);
                scale(0.67) translate([-r+1, 0, h+4]) rotate([-12, -5, -88]) clothoid_loop();
            }
        }
        
        h1 = 8;
        r1 = 18 / 2; // aka, 18650
        f = 0.5;
        t = 1;
        
        // Cell protector
        difference() {
            cylinder(h1, r1+f+t, r1+f+t);
            union() {
                cylinder(h1, r1+f, r1+f);
                translate([r1*2 - 4, 0]) cube(size=r1 + 12, true); 
                translate([-r1-t*2, 0, h-1]) rotate([0, 90]) cylinder(t*2, r=1);
            }
        }
    }


    module torus(r, d) {
      $fn=50;
      rotate_extrude(convexity=10) {
        translate([r,0,0]) circle(d);
      }
    }

    module clothoid_loop() {
        $fn=20;
        amount = 42;
        function clothoid(t, A) = [
            A * (t * cos(amount * PI * t^2)),
            A * (t * sin(amount * PI * t^2))
        ];

        A = 20; // Scale factor
        num_points = 50; // Number of points to approximate the curve

        clothoid_points = [for (i = [0 : num_points - 1]) clothoid(i / (num_points - 1), A)];

        module hull_between_spheres(p1, p2, radius) {
            hull() {
                translate(p1) sphere(r=radius);
                translate(p2) sphere(r=radius);
            }
        }

        sphere_radius = 1.2;
        rotate_gap = 1.5;
        
        rotate([rotate_gap, 0, 0]) {
            for (i = [0 : len(clothoid_points) - 2]) {
                hull_between_spheres(clothoid_points[i], clothoid_points[i + 1], sphere_radius);
            }
        }

        // Go the other direction
        rotate([rotate_gap, 180, 0]) {
            for (i = [0 : len(clothoid_points) - 2]) {
                hull_between_spheres(clothoid_points[i], clothoid_points[i + 1], sphere_radius);
            }
        }
    } 
}
module cap() {
    t=1.5; // thickness
    h = thread_height + t;
    r = plate_radius + t;
    f = tolerance; // tolerance fudge factor for plate
    
    translate([0, 0, t]) ScrewHole(plate_radius*2 + f, thread_height, pitch=3, tooth_angle=45) {
        translate([0, 0, -t]) rounded_cylinder(r=r,h=h,n=2,$fn=60);
    }
    
    module rounded_cylinder(r,h,n) {
      rotate_extrude(convexity=1) {
        offset(r=n) offset(delta=-n) square([r,h]);
        square([n,h]);
      }
    }

}
module tube() {
    t = 1.5; // thickness
    f = tolerance;
    
    ph = plate_height/2;
    h = thread_height - ph;
    
    ch = 65; // Cell height
    mh = ch - (ph * 2) - h; // Middle section height
    
    r = plate_radius + tolerance + t;
 
    difference() {
        union(){
            ScrewThread(r*2 + f, h, pitch=3, tooth_angle=45);
            translate([0, 0, h]) middle_section();
            translate([0, 0, h + mh]) ScrewThread(r*2 + f, h, pitch=3, tooth_angle=45);
        }
        union() {
            hull() {
                r = 10;
                p = 12;
                h = ch + plate_height;
                
                translate([p, 0]) cylinder(h, r=r);
                rotate([0, 0, 120]) translate([p, 0]) cylinder(h, r=r);
                rotate([0, 0, 240]) translate([p, 0]) cylinder(h, r=r);
            }
            // cylinder(ph, r=r-t);
            // translate([0, 0, ch + ph]) cylinder(ph, r=r-t);
        }
    }
    
    module middle_section() {
        r = 10 + t;  // 11.5 diameter
        p = 12;
        r1 = plate_radius + t;
        r2 = r-4;
        
        cylinder(mh, r1, r2);
        hull() {
            translate([p, 0]) cylinder(mh, r=r);
            rotate([0, 0, 120]) translate([p, 0]) cylinder(mh, r=r);
            rotate([0, 0, 240]) translate([p, 0]) cylinder(mh, r=r);
        }
        translate([0, 0, mh]) rotate([0, 180]) cylinder(mh, r1, r2);
    }
}
