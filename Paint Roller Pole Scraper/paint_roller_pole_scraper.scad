$fn=50;

// http://dkprojects.net/openscad-threads/threads.scad
use <../threads.scad>

// inner diameter of pipe
pipe_id=20.4;
// how deep attachment should sit in pipe
pipe_depth=40;
// flatten one side (no supports required)
flatten=true;

difference() {
   union() {
       translate([0,5,- pipe_id / 2 + 2]) scraper();
       rotate([90,-45,0]) {
          metric_thread(diameter=18, pitch=5, length=22, internal=false, square=true, leadin=1);
          //taper out the last thread a little
          cylinder(d2=13, d1=16, h=5);
          translate([0,0,-4]) cylinder(d=max(23, pipe_id+2), h=4);
       }
   }
   if (flatten)
      translate([0,0,-58]) cube(100, center=true);
}


module scraper() {
    hull() {
        corners([8, 0]) cylinder(1.6, r=3);
        translate([0, 40]) corners([12, 0]) cylinder(1.2, r=3);
        translate([0, 44]) corners([12, 0]) cylinder(0.4, r=3);
    }
}

module corners(dimensions=[1,1], o=0) {
    x = dimensions[0];
    y = dimensions[1];
  
    translate([-x, y]) children();
    translate([x, y]) children();
    translate([-x, -y]) children();
    translate([x, -y]) children();
}
