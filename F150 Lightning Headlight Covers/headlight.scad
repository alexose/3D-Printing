// F150 Lightning Headlight Cover
// Plane split with interlocking finger joints derived from the true cut profile.

$fn = 48;

// Split setup for the current model preview.
split_plane_point = [0, 0, 0];
split_plane_normal = [0, 0, 1];
finger_direction = [1, 0, 0];

finger_layout = "linear";  // "linear" is the stable default. "angular" is only useful when the seam follows a known center.
finger_angle_center = split_plane_point;
finger_reference_radius = 140;  // Used only by angular layout.

default_finger_width = 5;
default_finger_depth = 5;
joint_clearance = 0.35;
scene_bounds = 1800;
preview_gap = 40;
preview_part = "both";  // "positive", "negative", or "both"

module headlight() {
    rotate([0, 5, 0]) translate([-950, 900, -1240]) import("Headlight.stl", convexity = 10);
}

// Public entry point: split any child geometry by an arbitrary plane and
// generate alternating finger joints from the slice cross section.
module slice_with_finger_joints(
    part = "positive",
    plane_point = [0, 0, 0],
    plane_normal = [0, 0, 1],
    joint_direction = [1, 0, 0],
    finger_layout = "linear",
    finger_angle_center = plane_point,
    finger_reference_radius = 140,
    finger_width = default_finger_width,
    finger_depth = default_finger_depth,
    clearance = 0.35,
    bounds = 1800
) {
    parity = part == "positive" ? 0 : 1;
    local_eps = 0.05;

    plane_to_world(plane_point, plane_normal, joint_direction)
        difference() {
            union() {
                intersection() {
                    world_to_plane(plane_point, plane_normal, joint_direction)
                        children();
                    if (part == "positive") {
                        positive_halfspace(bounds);
                    } else {
                        negative_halfspace(bounds);
                    }
                }

                if (part == "positive") {
                    translate([0, 0, -finger_depth])
                        linear_extrude(height = finger_depth)
                            finger_tabs_2d(
                                plane_point = plane_point,
                                plane_normal = plane_normal,
                                joint_direction = joint_direction,
                                finger_layout = finger_layout,
                                finger_angle_center = finger_angle_center,
                                finger_reference_radius = finger_reference_radius,
                                finger_width = finger_width,
                                clearance = clearance,
                                bounds = bounds,
                                parity = parity
                            )
                                children();
                } else {
                    linear_extrude(height = finger_depth)
                        finger_tabs_2d(
                            plane_point = plane_point,
                            plane_normal = plane_normal,
                            joint_direction = joint_direction,
                            finger_layout = finger_layout,
                            finger_angle_center = finger_angle_center,
                            finger_reference_radius = finger_reference_radius,
                            finger_width = finger_width,
                            clearance = clearance,
                            bounds = bounds,
                            parity = parity
                        )
                            children();
                }
            }

            if (part == "positive") {
                translate([0, 0, -local_eps])
                    linear_extrude(height = finger_depth + local_eps)
                        finger_slots_2d(
                            plane_point = plane_point,
                            plane_normal = plane_normal,
                            joint_direction = joint_direction,
                            finger_layout = finger_layout,
                            finger_angle_center = finger_angle_center,
                            finger_reference_radius = finger_reference_radius,
                            finger_width = finger_width,
                            clearance = clearance,
                            bounds = bounds,
                            parity = 1 - parity
                        )
                            children();
            } else {
                translate([0, 0, -finger_depth])
                    linear_extrude(height = finger_depth + local_eps)
                        finger_slots_2d(
                            plane_point = plane_point,
                            plane_normal = plane_normal,
                            joint_direction = joint_direction,
                            finger_layout = finger_layout,
                            finger_angle_center = finger_angle_center,
                            finger_reference_radius = finger_reference_radius,
                            finger_width = finger_width,
                            clearance = clearance,
                            bounds = bounds,
                            parity = 1 - parity
                        )
                            children();
            }
        }
}

// Preview one or both parts with a small separation so the joints are visible.
if (preview_part == "positive" || preview_part == "both") {
    translate([0, preview_part == "both" ? -preview_gap / 2 : 0, 0])
        slice_with_finger_joints(
            part = "positive",
            plane_point = split_plane_point,
            plane_normal = split_plane_normal,
            joint_direction = finger_direction,
            finger_layout = finger_layout,
            finger_angle_center = finger_angle_center,
            finger_reference_radius = finger_reference_radius,
            clearance = joint_clearance,
            bounds = scene_bounds
        )
            headlight();
}

