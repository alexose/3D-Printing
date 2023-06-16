// Spacers for wheelbarrow replacement wheel
r = 18/2;
t = 3;
h = 23;
$fn = 100;

difference() {
    cylinder(h, r+t, r+t);
    cylinder(h, r, r);
}