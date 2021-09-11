$fn = 100;
width = 85;
depth = 95;
height = 30;
wallThickness = 2;
hingeOuter = 7;
hingeInner = 4;
hingeInnerSlop = .4;
hingeFingerSlop = .4;
fingerLength = hingeOuter/1.65;
fingerSize = 6.5;
topFingerSize = fingerSize;
pos = -depth/2;
latchWidth = 8;
z = 0;

difference() {
    union() {
        bottom();
        top(); 
    }
    union() {
        rotate([90, 0, 0]) translate([60, 13, 40]) cylinder(10, 5, 5);
        translate([-95, -20, 28]) rotate([0, 90, 0])  cylinder(10, 4, 4);
        i = 7;
        translate([-45, -33, -1]) rotate([0, 0, 90]) {
            translate([0, i, 0]) cube([66, 2.5, 10]);
            translate([0, i*2, 0]) cube([66, 2.5, 10]);
            translate([0, i*3, 0]) cube([66, 2.5, 10]);
            translate([0, i*4, 0]) cube([66, 2.5, 10]);
        }
    }
}



mounts();

module bottom() {
	union() {
		// main box and cutout
		difference() {
			translate([-width - fingerLength, -depth/2, 0]) {
				cube([width,depth,height]);
			}
	
			translate([(-width - fingerLength) + wallThickness, -depth/2 + wallThickness, wallThickness]) {
				cube([width - (wallThickness * 2), depth - (wallThickness * 2), height]);
			}

			// latch cutout
			translate([-width - fingerLength + (wallThickness/2), (-latchWidth/2) - (hingeFingerSlop/2), wallThickness]) {
				cube([wallThickness/2 + .1, latchWidth + hingeFingerSlop, height]);
			}

						
		}

		//latch cylinder
		difference() {
			translate([-width - fingerLength + (wallThickness/2), -latchWidth/2, height - 1]) {
				rotate([-90,0,0]) {
					cylinder(r = 1, h = latchWidth);
				}
			}
			// front wall wipe
			translate([-width - fingerLength - 5, -depth/2,0]) {
				cube([5,depth,height]);
			}
		}

		difference() {
			hull() {
				translate([0,-depth/2,height]) {
					rotate([-90,0,0]) {
						cylinder(r = hingeOuter/2, h = depth);
					}
				}
				translate([-fingerLength - .1, -depth/2,height - hingeOuter]){
					cube([.1,depth,hingeOuter]);
				}
				translate([-fingerLength, -depth/2,height-.1]){
					cube([fingerLength,depth,.1]);
				}
				translate([0, -depth/2,height]){
					rotate([0,45,0]) {
						cube([hingeOuter/2,depth,.01]);
					}
				}
			}
			// finger cutouts

			for  (i = [-depth/2 + fingerSize:fingerSize*2:depth/2]) {
				translate([-fingerLength,i - (fingerSize/2) - (hingeFingerSlop/2),0]) {
					cube([fingerLength*2,fingerSize + hingeFingerSlop,height*2]);
				}
			}
		}

		// center rod
		translate([0, -depth/2, height]) {
			rotate([-90,0,0]) {
				cylinder(r = hingeInner /2, h = depth);
			}
		}
	}
}

module top() {
	union() {
		difference() {
			translate([fingerLength, -depth/2, 0]) {
				cube([width,depth,height - .5]);
			}
	
			translate([fingerLength + wallThickness, -depth/2 + wallThickness, wallThickness]) {
				cube([width - (wallThickness * 2), depth - (wallThickness * 2), height]);
			}

			
		}

		//latch
		translate([width + fingerLength - wallThickness - 1.5, (-latchWidth/2), 0]) {
			cube([1.5, latchWidth, height - .5 + 4]);
		}
		translate([width + fingerLength - wallThickness, -latchWidth/2, height - .5 + 3]) {
			rotate([-90,0,0]) {
				cylinder(r = 1, h = latchWidth);
			}
		}

		difference() {
			hull() {
				translate([0,-depth/2,height]) {
					rotate([-90,0,0]) {
						cylinder(r = hingeOuter/2, h = depth);
					}
				}
				translate([fingerLength, -depth/2,height - hingeOuter - .5]){
					cube([.1,depth,hingeOuter - .5]);
				}
				translate([-fingerLength/2, -depth/2,height-.1]){
					cube([fingerLength,depth,.1]);
				}
				translate([0, -depth/2,height]){
					rotate([0,45,0]) {
						cube([hingeOuter/2,depth,.01]);
					}
				}
			}
			// finger cutouts
			for  (i = [-depth/2:fingerSize*2:depth/2 + fingerSize]) {
				translate([-fingerLength,i - (fingerSize/2) - (hingeFingerSlop/2),0]) {
					cube([fingerLength*2,fingerSize + hingeFingerSlop,height*2]);
				}
				if (depth/2 - i < (fingerSize * 1.5)) {
					translate([-fingerLength,i - (fingerSize/2) - (hingeFingerSlop/2),0]) {
						cube([fingerLength*2,depth,height*2]);
					}
				}
			}

			// center cutout
			translate([0, -depth/2, height]) {
				rotate([-90,0,0]) {
					cylinder(r = hingeInner /2 + hingeInnerSlop, h = depth);
				}
			}
		}
	}
}

module mounts() {
    translate([15, -27, 0]) union() {
        translate([0, 0, 0]) mount();
        translate([60, 0, 0]) mount();
        translate([41, 55, 0]) mount();
        
    }
    
    translate([-15, -30, 0]) rotate([0, 0, 90])   union() {
        translate([0, 0, 0]) mount();
        translate([58, 0, 0]) mount();
        translate([0, 23, 0]) mount();
        translate([58, 23, 0]) mount();
    }
}

module mount() {
    difference() {
        cylinder(7, 3, 3);
        translate([0,0,1]) cylinder(8, 1.15, 1.15);
    }
}
