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

    
polyline3D(base_points, thickness, 3);module line(point1, point2, width = 1, cap_round = true) {
    angle = 90 - atan((point2[1] - point1[1]) / (point2[0] - point1[0]));
    offset_x = 0.5 * width * cos(angle);
    offset_y = 0.5 * width * sin(angle);

    offset1 = [-offset_x, offset_y];
    offset2 = [offset_x, -offset_y];

    if(cap_round) {
        translate(point1) circle(d = width, $fn = 24);
        translate(point2) circle(d = width, $fn = 24);
    }

    polygon(points=[
        point1 + offset1, point2 + offset1,  
        point2 + offset2, point1 + offset2
    ]);
}

module polyline(points, width = 1) {
    module polyline_inner(points, index) {
        if(index < len(points)) {
            line(points[index - 1], points[index], width);
            polyline_inner(points, index + 1);
        }
    }

    polyline_inner(points, 1);
}

PI = 3.14159;
step = 0.1;
circles = 18.5;
arm_len = 1.5;
init_radian = 48 * PI;

b = arm_len / 2 / PI;
// one radian is almost 57.2958 degrees
points = [for(theta = [init_radian:step:3 * PI * circles])
    [b * theta * cos(theta * 57.2958), b * theta * sin(theta * 57.2958)]
];

     
// Cut out holes

dots = 140;            // number of dots
dot_dist = 4.831 + 3;  // distance between points

function r(b, theta) = b * theta;

function radian_step(b, theta, l) = 
    acos((2 * pow(r(b, theta), 2) - pow(l, 2)) / (2 * pow(r(b, theta), 2))) / 180 * PI;

function find_radians(b, l, radians, n, count = 1) =
    count == n ? radians : (
        find_radians(
            b, 
            l, 
            concat(
                radians, // current angle
                [radians[count - 1] + radian_step(b, radians[count - 1], l)] // angle after rotating
            ), 
            n,
        count + 1)
    );


difference() {
    translate([0,0,-2]) linear_extrude(8) polyline(points, 1);
    for(theta = find_radians(b, dot_dist, [init_radian], dots)) {
        rotate(theta * 57.2958) 
            translate([b * theta - 0.75, 0, 0]) 
                cube([1.5, 3.1, 1.3]);
    }
}