if (preview_part == "negative" || preview_part == "both") {
    translate([0, preview_part == "both" ? preview_gap / 2 : 0, 0])
        slice_with_finger_joints(
            part = "negative",
            plane_point = split_plane_point,
            plane_normal = split_plane_normal,
            joint_direction = finger_direction,
            finger_layout = finger_layout,
            finger_angle_center = finger_angle_center,
            finger_reference_radius = finger_reference_radius,
            clearance = joint_clearance,
            bounds = scene_bounds
        )
            headlight();
}

module finger_tabs_2d(
    plane_point,
    plane_normal,
    joint_direction,
    finger_layout,
    finger_angle_center,
    finger_reference_radius,
    finger_width,
    clearance,
    bounds,
    parity
) {
    fit_offset_2d(delta = clearance <= 0 ? 0 : -clearance / 2)
        intersection() {
            slice_profile_2d(
                plane_point = plane_point,
                plane_normal = plane_normal,
                joint_direction = joint_direction
            )
                children();
            finger_pattern_2d(
                finger_layout = finger_layout,
                plane_point = plane_point,
                plane_normal = plane_normal,
                joint_direction = joint_direction,
                finger_angle_center = finger_angle_center,
                finger_reference_radius = finger_reference_radius,
                finger_width = finger_width,
                bounds = bounds,
                parity = parity
            );
        }
}

module finger_slots_2d(
    plane_point,
    plane_normal,
    joint_direction,
    finger_layout,
    finger_angle_center,
    finger_reference_radius,
    finger_width,
    clearance,
    bounds,
    parity
) {
    fit_offset_2d(delta = clearance <= 0 ? 0 : clearance / 2)
        intersection() {
            slice_profile_2d(
                plane_point = plane_point,
                plane_normal = plane_normal,
                joint_direction = joint_direction
            )
                children();
            finger_pattern_2d(
                finger_layout = finger_layout,
                plane_point = plane_point,
                plane_normal = plane_normal,
                joint_direction = joint_direction,
                finger_angle_center = finger_angle_center,
                finger_reference_radius = finger_reference_radius,
                finger_width = finger_width,
                bounds = bounds,
                parity = parity
            );
        }
}

module slice_profile_2d(
    plane_point = [0, 0, 0],
    plane_normal = [0, 0, 1],
    joint_direction = [1, 0, 0]
) {
    projection(cut = true)
        world_to_plane(plane_point, plane_normal, joint_direction)
            children();
}

module finger_pattern_2d(
    finger_layout = "linear",
    plane_point = [0, 0, 0],
    plane_normal = [0, 0, 1],
    joint_direction = [1, 0, 0],
    finger_angle_center = [0, 0, 0],
    finger_reference_radius = 140,
    finger_width = default_finger_width,
    bounds = 1800,
    parity = 0
) {
    if (finger_layout == "angular") {
        angular_finger_mask_2d(
            center = plane_xy(finger_angle_center, plane_point, plane_normal, joint_direction),
            finger_width = finger_width,
            reference_radius = finger_reference_radius,
            bounds = bounds,
            parity = parity
        );
    } else {
        linear_finger_mask_2d(
            finger_width = finger_width,
            bounds = bounds,
            parity = parity
        );
    }
}

module linear_finger_mask_2d(finger_width = default_finger_width, bounds = 1800, parity = 0, width_adjust = 0) {
    count = ceil((2 * bounds + 2 * finger_width) / finger_width);
    start_x = -bounds - finger_width;
    actual_width = max(0.01, finger_width - width_adjust);

    for (i = [0 : count]) {
        if ((i + parity) % 2 == 0) {
            translate([start_x + i * finger_width + width_adjust / 2, -bounds - finger_width])
                square([actual_width, 2 * (bounds + finger_width)]);
        }
    }
}

module angular_finger_mask_2d(center = [0, 0], finger_width = default_finger_width, reference_radius = 140, bounds = 1800, parity = 0) {
    step_angle = finger_angle_step_deg(finger_width, reference_radius);
    count = ceil(360 / step_angle);
    radius = bounds * 2;

    for (i = [0 : count - 1]) {
        if ((i + parity) % 2 == 0) {
            sector_2d(
                center = center,
                radius = radius,
                start_angle = -180 + i * step_angle,
                end_angle = min(180, -180 + (i + 1) * step_angle)
            );
        }
    }
}

