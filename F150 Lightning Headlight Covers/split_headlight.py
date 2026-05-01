#!/usr/bin/env python3

import argparse
import math

import numpy as np
import trimesh
from orient_for_print import cleanup_mesh, export_clean_mesh, orient_mesh_for_print
from shapely.geometry import GeometryCollection, MultiPolygon, Polygon
from shapely.ops import unary_union
from trimesh.boolean import difference, union
from trimesh.creation import extrude_polygon
from trimesh.intersections import slice_mesh_plane


def translation_matrix(xyz):
    return trimesh.transformations.translation_matrix(xyz)


def rotation_matrix_xyz(degrees_xyz):
    rx, ry, rz = [math.radians(v) for v in degrees_xyz]
    return trimesh.transformations.euler_matrix(rx, ry, rz, "sxyz")


def load_mesh(path, translate_xyz, rotate_xyz):
    mesh = trimesh.load(path, force="mesh")
    mesh = mesh.copy()
    mesh.apply_transform(rotation_matrix_xyz(rotate_xyz) @ translation_matrix(translate_xyz))
    return mesh


def polygon_to_points(polygon):
    return [list(point) for point in list(polygon.exterior.coords)[:-1]]


def cumulative_lengths_closed(points):
    values = [0.0]
    total = 0.0
    for a, b in zip(points, points[1:] + points[:1]):
        total += math.dist(a, b)
        values.append(total)
    return values, total


def cumulative_lengths_open(points):
    values = [0.0]
    total = 0.0
    for a, b in zip(points, points[1:]):
        total += math.dist(a, b)
        values.append(total)
    return values, total


def build_guide_path(loop_points, loop_lengths, loop_total_length):
    points = np.asarray(loop_points, dtype=float)
    distances = np.linalg.norm(points[:, None, :] - points[None, :, :], axis=2)
    start, end = np.unravel_index(np.argmax(distances), distances.shape)

    if start > end:
        start, end = end, start

    chain_a = loop_points[start : end + 1]
    chain_b = loop_points[end:] + loop_points[: start + 1]

    if len(chain_a) < 2 or len(chain_b) < 2:
        raise ValueError("Unable to derive two boundary chains from the section contour")

    if math.dist(chain_a[0], chain_b[0]) + math.dist(chain_a[-1], chain_b[-1]) > math.dist(chain_a[0], chain_b[-1]) + math.dist(chain_a[-1], chain_b[0]):
        chain_b = list(reversed(chain_b))

    lengths_a, total_a = cumulative_lengths_open(chain_a)
    lengths_b, total_b = cumulative_lengths_open(chain_b)
    samples = 20

    guide = []
    for index in range(samples):
        u = index / (samples - 1)
        point_a = point_at_length(chain_a, lengths_a, total_a, u * total_a)
        point_b = point_at_length(chain_b, lengths_b, total_b, u * total_b)
        guide.append(((point_a + point_b) / 2.0).tolist())

    deduped = [guide[0]]
    for point in guide[1:]:
        if math.dist(point, deduped[-1]) > 1e-6:
            deduped.append(point)
    return deduped


def point_at_length(points, cumulative, total, distance):
    distance = min(max(distance, 0.0), total)
    for index in range(len(points) - 1):
        start = cumulative[index]
        end = cumulative[index + 1]
        if distance <= end or index == len(points) - 2:
            ratio = 0.0 if end <= start else (distance - start) / (end - start)
            a = np.array(points[index], dtype=float)
            b = np.array(points[index + 1], dtype=float)
            return a + (b - a) * ratio
    return np.array(points[-1], dtype=float)


def tangent_at_length(points, cumulative, total, distance):
    distance = min(max(distance, 0.0), total)
    for index in range(len(points) - 1):
        end = cumulative[index + 1]
        if distance <= end or index == len(points) - 2:
            a = np.array(points[index], dtype=float)
            b = np.array(points[index + 1], dtype=float)
            tangent = b - a
            length = np.linalg.norm(tangent)
            if length < 1e-9:
                return np.array([1.0, 0.0])
            return tangent / length
    return np.array([1.0, 0.0])


def halfspace_polygon(point, tangent, direction, bounds):
    tangent = np.array(tangent, dtype=float)
    tangent = tangent / np.linalg.norm(tangent)
    normal = np.array([-tangent[1], tangent[0]])
    direction_vec = tangent * direction
    p = np.array(point, dtype=float)
    corners = [
        p - normal * bounds,
        p + normal * bounds,
        p + normal * bounds + direction_vec * 2 * bounds,
        p - normal * bounds + direction_vec * 2 * bounds,
    ]
    return Polygon(corners)


