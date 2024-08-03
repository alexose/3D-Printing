module internal() {
    union() {
        repeated_stretch(6, 1) import("Comma 3 internal.stl");
    }
}

module shell() {
    import("Comma 3 External.stl");
}

module cover() {
    difference() {
        shell();
        internal();
        translate([40, 45, 19]) rotate([90, 0, 0]) cylinder(20, r=11.5);
        translate([-39.5, 45, 19]) rotate([90, 0, 0]) cylinder(20, r=14);
        
        // Create hole on top for mount to stick through
        translate([0, 25, 35]) cube([70, 30, 48], true);
        
        // Create a front flat plane on which to print
        translate([0, 84.6, 0]) cube(100, true);
        
        translate([0, 35, -3]) rotate([90, 0]) repeat_in_grid(180, 60, 40, 15, true) cylinder(12, r=0.7);
    }
}

difference() {
    union() {
        scale([1, 1.1, 1]) cover();
        connector();
    }
    tube(1);
    
    // USB plug hole
    translate([19, 50]) rotate([90, 0, 0]) scale([1, 1.5, 1]) cylinder(100, r=6);
}




module repeated_stretch(count, spacing) {
    for (i = [0 : count - 1]) {
        translate([0, -i * spacing, 0]) {
            children();
        }
    }
}

module repeat_in_grid(grid_width, grid_length, repeats_x, repeats_y, center=false) {
    // Calculate the spacing between shapes based on the grid dimensions and number of repeats
    spacing_x = grid_width / repeats_x;
    spacing_y = grid_length / repeats_y;
    
    // Calculate offset if centered
    offset_x = center ? -grid_width / 2 + spacing_x / 2 : 0;
    offset_y = center ? -grid_length / 2 + spacing_y / 2 : 0;
    
    // Loop to create the grid of shapes
    for (i = [0 : repeats_x - 1]) {
        for (j = [0 : repeats_y - 1]) {
            translate([i * spacing_x + offset_x, j * spacing_y + offset_y, 0]) {
                children();
            }
        }
    }
}

module connector() {
    difference(){ 
       minkowski() {
            tube();
            cube(1, true);
       }
       tube(1);
       scale([1, 1.1, 1]) internal();
    }
}

module tube(o=0) {
    r = (23.8)/2;
    rotate([0, 0, -6]) translate([70, 11, 0]) {
        hull() {
            translate([-20-o, 12, 0]) scale([1, 1.3, 3]) rotate([90, 0, 90]) cylinder(1, r=r);
            translate([20, 12, 0]) rotate([90, 0, 90]) cylinder(1, r=r);
        }
        translate([20, 0]) hull() {
            translate([0, 12, 0]) rotate([90, 0, 90]) cylinder(1, r=r);
            translate([10+o, 12, 0]) rotate([90, 0, 90]) cylinder(1, r=r);
        }
    }
}