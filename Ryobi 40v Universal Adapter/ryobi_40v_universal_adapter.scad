r = 2.5;

hull() corners([10, 10], o=r) cylinder(3, r=r);

module corners(dimensions=[1,1], o=0) {
    x = dimensions[0];
    y = dimensions[1];
  
    translate([-x, y]) children();
    translate([x, y]) children();
    translate([-x, -y]) children();
    translate([x, -y]) children();
}