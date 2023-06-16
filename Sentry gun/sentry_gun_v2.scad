$fn = 100;

r = 50;  // tank radius
h = 70;  // tank height
fh = 30; // flare height
fw = 20; // flare width
fn = 8; // flare sides (corresponds with number of sensors)
sw = 3; // drive shaft width
so = 35; // drive shaft offset
ax = 2.9; // axel width
hw = r - 20; // hole width
t = 2; // shell thickness

difference() {
    union (){
        shell();
        // Shaft lining
        translate([so, 0]) cylinder(h, sw + t, sw + t);
    }
    
    // Shaft hole
    translate([so, 0]) cylinder(h, sw, sw);
}

module shell() {
    
    difference() {
        // Outer
        hull() {
            cylinder(h, r, r);
            translate([0, 0, h/2 - fh/2]) cylinder(fh, r+fw, r+fw, $fn=fn);
        }
        
        union() {
            // Inner
            translate([0, 0, t]) hull() {
                r1 = hw;
                r2 = r+fw-t;
                
                cylinder(h-t*2, r1, r1);
                translate([0, 0, h/2 - fh/2]) cylinder(fh-t*2, r2, r2, $fn=fn);
            }
            
            // Upper hole
            translate([0, 0, t]) cylinder(h, hw, hw);
        }
    }
    
}