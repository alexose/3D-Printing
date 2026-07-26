// ============================================================
//  Cross-member clamp
//  Two snap clips fused at 90 degrees: grips a 3/4" EMT running one
//  way and a 1/2" PVC running the perpendicular way, where two
//  cross-members cross. Rigid (no joint). Reuses the snap-clip from
//  conduit_clip.scad (tight fit, lock screw + zip groove per clip).
// ============================================================

// ---------- Pipe sizes ----------
emt_od     = 23.4;   // 3/4" EMT outer diameter
pvc_od     = 21.34;  // 1/2" Sch-40 PVC / conduit OD

// ---------- Clip ----------
grip_clear = 0.05;   // radial gap: bore = pipe_od/2 + this (TIGHT; C-clip flexes on)
clip_wall  = 3.0;    // wall around the pipe
emt_extra  = 1.5;    // extra wall on just the bottom (EMT) clamp for durability
clip_len   = 20;     // length along the pipe axis
mouth_emt  = 20.0;   // top opening width, EMT clip (< OD so it retains)
mouth_pvc  = 18.0;   // top opening width, PVC clip
tie_w      = 3.0;    // zip-tie groove width
tie_deep   = 0.8;    // zip-tie groove depth
tie_y      = 3.0;    // groove offset along the pipe axis
screw_d    = 3.4;    // lock-screw clearance (#6 / M3)
screw_y    = 7.0;    // screw offset along the pipe axis
web        = 1.0;    // gap between the pipe surfaces where they cross (pipes can be
                     //   close: the hull is one solid, so each bore cuts clean regardless)
top_angle  = 90;     // plan angle of the top (PVC) clip about Z (90 = square cross, 45 = diagonal)
top_tilt   = 0;      // downward pitch of the top clip, degrees (0 = level)

$fn = 84;

slice_off = 8;                            // how much to shave flat off the top and bottom edges.
                                          // Must clear the down-facing EMT mouth's retention-lip
                                          // tips (they feather to fragile spikes at the bed if the
                                          // slice grazes them ~<7mm); stays clear of bores up to ~9mm.

// ---------- Derived ----------
commonOD = emt_od + 2*clip_wall;         // both clips share this OD
R        = commonOD/2;
// A tilted top clip drives its bore down toward the lower clip on the low side; below
// ~1.1*clip_len*sin(tilt) the two pipe channels merge (verified: the EMT bore shows
// through the wall in a CGAL render). This is the real floor on the part's height --
// the factor is set just above it, so the top sits as low as it can without breaching.
web_eff  = max(web, 1 + 1.1*clip_len*sin(top_tilt));
sep      = emt_od/2 + pvc_od/2 + web_eff;  // bore-center separation (Z)
z_emt    = R;                             // EMT clip (bottom)
z_pvc    = R + sep;                       // PVC clip (top), rotated 90
z_bottom = slice_off;                     // flat bottom plane
z_top    = (top_tilt == 0) ? z_pvc + R - slice_off   // flat top plane (level variant)
                           : z_pvc + R + clip_len;    // tilted variant: no top slice

// ------------------------------------------------------------
//  One snap clip, split so the assembly can hull the solid bodies
//  and subtract the cuts afterward. Tube axis Y, mouth up.
// ------------------------------------------------------------
module clip_body(od = commonOD) {
    rotate([90, 0, 0]) cylinder(h = clip_len, d = od, center = true);
}
module clip_cuts(pipe_od, mouth_w, od = commonOD) {
    bore_r = pipe_od/2 + grip_clear;
    rotate([90, 0, 0]) cylinder(h = 3*commonOD, r = bore_r, center = true);        // bore, long enough to
                                                                                   //   clear the whole hull
    translate([-mouth_w/2, -(clip_len+1)/2, 0])                                    // mouth: opens the local C
        cube([mouth_w, clip_len + 1, od]);
    for (sy = [-1, 1])                                                             // zip grooves (full ring)
        translate([0, sy*tie_y, 0]) rotate([90, 0, 0])
            difference() {
                cylinder(h = tie_w, d = od + 1, center = true);
                cylinder(h = tie_w + 1, d = od - 2*tie_deep, center = true);
            }
    // (no lock-screw holes: they punched through into the bore; snap + zip tie hold it)
}

// placement transforms (reused for the body and its cuts)
module place_emt() { translate([0, 0, z_emt]) rotate([180, 0, 0]) children(); }
module place_pvc() { translate([0, 0, z_pvc]) rotate([0, 0, top_angle]) rotate([-top_tilt, 0, 0]) children(); }

// ------------------------------------------------------------
//  Position both clips, HULL their solid bodies into one smooth
//  linking solid, then cut both bores/mouths through it. Each bore
//  is cut from a single solid -> clean full channel, no gouging.
// ------------------------------------------------------------
module cross_clamp() {
    intersection() {
        difference() {
            union() {
                place_emt() clip_body(commonOD + 2*emt_extra);   // EMT ring (its own clean body)
                place_pvc() clip_body(commonOD);                 // PVC ring (its own clean body)
                // Smooth connective neck: hull a SPHERE at each bore center. A sphere at the
                // ring radius blends tangentially into its ring (no hard edge) but, unlike the
                // full cylinder, has no length along the bore axis -- so it never drapes over
                // the mouth arm tips. That drape was the "loop"/saddle fin; the earlier
                // slab-clipped hull killed it but left the 90-degree edges the user disliked.
                hull() {
                    place_emt() sphere((commonOD + 2*emt_extra)/2);
                    place_pvc() sphere(commonOD/2);
                }
            }
            place_emt() clip_cuts(emt_od, mouth_emt, commonOD + 2*emt_extra);
            place_pvc() clip_cuts(pvc_od, mouth_pvc, commonOD);
        }
        // shave flat planes off the top and bottom edges
        translate([0, 0, (z_bottom + z_top)/2]) cube([4*commonOD, 4*commonOD, z_top - z_bottom], center = true);
    }
}

cross_clamp();
