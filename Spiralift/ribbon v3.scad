module line(point1, point2, width = 1, cap_round = true) {
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
//circles = 15.2;
circles = 17;
arm_len = 1.5;
//init_radian = 44 * PI;
init_radian = 48 * PI;


b = arm_len / 2 / PI;
// one radian is almost 57.2958 degrees
points = [for(theta = [init_radian:step:3 * PI * circles])
    [b * theta * cos(theta * 57.2958), b * theta * sin(theta * 57.2958)]
];

     
// Cut out holes

dots = 140;            // number of dots
// dot_dist = 8.35394;      // distance between points
dot_dist = 8.7694;


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
    translate([0,0,-2]) linear_extrude(13) polyline(points, 1);
    for(theta = find_radians(b, dot_dist, [init_radian], dots)) {
        rotate(theta * 57.2958) 
            translate([b * theta - 0.75, 0, 0]) 
                cube([1.5, 3.4, 1.9]);
    }
    for(theta = find_radians(b, dot_dist, [init_radian], dots)) {
        rotate(theta * 57.2958) 
            translate([b * theta - 0.75, 0, 7]) 
                cube([1.5, 3.4, 1.9]);
    }
}
