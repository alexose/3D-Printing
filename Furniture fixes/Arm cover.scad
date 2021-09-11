
   
module torus() {
    render() {
        scale(10)    
        rotate_extrude(convexity = 10, $fn = 100)
        translate([2, 0, 0])
        circle(r = 0.05, $fn = 100);
    }
}


for ( i = [0 : 10] ){
    translate([0,0,i]) torus();
}