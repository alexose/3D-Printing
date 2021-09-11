dot_dist = 8.35394;
length = 160;

difference() {
    cube([0.8, length, 10]);
    for(i = [0:length/dot_dist]) translate([0, i*dot_dist, 1]) cube([1.5, 3.4, 1.9]);
    for(i = [0:length/dot_dist]) translate([0, i*dot_dist, 7]) cube([1.5, 3.4, 1.9]);
}