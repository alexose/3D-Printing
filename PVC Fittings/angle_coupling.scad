// ============================================================
//  1/2" PVC Roof Ridge Fitting  (default 10 deg dogleg)
//  Two rafter sockets meet at a slight angle (deflect degrees),
//  while a continuous 1/2" ridge pipe passes straight THROUGH the
//  joint, perpendicular to the rafters (along X) -> a ridgeline.
//  Features:
//    - Two slip sockets sized for 1/2" Sch-40 PVC OD
//    - Perpendicular pass-through sleeve for the ridge pipe
//    - Screw holes through each socket (set / retaining screws)
//    - A gusset rib + solid joint blend for rigidity
//  Set ridge_on=false to get a plain angled coupling instead.
// ============================================================

// ---------- Pipe / fit parameters ----------
pipe_od      = 21.34;  // 1/2" Sch-40 PVC actual OD (0.840")
fit_clear    = 0.15;   // radial slip clearance per side (raise = looser).
                       // 0.15 = light friction fit; 0.35 was a free slide.
wall         = 3.2;    // socket wall thickness
socket_depth = 32;     // pipe insertion depth per side (long enough that both
                       // screw holes clear the hub/blend on multi-way nodes)
stop_len     = 4;      // internal shoulder where the pipe bottoms out

// ---------- Geometry ----------
deflect      = 10;     // rafter peak: deflection from straight, in degrees.
                       // NOTE: this is the pipe KINK, which for a symmetric gable
                       // peak is TWICE the roof pitch (a deflect=60 ridge sits at
                       // 30deg pitch). The ridge_Ndeg STLs are named by PITCH to
                       // match hip3/corner, so they are rendered with deflect=2*N
                       // (ridge_30deg -> deflect=60). Plain coupling_Ndeg STLs are
                       // named by the bend itself (coupling_30deg -> deflect=30).

// ---------- Four-way front node ----------
front_cross    = false; // true = 4-way corner (ridge bends down instead of
                        //        passing through); false = ridge tee / coupling
ridge_deflect  = 15;    // front node: ridge drop toward the front slope (deg)

// ---------- Three-way hip end ----------
hip3   = false;  // true = hip apex: ridge back + two splayed hip rafters
hip_x  = 90;     // fore-aft angle of the hips in the X-Z plane
                 //   (90 = straight forward/horizontal; >90 pitches down)
hip_y  = 45;     // splay of the hips in the horizontal X-Y plane (± each side;
                 //   45 -> 90 deg total between the two hips)

// ---------- Three-way base corner (mates with hip3) ----------
corner3      = false;  // true = eave corner: two base pipes at corner_span apart,
                       //        plus a hip rafter rising at corner_pitch
corner_pitch = 30;     // hip rise above horizontal (match the hip3 pitch)
corner_span  = 270;    // plan angle swept from one eave to the other through the
                       //   enclosed (interior) side. 270 = square building corner:
                       //   the two eaves sit 90 deg apart (the reflex/roof side is
                       //   270), and the hip rises out of that inner corner.

// ---------- Pass-through tee ----------
tee         = false;  // true = a straight pass-through sleeve (a pipe slides all
                      //        the way through along X) plus ONE branch socket with
                      //        screw holes, to hang a pipe off the run. Uses the
                      //        ridge sleeve for the pass-through.
tee_angle   = 90;     // branch angle measured from the run pipe: 90 = perpendicular
                      //        tee, 45 = diagonal brace (two per support strut). The
                      //        branch bottoms against the through pipe either way.
                      // For 3/4" EMT struts render with -D pipe_od=23.4.

// ---------- Five-way master node ----------
node5       = false;  // true = 5-way: rafter peak + ridge terminal + 2 supports
node5_sup_x = 90;     // the two extra supports: fore-aft angle in X-Z (90 = level)
node5_sup_y = 15;     // the two extra supports: splay each side in the Y plane

// ---------- Ridge pass-through (tee only) ----------
ridge_on     = true;   // add the perpendicular ridgeline sleeve
ridge_clear  = 0.6;    // radial clearance so a long pipe slides through
ridge_stick  = 6;      // how far the sleeve protrudes each side (bearing)

// ---------- Screw holes ----------
screw_d      = 3.4;    // clearance for #6 / M3
screws_per   = 2;      // screws per socket
screw_first  = 5;      // from the socket mouth to the first screw
screw_gap    = 12;     // spacing between screws down the socket

