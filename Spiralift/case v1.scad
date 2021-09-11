use <spiral_extrude.scad>;

w = 2; // Track width
g = 1; // Track gap
h = 1.5; // Track height
rh = 12; // Ribbon height
s = 30;

union() {
    difference() {
        cylinder(25,42,42, $fn=100);
        cylinder(26,34,34, $fn=100);
        translate([0, 0, 9]) spiral_extrude(Radius=36, EndRadius=36, Pitch=rh+1.75, Height=rh+1.75, StepsPerRev=50, Starts=1){
            polygon([[0,0],[s,0],[s,s],[0,s]]); 
        }
        scale(1.05) translate([8.7,2,9.2]) rotate([0, 5, -100])  spiral_extrude(Radius=26, EndRadius=26, Pitch=0.1, Height=0.03, StepsPerRev=50, Starts=1) polygon([
            [0,0],
            [w-g,0],
            [w-g,h],
            [w-g+1,h],
            [w-g+1,rh],
            [w+g,rh],
            [w+g,h],
            [w+g+1,h],
            [w+g+1,0],
            [w+w+1,0],
            [w+w+1,-1],
            [0,-1]
        ]);
    }
}


