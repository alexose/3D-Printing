include <../threads.scad>;
difference(){ 
    english_thread(1.375, 24, 0.2);
    translate([0,0,1.2]) english_thread(3/8, 24, 0.2);
    cylinder(10, 1, 1, center=true, $fn=100);
}