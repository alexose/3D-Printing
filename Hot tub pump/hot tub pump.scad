include <threads.scad>;

fn = 300;
width = 50;
width2 = 25;
gap = 2.25;
nozzle_height = 40;
tube_height = 145; // 145
thread_height = 7;
wall_thickness = 1.5;
cylinder_width = width2 + gap;

/*
translate([0, 0, thread_height]) rotate([0, 180, 0]) difference() {
    union() {
        translate([0,0,thread_height]) cylinder(nozzle_height, cylinder_width + wall_thickness, 10, $fn=fn);
        metric_thread(diameter=47, pitch=1.5, length=thread_height);
    }
    cylinder(nozzle_height + thread_height, 20, 10 - wall_thickness, $fn=fn);
}

inner = cylinder_width - wall_thickness;
outer = cylinder_width;


difference() {
    cylinder(thread_height*2, outer, outer, $fn=fn);
    cylinder(thread_height*2, inner, inner, $fn=fn);
}

// Add twist-loc nubs
intersection() {
    for (i = [0:2]) {
        rotate([0, 0, i*120]) translate([0, cylinder_width + wall_thickness, 7]) {
            rotate([90, 0, 0]) cylinder(5, 4, 4, center=true, $fn=fn);
        }
    }
    cylinder(thread_height*2, cylinder_width + wall_thickness, cylinder_width + wall_thickness, $fn=fn);   
}

*/


module hole(f=1.00) {
    cylinder(10*f, 4*f, 4*f, center=true, $fn=fn);
}

f = 1.02; // fudge factor

difference() {
    w1 = cylinder_width + wall_thickness * f;
    w2 = 19.05/2;
    translate([0, 0, tube_height]) cylinder(wall_thickness * 10, w1, w2, $fn=fn);
    translate([0, 0, tube_height]) cylinder(wall_thickness * 10, w1-wall_thickness, w2-wall_thickness, $fn=fn);
}

translate([0, 0, tube_height + wall_thickness * 10 ]) difference() {
    english_thread(diameter=3/4, threads_per_inch=11.5, length=0.5);
    cylinder(30, r=19.05/2 - wall_thickness );
}

difference(){
    cylinder(tube_height, r=cylinder_width + wall_thickness * f, $fn=fn);
    cylinder(tube_height, r=cylinder_width * f, $fn=fn);
    
    
    // Add twist-loc holes
    for (i = [0:2]) {
        rotate([0, 0, i*120]) translate([0, cylinder_width + wall_thickness, 6]) {
            rotate([90, 0, 0]) {
                translate([0, 0.2, 0]) hole();
                hull() {
                    translate([0, 0.3, 0]) hole();
                    translate([6.5, 0, 0]) hole();
                }
                hull() {
                    translate([6.5, 0, 0]) hole();
                    translate([6.5, -10, 0]) hole();
                }

            }
        }
    }
    

}

