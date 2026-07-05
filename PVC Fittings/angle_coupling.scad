// ============================================================
//  1/2" PVC Angled Coupling  (default 10 deg dogleg)
//  An inline slip coupling: a pipe enters each end and the two
//  pipes leave nearly straight, deflected by `deflect` degrees.
//  Features:
//    - Two slip sockets sized for 1/2" Sch-40 PVC OD
//    - Screw holes through each socket (set / retaining screws)
//    - An external gusset rib across the bend for rigidity
// ============================================================

// ---------- Pipe / fit parameters ----------
pipe_od      = 21.34;  // 1/2" Sch-40 PVC actual OD (0.840")
fit_clear    = 0.35;   // radial slip clearance per side (raise = looser)
wall         = 3.2;    // socket wall thickness
socket_depth = 22;     // pipe insertion depth per side
stop_len     = 4;      // internal shoulder where the pipe bottoms out

// ---------- Geometry ----------
deflect      = 10;     // deflection from straight, in degrees

// ---------- Screw holes ----------
screw_d      = 3.4;    // clearance for #6 / M3
screws_per   = 2;      // screws per socket
screw_inset  = 8;      // from the socket mouth to the first screw

// ---------- Gusset (rigidity rib) ----------
gusset_th    = 4;      // rib thickness (across the bend plane)
gusset_depth = 6;      // how far the rib stands off the pipe wall
gusset_on    = true;

// ---------- Render quality ----------
$fn = 96;

// ---------- Derived ----------
socket_id  = pipe_od + 2*fit_clear;
socket_od  = socket_id + 2*wall;
bore_id    = pipe_od - 2;               // through fluid/air path
arm_len    = socket_depth + stop_len;   // one arm, joint -> mouth
r          = socket_od / 2;

// ------------------------------------------------------------
//  One socket arm, mouth at +Z, joint end at origin.
// ------------------------------------------------------------
module arm_solid() { cylinder(h = arm_len, d = socket_od); }

module arm_bore() {
    translate([0, 0, stop_len])                     // pipe socket
        cylinder(h = arm_len - stop_len + 0.1, d = socket_id);
    translate([0, 0, -0.1])                          // through-bore
        cylinder(h = arm_len + 0.2, d = bore_id);
}

module screw_holes() {
    span = socket_depth - screw_inset - 4;
    for (i = [0 : screws_per - 1]) {
        z = arm_len - screw_inset - (screws_per > 1 ? i*span/(screws_per-1) : 0);
        // drilled along X (perpendicular to the gusset plane) so the
        // screws land on clear faces, not through the rib
        translate([0, 0, z]) rotate([0, 90, 0])
            cylinder(h = socket_od + 1, d = screw_d, center = true);
    }
}

module arm() {
    difference() { arm_solid(); arm_bore(); }
}

// Placements: arm A points down (-Z); arm B up (+Z), deflected.
module armA_at() { rotate([180, 0, 0])    children(); }
module armB_at() { rotate([deflect, 0, 0]) children(); }

// ------------------------------------------------------------
//  Gusset: a flat web in the bend plane (Y-Z) joining the two
//  sockets.  Built as hull(both arm envelopes) clipped to a thin
//  central slab, so it fuses to both and needs no hand trig.
//  gusset_depth extends the plate past the sockets for a fillet.
// ------------------------------------------------------------
module gusset_solid() {
    intersection() {
        hull() {
            armA_at() cylinder(h = arm_len, d = socket_od + 2*gusset_depth);
            armB_at() cylinder(h = arm_len, d = socket_od + 2*gusset_depth);
        }
        // thin central slab, kept only on the side where the two
        // sockets converge -> a single gusset, not both sides
        translate([-gusset_th/2, -100, -100]) cube([gusset_th, 100, 200]);
    }
}

// Solid convex blend between the two socket bodies, so the joint is
// filled smoothly instead of meeting at a weak notch. Bores re-cut after.
module joint_blend() {
    hull() {
        armA_at() cylinder(h = arm_len, d = socket_od);
        armB_at() cylinder(h = arm_len, d = socket_od);
    }
}

module coupling() {
    difference() {
        union() {
            joint_blend();
            armA_at() arm();
            armB_at() arm();
            if (gusset_on) gusset_solid();
        }
        // re-cut bores and screw holes so the blend/gusset never fills them
        armA_at() arm_bore();
        armB_at() arm_bore();
        armA_at() screw_holes();
        armB_at() screw_holes();
    }
}

coupling();
