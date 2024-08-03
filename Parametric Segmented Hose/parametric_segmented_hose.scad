// This is a segmented flexible hose that can be any width or length.  Simply snap
// the sections together, and it will hold its shape.
// 
// Inspired by https://www.thingiverse.com/thing:4522208, but written in OpenSCAD.

inner_diameter = 28;
outer_diameter = 30;
segment_length = 35;
tolerance = 1; // Adjust 0.1 at a time if the segments are too tight or too loose.

$fn = 50;

module segment() {
    // A segment is basically two hollow half-spheres smooshed together, with gently
    // rounded edges to help things snap into place.
    r = outer_diameter / 2;
    t = (outer_diameter - inner_diameter) / 2;
    
    s = segment_length / r;
    
    scale([1, 1, s]) {
        difference() {
            union() {
                half_sphere(r);
                translate([0, 0, r]) rotate([0, 180]) half_sphere(r-t);
            }
            sphere(r-t);
            translate([0, 0, r]) sphere(r - t*2);
        }
    }
}

module half_sphere(r) {
    difference() {
        sphere(r);
        translate([0, 0, -r]) cube(r*2, center=true);
    }
}

segment();