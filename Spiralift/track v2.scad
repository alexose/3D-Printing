use <spiral_extrude.scad>;
w = 2; // Track width
g = 1; // Track gap
h = 1.5; // Track height

module section() {
    render() spiral_extrude(Radius=24, EndRadius=24, Pitch=2.72, Height=2.72*8, StepsPerRev=50, Starts=1){
        render() polygon([
            [0,0],
            [w-g,0],
            [w-g,h],
            [w-g+1,h],
            [w-g+1,0],
            [w+g,0],
            [w+g,h],
            [w+g+1,h],
            [w+g+1,0],
            [w+w+1,0],
            [w+w+1,-1],
            [0,-1]
        ]);
    }
}

scale([1.1, 1.1, 1]) section();

/*
for ( i = [0 : 8] ){
    translate([0,0,2.25*i]) section();  
}
*/

translate([0,0,-1]) cylinder(2, 26.5, 26.5, $fn=100);