def clean_shape(shape):
    if shape.is_empty:
        return None
    cleaned = shape.buffer(0)
    if cleaned.is_empty:
        return None
    return cleaned


def build_finger_regions(section_polygon, guide_points, finger_width, phase, bounds):
    guide_lengths, guide_total_length = cumulative_lengths_open(guide_points)
    intervals = int(math.ceil(guide_total_length / finger_width))
    even_regions = []

    for i in range(intervals):
        s0 = min(guide_total_length, i * finger_width + phase)
        s1 = min(guide_total_length, (i + 1) * finger_width + phase)
        if s1 <= s0 + 1e-6:
            continue

        p0 = point_at_length(guide_points, guide_lengths, guide_total_length, s0)
        t0 = tangent_at_length(guide_points, guide_lengths, guide_total_length, s0)
        p1 = point_at_length(guide_points, guide_lengths, guide_total_length, s1)
        t1 = tangent_at_length(guide_points, guide_lengths, guide_total_length, s1)

        strip = section_polygon
        strip = strip.intersection(halfspace_polygon(p0, t0, direction=1, bounds=bounds))
        strip = strip.intersection(halfspace_polygon(p1, t1, direction=-1, bounds=bounds))
        strip = clean_shape(strip)
        if strip is None:
            continue
        if i % 2 == 0:
            even_regions.append(strip)

    even = clean_shape(unary_union(even_regions)) if even_regions else None
    odd = clean_shape(section_polygon.difference(even)) if even is not None else clean_shape(section_polygon)
    return even, odd, guide_total_length


def iter_polygons(shape):
    if shape is None or shape.is_empty:
        return []
    if isinstance(shape, Polygon):
        return [shape]
    if isinstance(shape, MultiPolygon):
        return list(shape.geoms)
    if isinstance(shape, GeometryCollection):
        return [geom for geom in shape.geoms if isinstance(geom, Polygon) and not geom.is_empty]
    return []


def offset_shape(shape, delta):
    if shape is None:
        return None
    result = shape.buffer(delta, join_style=2)
    return clean_shape(result)


def extrude_shape(shape, height, to_3d, base_z):
    polygons = [poly for poly in iter_polygons(shape) if poly.area > 1e-6]
    if not polygons:
        return None
    transform = to_3d @ translation_matrix([0, 0, base_z])
    meshes = [extrude_polygon(poly, height=height, transform=transform) for poly in polygons]
    return trimesh.util.concatenate(meshes)


def maybe_union(meshes):
    meshes = [mesh for mesh in meshes if mesh is not None]
    if not meshes:
        return None
    if len(meshes) == 1:
        return meshes[0]
    return union(meshes, engine="manifold")


def maybe_difference(base_mesh, cutters):
    cutters = [mesh for mesh in cutters if mesh is not None]
    if not cutters:
        return base_mesh
    return difference([base_mesh] + cutters, engine="manifold")


