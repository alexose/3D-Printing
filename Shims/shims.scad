inch = 25.4;

module shim(w_in, d_in, h_in) {
    cube([w_in * inch, d_in * inch, h_in * inch]);
}

translate([0, 0, 0])
    shim(3.5, 3.5, 0.25);

translate([3.5 * inch + 10, 0, 0])
    shim(1.5, 3.5, 0.25);