module sector_2d(center = [0, 0], radius = 100, start_angle = 0, end_angle = 30) {
    polygon(points = concat([center], arc_points(center, radius, start_angle, end_angle)));
}

module fit_offset_2d(delta = 0) {
    if (abs(delta) < 0.0001) {
        children();
    } else {
        offset(delta = delta)
            children();
    }
}

module positive_halfspace(bounds = 1800) {
    translate([-bounds, -bounds, 0])
        cube([2 * bounds, 2 * bounds, bounds]);
}

module negative_halfspace(bounds = 1800) {
    translate([-bounds, -bounds, -bounds])
        cube([2 * bounds, 2 * bounds, bounds]);
}

module world_to_plane(
    plane_point = [0, 0, 0],
    plane_normal = [0, 0, 1],
    joint_direction = [1, 0, 0]
) {
    multmatrix(world_to_plane_matrix(plane_point, plane_normal, joint_direction))
        children();
}

module plane_to_world(
    plane_point = [0, 0, 0],
    plane_normal = [0, 0, 1],
    joint_direction = [1, 0, 0]
) {
    multmatrix(plane_to_world_matrix(plane_point, plane_normal, joint_direction))
        children();
}

function plane_basis(plane_normal, joint_direction) =
    let(
        z_axis = unit(plane_normal),
        projected = vec_sub(joint_direction, vec_scale(z_axis, vec_dot(joint_direction, z_axis))),
        fallback = abs(z_axis[0]) < 0.9 ? vec_cross([1, 0, 0], z_axis) : vec_cross([0, 1, 0], z_axis),
        x_seed = vec_len(projected) < 0.0001 ? fallback : projected,
        x_axis = unit(x_seed),
        y_axis = unit(vec_cross(z_axis, x_axis))
    ) [x_axis, y_axis, z_axis];

function world_to_plane_matrix(plane_point, plane_normal, joint_direction) =
    let(
        basis = plane_basis(plane_normal, joint_direction),
        x_axis = basis[0],
        y_axis = basis[1],
        z_axis = basis[2]
    ) [
        [x_axis[0], x_axis[1], x_axis[2], -vec_dot(x_axis, plane_point)],
        [y_axis[0], y_axis[1], y_axis[2], -vec_dot(y_axis, plane_point)],
        [z_axis[0], z_axis[1], z_axis[2], -vec_dot(z_axis, plane_point)],
        [0, 0, 0, 1]
    ];

function plane_to_world_matrix(plane_point, plane_normal, joint_direction) =
    let(
        basis = plane_basis(plane_normal, joint_direction),
        x_axis = basis[0],
        y_axis = basis[1],
        z_axis = basis[2]
    ) [
        [x_axis[0], y_axis[0], z_axis[0], plane_point[0]],
        [x_axis[1], y_axis[1], z_axis[1], plane_point[1]],
        [x_axis[2], y_axis[2], z_axis[2], plane_point[2]],
        [0, 0, 0, 1]
    ];

function arc_points(center, radius, start_angle, end_angle) =
    let(steps = max(2, ceil(abs(end_angle - start_angle) / 4)))
        [for (i = [0 : steps]) let(a = start_angle + (end_angle - start_angle) * i / steps) [center[0] + radius * cos(a), center[1] + radius * sin(a)]];

function finger_angle_step_deg(finger_width, reference_radius) =
    max(1, finger_width * 180 / (PI * max(reference_radius, 0.01)));

function plane_xy(point, plane_point, plane_normal, joint_direction) =
    let(
        basis = plane_basis(plane_normal, joint_direction),
        x_axis = basis[0],
        y_axis = basis[1],
        relative = vec_sub(point, plane_point)
    ) [vec_dot(x_axis, relative), vec_dot(y_axis, relative)];

function vec_dot(a, b) = a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
function vec_cross(a, b) = [
    a[1] * b[2] - a[2] * b[1],
    a[2] * b[0] - a[0] * b[2],
    a[0] * b[1] - a[1] * b[0]
];
function vec_len(v) = sqrt(vec_dot(v, v));
function unit(v) = let(m = vec_len(v)) m < 0.0001 ? [0, 0, 1] : [v[0] / m, v[1] / m, v[2] / m];
function vec_scale(v, s) = [v[0] * s, v[1] * s, v[2] * s];
function vec_sub(a, b) = [a[0] - b[0], a[1] - b[1], a[2] - b[2]];
