#!/usr/bin/env python3

import argparse
import math
from pathlib import Path

import numpy as np
import trimesh


def cleanup_mesh(mesh):
    cleaned = mesh.copy()
    cleaned.update_faces(cleaned.unique_faces())
    cleaned.update_faces(cleaned.nondegenerate_faces())
    cleaned.remove_unreferenced_vertices()
    cleaned.merge_vertices(digits_vertex=8)
    cleaned.fix_normals()

    components = cleaned.split(only_watertight=False)
    if not components:
        return cleaned

    largest = max(components, key=lambda item: len(item.faces))
    largest.remove_unreferenced_vertices()
    largest.update_faces(largest.unique_faces())
    largest.update_faces(largest.nondegenerate_faces())
    largest.remove_unreferenced_vertices()
    largest.merge_vertices()
    largest.fix_normals()
    return largest


def pose_metrics(mesh, overhang_angle, contact_tolerance):
    normals_z = mesh.face_normals[:, 2]
    centroids_z = mesh.triangles_center[:, 2]
    areas = mesh.area_faces
    height = float(mesh.bounds[1][2] - mesh.bounds[0][2])

    overhang_limit = -math.sin(math.radians(overhang_angle))
    support_mask = normals_z < overhang_limit
    support_penalty = float(np.sum(areas[support_mask] * np.maximum(centroids_z[support_mask] - contact_tolerance, 0.0)))

    bottom_mask = (normals_z < -0.95) & (centroids_z <= contact_tolerance)
    contact_area = float(np.sum(areas[bottom_mask]))

    return {
        "support_penalty": support_penalty,
        "contact_area": contact_area,
        "height": height,
    }


def orient_mesh_for_print(mesh, overhang_angle=45.0, contact_tolerance=0.3, n_samples=20):
    transforms, probabilities = mesh.compute_stable_poses(n_samples=n_samples, threshold=0.0)
    if len(transforms) == 0:
        oriented = mesh.copy()
        oriented.apply_translation([0, 0, -oriented.bounds[0][2]])
        return oriented, {"support_penalty": 0.0, "contact_area": 0.0, "height": float(oriented.extents[2]), "probability": 0.0}

    candidates = []
    for transform, probability in zip(transforms, probabilities):
        candidate = mesh.copy()
        candidate.apply_transform(transform)
        candidate.apply_translation([0, 0, -candidate.bounds[0][2]])

        metrics = pose_metrics(candidate, overhang_angle=overhang_angle, contact_tolerance=contact_tolerance)
        metrics["probability"] = float(probability)
        candidates.append((candidate, metrics))

    max_contact = max(item[1]["contact_area"] for item in candidates)
    min_required_contact = max(1.0, max_contact * 0.2)
    eligible = [item for item in candidates if item[1]["contact_area"] >= min_required_contact]
    if not eligible:
        eligible = candidates

    best_mesh = None
    best_metrics = None
    best_key = None
    for candidate, metrics in eligible:
        support_density = metrics["support_penalty"] / max(metrics["contact_area"], 1e-6)
        sort_key = (
            round(support_density, 6),
            round(metrics["height"], 6),
            -round(metrics["contact_area"], 6),
            round(metrics["support_penalty"], 6),
            -round(metrics["probability"], 6),
        )
        if best_key is None or sort_key < best_key:
            best_key = sort_key
            best_mesh = candidate
            best_metrics = metrics

    return best_mesh, best_metrics


def export_clean_mesh(mesh, path):
    mesh.export(path)
    reloaded = trimesh.load(path, force="mesh")
    cleanup_mesh(reloaded).export(path)


def default_output_path(input_path):
    input_path = Path(input_path)
    suffix = input_path.suffix or ".stl"
    return input_path.with_name(f"{input_path.stem}_oriented{suffix}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("input")
    parser.add_argument("--output")
    parser.add_argument("--overhang-angle", type=float, default=45.0)
    parser.add_argument("--contact-tolerance", type=float, default=0.3)
    parser.add_argument("--n-samples", type=int, default=20)
    args = parser.parse_args()

    input_path = Path(args.input)
    output_path = Path(args.output) if args.output else default_output_path(input_path)

    mesh = trimesh.load(input_path, force="mesh")
    mesh = cleanup_mesh(mesh)
    oriented, metrics = orient_mesh_for_print(
        mesh,
        overhang_angle=args.overhang_angle,
        contact_tolerance=args.contact_tolerance,
        n_samples=args.n_samples,
    )
    oriented = cleanup_mesh(oriented)
    export_clean_mesh(oriented, output_path)

    print(f"Input: {input_path}")
    print(f"Output: {output_path}")
    print(
        "Orientation:"
        f" support={metrics['support_penalty']:.3f}"
        f" contact={metrics['contact_area']:.3f}"
        f" height={metrics['height']:.3f}"
        f" prob={metrics['probability']:.4f}"
    )


if __name__ == "__main__":
    main()
