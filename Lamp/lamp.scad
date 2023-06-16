r = 80;
h = 90;
t = 1.2;

difference(){
    cylinder(h,r,r, $fn=360);
    cylinder(h+1,r-t,r-t, $fn=360);
}


translate([-r, -5, 0]) cube([r*2, 10, t*2]);
rotate([0, 0, 90]) translate([-r, -5, 0]) cube([r*2, 10, t*2]);