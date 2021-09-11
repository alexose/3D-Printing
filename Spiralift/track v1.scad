use <spiral_extrude.scad>;
module section() {
    render() spiral_extrude(Radius=19, EndRadius=19, Pitch=2.25, Height=2.25, StepsPerRev=50, Starts=1){
        render() polygon([[1,0],[2,0],[2,1],[3,1],[3,0],[5,0],[5,1],[6,1],[6,0],[7,0],[7,-1],[1,-1]]);
    }
}

for ( i = [0 : 8] ){
    translate([0,0,2.25*i]) section();  
}

translate([0,0,-1]) cylinder(2, 26.2, 26.2, $fn=100);