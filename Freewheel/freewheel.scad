include <sprockets.scad>;

scale(1.025) {
    difference() {
        difference() {
            translate([0,0,-8]) cylinder(h=10,r=40, $fn=200);
            render() sprocket(2, 16, 0, 0, 0);
        }
        
        // Bolt points
        bolt_width = 2;
        bolt_head_width = 3.5;
        const = 34;
        num = 4;    
        for (i = [0:(num-1)]) {
            echo(360*i/num, sin(360*i/num)*const, cos(360*i/num)*const);
            translate([sin(360*i/num)*const, cos(360*i/num)*const, -8 ]) {
                cylinder(h=1.5, r=bolt_head_width, $fn=6);
                cylinder(h=10, r=bolt_width, $fn=10);
            }
        } 
        

        // Middle
        translate([0,0,-8]) cylinder(h=10,r=27, $fn=200);
    }

    // Tread
    tread_height = 1;
    tread_num = 40;
    tread_width = 39.8;

    for (i = [0:(tread_num-1)]) {
        echo(360*i/tread_num, sin(360*i/tread_num)*tread_width, cos(360*i/tread_num)*tread_width);
        translate([sin(360*i/tread_num)*tread_width, cos(360*i/tread_num)*tread_width, -8 ])
        cylinder(h=10, r=0.7, $fn=10);
    } 
}
