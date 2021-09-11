module line3D(p1, p2, thickness, fn = 24) {
    $fn = fn;

    hull() {
        translate(p1) cube([depth, depth, thickness], center=true);
        translate(p2) cube([depth, depth, thickness], center=true);
    }
    
    // Add tooth
    // Find angle along spiral
    rise = (p2[2] - p1[2]);
    run = distance(p1, p2);
    v_angle = atan(rise/run);

    // Find angle from center
    h_angle = atan2(p1[1],p1[0]);
    
    hull() {
        //translate(p1) sphere(thickness / 2);
        translate([p1[0], p1[1], p1[2]]) rotate([v_angle, 0, h_angle])
            translate([tooth_depth/2, 0, 0]) cube([tooth_depth, tooth_width, thickness], center=true);
    }
}

module polyline3D(points, thickness, fn) {
    module polyline3D_inner(points, index) {
        if(index < len(points)) {
            line3D(points[index - 1], points[index], thickness, fn);
            polyline3D_inner(points, index + 1);
        }
    }

    polyline3D_inner(points, 1);
}

function distance(p1, p2) = 
    sqrt( pow(p1[0] - p2[0], 2) + pow(p1[1] - p2[1], 2));

function distance3d(p1, p2) = 
    sqrt( pow(p1[0] - p2[0], 2) + pow(p1[1] - p2[1], 2) + pow(p1[2] - p2[2], 2));

r = 30;
h = 1.6;
fa = 15;
tooth_depth = 4.4;
tooth_width = 3;
thickness = 1.2;
depth = 4;
circles = 3;

points = [
    for(a = [0:fa:360 * circles]) 
        [r * cos(a), r * sin(a), h / (360 / fa) * (a / fa)]
];

    
echo("Distance between teeth is");
outer_radius = r - (depth / 2) + (tooth_depth / 2);
echo(distance3d(
    [outer_radius * cos(0), outer_radius * sin(0), h / (360 / fa) * (0 / fa)],
    [outer_radius * cos(fa), outer_radius * sin(fa), h / (360 / fa)]
    ) - tooth_width);
    
    
polyline3D(points, thickness, 3);
    
// Also add a flat base
base_points = [
    for(a = [0:fa:360]) 
        [r * cos(a), r * sin(a), 0]
];

    
polyline3D(base_points, thickness, 3);