def build_jointed_halves(mesh, section_polygon, to_3d, even_region, odd_region, finger_depth, clearance, plane_z):
    top_half = slice_mesh_plane(mesh, plane_normal=[0, 0, 1], plane_origin=[0, 0, plane_z], cap=True)
    bottom_half = slice_mesh_plane(mesh, plane_normal=[0, 0, -1], plane_origin=[0, 0, plane_z], cap=True)

    tab_even = offset_shape(even_region, -clearance / 2 if clearance > 0 else 0)
    slot_even = offset_shape(even_region, clearance / 2 if clearance > 0 else 0)
    tab_odd = offset_shape(odd_region, -clearance / 2 if clearance > 0 else 0)
    slot_odd = offset_shape(odd_region, clearance / 2 if clearance > 0 else 0)

    top_tabs = extrude_shape(tab_even, height=finger_depth, to_3d=to_3d, base_z=plane_z - finger_depth)
    top_slots = extrude_shape(slot_odd, height=finger_depth + 0.05, to_3d=to_3d, base_z=plane_z - 0.05)

    bottom_tabs = extrude_shape(tab_odd, height=finger_depth, to_3d=to_3d, base_z=plane_z)
    bottom_slots = extrude_shape(slot_even, height=finger_depth + 0.05, to_3d=to_3d, base_z=plane_z - finger_depth)

    top_with_tabs = maybe_union([top_half, top_tabs])
    bottom_with_tabs = maybe_union([bottom_half, bottom_tabs])

    top_final = maybe_difference(top_with_tabs, [top_slots])
    bottom_final = maybe_difference(bottom_with_tabs, [bottom_slots])
    return cleanup_mesh(top_final), cleanup_mesh(bottom_final)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", default="Headlight.stl")
    parser.add_argument("--top-output", default="headlight_top_jointed.stl")
    parser.add_argument("--bottom-output", default="headlight_bottom_jointed.stl")
    parser.add_argument("--translate", nargs=3, type=float, default=[-950, 900, -1240])
    parser.add_argument("--rotate", nargs=3, type=float, default=[0, 5, 0])
    parser.add_argument("--plane-z", type=float, default=0.0)
    parser.add_argument("--finger-width", type=float, default=5.0)
    parser.add_argument("--finger-depth", type=float, default=5.0)
    parser.add_argument("--clearance", type=float, default=0.35)
    parser.add_argument("--phase", type=float, default=0.0)
    parser.add_argument("--overhang-angle", type=float, default=45.0)
    parser.add_argument("--contact-tolerance", type=float, default=0.3)
    parser.add_argument("--no-orient-for-print", action="store_true")
    args = parser.parse_args()

    mesh = load_mesh(args.input, args.translate, args.rotate)
    section = mesh.section(plane_normal=[0, 0, 1], plane_origin=[0, 0, args.plane_z])
    if section is None:
        raise SystemExit("No section found at the requested split plane")

    planar, to_3d = section.to_2D()
    polygons = planar.polygons_full
    if not polygons:
        raise SystemExit("Failed to recover a closed section polygon")

    section_polygon = max(polygons, key=lambda poly: poly.area)
    loop_points = polygon_to_points(section_polygon)
    loop_lengths, loop_total_length = cumulative_lengths_closed(loop_points)
    guide_points = build_guide_path(loop_points, loop_lengths, loop_total_length)

    diagonal = np.linalg.norm(mesh.bounds[1] - mesh.bounds[0])
    even_region, odd_region, guide_total_length = build_finger_regions(
        section_polygon=section_polygon,
        guide_points=guide_points,
        finger_width=args.finger_width,
        phase=args.phase,
        bounds=float(diagonal * 2.0),
    )

    top, bottom = build_jointed_halves(
        mesh=mesh,
        section_polygon=section_polygon,
        to_3d=to_3d,
        even_region=even_region,
        odd_region=odd_region,
        finger_depth=args.finger_depth,
        clearance=args.clearance,
        plane_z=args.plane_z,
    )

    top_metrics = {"support_penalty": 0.0, "contact_area": 0.0, "height": float(top.extents[2]), "probability": 0.0}
    bottom_metrics = {"support_penalty": 0.0, "contact_area": 0.0, "height": float(bottom.extents[2]), "probability": 0.0}

    if not args.no_orient_for_print:
        top, top_metrics = orient_mesh_for_print(
            top,
            overhang_angle=args.overhang_angle,
            contact_tolerance=args.contact_tolerance,
        )
        bottom, bottom_metrics = orient_mesh_for_print(
            bottom,
            overhang_angle=args.overhang_angle,
            contact_tolerance=args.contact_tolerance,
        )

    top = cleanup_mesh(top)
    bottom = cleanup_mesh(bottom)

    export_clean_mesh(top, args.top_output)
    export_clean_mesh(bottom, args.bottom_output)

    print(f"Section area: {section_polygon.area:.3f}")
    print(f"Guide points: {len(guide_points)}")
    print(f"Guide length: {guide_total_length:.3f}")
    print(
        "Top orientation:"
        f" support={top_metrics['support_penalty']:.3f}"
        f" contact={top_metrics['contact_area']:.3f}"
        f" height={top_metrics['height']:.3f}"
        f" prob={top_metrics['probability']:.4f}"
    )
    print(
        "Bottom orientation:"
        f" support={bottom_metrics['support_penalty']:.3f}"
        f" contact={bottom_metrics['contact_area']:.3f}"
        f" height={bottom_metrics['height']:.3f}"
        f" prob={bottom_metrics['probability']:.4f}"
    )
    print(f"Wrote: {args.top_output}")
    print(f"Wrote: {args.bottom_output}")


if __name__ == "__main__":
    main()
