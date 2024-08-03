// F150 Lightning Headlight Cover
// Split into two piece for easy printin'

// 3D Printed in PETG
module headlight() {
    translate([-950, 900, -1070]) import("Headlight.stl");
}

intersection(){ 
    headlight();
    tool();
}

module tool() {
    d = 16;
    translate([-d*4, -d*4, 0]) checkerboard(d);
    translate([-d*4, -d*4, -d*12]) cube(d*12);
}

module checkerboard(d) {
    for (i = [0:7]) {
        for (j = [0:7]) {
            if ((i + j) % 2 == 0) {
                echo((i+j) % 2);
                translate([i * d, j * d, 0]) cube(d); 
            }
        }
    }
} 