// ---------- Gusset (rigidity rib) ----------
gusset_th    = 4;      // rib thickness (across the bend plane)
gusset_depth = 6;      // how far the rib stands off the pipe wall
gusset_on    = false;  // redundant now that joint_blend fills the joint; at high
                       // deflect it protruded as a "shark fin". Set true to add.

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
    for (i = [0 : screws_per - 1]) {
        z = arm_len - screw_first - i*screw_gap;   // near mouth, marching down
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

// ------------------------------------------------------------
//  Ridge pass-through: a sleeve along X through the joint so a
//  continuous 1/2" pipe (the ridgeline) slides straight through.
//  The rafter pipes bottom out against this pipe.
// ------------------------------------------------------------
ridge_sleeve_od = pipe_od + 2*wall;

module ridge_sleeve_solid() {
    rotate([0, 90, 0])
        cylinder(h = socket_od + 2*ridge_stick, d = ridge_sleeve_od, center = true);
}

module ridge_bore() {
    rotate([0, 90, 0])
        cylinder(h = socket_od + 2*ridge_stick + 2, d = pipe_od + 2*ridge_clear,
                 center = true);
}

module coupling() {
    difference() {
        union() {
            joint_blend();
            armA_at() arm();
            armB_at() arm();
            if (gusset_on)  gusset_solid();
            if (ridge_on)   ridge_sleeve_solid();
        }
        // re-cut bores and screw holes so the blend/gusset never fills them
        armA_at() arm_bore();
        armB_at() arm_bore();
        armA_at() screw_holes();
        armB_at() screw_holes();
        if (ridge_on) ridge_bore();
    }
}

// ------------------------------------------------------------
//  Four-way front node: 2 rafter sockets (peak) + 2 ridge sockets
//  (back horizontal, front dropped by ridge_deflect). The four
//  arms share a hull "hub" that fills every valley for rigidity.
// ------------------------------------------------------------
module armC_at() { rotate([0, -90, 0]) children(); }                  // ridge back (-X)
module armD_at() { rotate([0, 0, -ridge_deflect]) rotate([0, 90, 0])  // ridge front
                   children(); }                                      // (+X, swung in Y)

module hub_blend() {
    hub_len = socket_od * 0.7;
    hull() {
        armA_at() cylinder(h = hub_len, d = socket_od);
        armB_at() cylinder(h = hub_len, d = socket_od);
        armC_at() cylinder(h = hub_len, d = socket_od);
        armD_at() cylinder(h = hub_len, d = socket_od);
    }
}

module cross4() {
    difference() {
        union() {
            hub_blend();
            armA_at() arm();  armB_at() arm();
            armC_at() arm();  armD_at() arm();
        }
        armA_at() arm_bore();    armB_at() arm_bore();
        armC_at() arm_bore();    armD_at() arm_bore();
        armA_at() screw_holes(); armB_at() screw_holes();
        armC_at() screw_holes(); armD_at() screw_holes();
    }
}

// ------------------------------------------------------------
//  Three-way hip end: a ridge socket going straight back, plus two
//  hip rafters that splay symmetrically (± rafter_spread in Y) and
//  pitch down toward the front (rafter_pitch). They form the low
//  triangular front face of a hip roof.
// ------------------------------------------------------------
module hipRidge_at() { rotate([0, -90, 0]) children(); }   // ridge, back (-X)
module hipA_at() { rotate([0, 0,  hip_y]) rotate([0, hip_x, 0]) children(); } // +Y hip
module hipB_at() { rotate([0, 0, -hip_y]) rotate([0, hip_x, 0]) children(); } // -Y hip

module hip_hub() {
    hub_len = socket_od * 0.7;
    hull() {
        hipRidge_at() cylinder(h = hub_len, d = socket_od);
        hipA_at()     cylinder(h = hub_len, d = socket_od);
        hipB_at()     cylinder(h = hub_len, d = socket_od);
    }
}

module hip3_node() {
    difference() {
        union() {
            hip_hub();
            hipRidge_at() arm();  hipA_at() arm();  hipB_at() arm();
        }
        hipRidge_at() arm_bore();    hipA_at() arm_bore();    hipB_at() arm_bore();
        hipRidge_at() screw_holes(); hipA_at() screw_holes(); hipB_at() screw_holes();
    }
}

// ------------------------------------------------------------
//  Three-way base corner: the ground-level partner to hip3_node.
//  Two horizontal eave sockets sit symmetrically about +X. corner_span
//  is the plan sweep through the enclosed side, so 270 = a square
//  building corner (the eaves themselves end up 90 deg apart, wrapping
//  the interior). The hip socket points back along the interior
//  bisector (-X) and rises corner_pitch above horizontal, so the hip
//  rafter climbs out of the inner corner to the apex. Use corner_pitch
//  = the hip3 pitch.
// ------------------------------------------------------------
module cornerA_at()   { rotate([0, 0,  corner_span/2]) rotate([0, 90, 0])
                        children(); }                        // eave, one wall
module cornerB_at()   { rotate([0, 0, -corner_span/2]) rotate([0, 90, 0])
                        children(); }                        // eave, other wall
module cornerHip_at() { rotate([0, -(90 - corner_pitch), 0]) children(); }
                                                             // hip, up and inboard

module corner_hub() {
    hub_len = socket_od * 0.7;
    hull() {
        cornerA_at()   cylinder(h = hub_len, d = socket_od);
        cornerB_at()   cylinder(h = hub_len, d = socket_od);
        cornerHip_at() cylinder(h = hub_len, d = socket_od);
    }
}

// Legacy tongue-clearing ream. With the old 90 corner the hip pointed away
// from the eaves and an eave bore glanced the hip stop, leaving a spike in the
// hip bore that this ream shaved off. With the 270 corner the three bores
// cluster and already clear each other -- the hip bore is clean with no ream --
// so this now only adds risk: past ~3mm the reaming cylinder punches out an
// eave wall (that was the small hole in the back). Kept short as insurance;
// verified breach-free at 2mm on all three pitches (15/22.5/30). Do not raise
// without re-checking every pitch for an eave-wall breach.
corner_ream = 2;   // how far past center to ream the hip bore (mm)

module corner3_node() {
    difference() {
        union() {
            corner_hub();
            cornerA_at() arm();  cornerB_at() arm();  cornerHip_at() arm();
        }
        cornerA_at() arm_bore();    cornerB_at() arm_bore();
        cornerHip_at() arm_bore();
        // extend the hip bore inward through the core to clear the tongue
        cornerHip_at() translate([0, 0, -corner_ream])
            cylinder(h = corner_ream + stop_len + 0.1, d = socket_id);
        cornerA_at() screw_holes(); cornerB_at() screw_holes();
        cornerHip_at() screw_holes();
    }
}

// ------------------------------------------------------------
//  Five-way master node: the rafter peak (armA/armB at `deflect`),
//  the ridge terminal going straight back (-X), and two extra
//  supports going forward (+X) splayed +/- node5_sup_y in Y at a
//  node5_sup_x fore-aft angle. All five share one hull hub.
// ------------------------------------------------------------
module supA_at() { rotate([0, 0,  node5_sup_y]) rotate([0, node5_sup_x, 0])
                   children(); }                                     // +Y support
module supB_at() { rotate([0, 0, -node5_sup_y]) rotate([0, node5_sup_x, 0])
                   children(); }                                     // -Y support

module node5_hub() {
    hub_len = socket_od * 0.7;
    hull() {
        armA_at() cylinder(h = hub_len, d = socket_od);
        armB_at() cylinder(h = hub_len, d = socket_od);
        armC_at() cylinder(h = hub_len, d = socket_od);   // ridge terminal (-X)
        supA_at() cylinder(h = hub_len, d = socket_od);
        supB_at() cylinder(h = hub_len, d = socket_od);
    }
}

module node5_node() {
    difference() {
        union() {
            node5_hub();
            armA_at() arm();  armB_at() arm();  armC_at() arm();
            supA_at() arm();  supB_at() arm();
        }
        armA_at() arm_bore();    armB_at() arm_bore();    armC_at() arm_bore();
        supA_at() arm_bore();    supB_at() arm_bore();
        armA_at() screw_holes(); armB_at() screw_holes(); armC_at() screw_holes();
        supA_at() screw_holes(); supB_at() screw_holes();
    }
}

// ------------------------------------------------------------
//  Pass-through tee: the ridge sleeve carries a continuous pipe
//  straight through along X, and a single branch socket comes off
//  at tee_angle from the run (90 = perpendicular, 45 = diagonal
//  brace). A short hull between the branch base and the middle of
//  the sleeve fillets the joint. The branch pipe bottoms out
//  against the through pipe, like a rafter on the ridge.
// ------------------------------------------------------------
//  arm() points +Z; swing it toward +X so it makes tee_angle with
//  the +X run pipe (90 -> straight up, 45 -> leaning along the run).
module tee_branch_at() { rotate([0, 90 - tee_angle, 0]) children(); }

module tee_blend() {
    hull() {
        tee_branch_at() cylinder(h = 0.1, d = socket_od);   // branch base ring
        rotate([0, 90, 0])                                  // central slug of sleeve
            cylinder(h = socket_od, d = ridge_sleeve_od, center = true);
    }
}

// Screws through the sleeve to lock the slide-in pipe: one in each
// protruding end (either side of the branch), drilled along Y so
// they clear the branch above.
module sleeve_screw_holes() {
    for (sx = [-1, 1])
        translate([sx*(socket_od/2 + ridge_stick/2), 0, 0])
            rotate([90, 0, 0]) cylinder(h = ridge_sleeve_od + 2, d = screw_d, center = true);
}

module tee_node() {
    difference() {
        union() {
            ridge_sleeve_solid();          // the pass-through, along X
            tee_blend();
            tee_branch_at() arm();         // branch socket
        }
        // Clear the ENTIRE tube path, not just the sleeve: an angled branch
        // leans along the run and its wall would otherwise sweep into the bore
        // and block the slide-through pipe. This trims the branch to a clean
        // saddle that fairs into the tube surface.
        rotate([0, 90, 0]) cylinder(h = 2*(socket_od + arm_len), d = pipe_od + 2*ridge_clear, center = true);
        tee_branch_at() arm_bore();        // branch socket + throat
        tee_branch_at() screw_holes();     // branch screws
        sleeve_screw_holes();              // slide-in pipe screws
    }
}

if (tee)              tee_node();
else if (node5)       node5_node();
else if (corner3)     corner3_node();
else if (hip3)        hip3_node();
else if (front_cross) cross4();
else                  coupling();
