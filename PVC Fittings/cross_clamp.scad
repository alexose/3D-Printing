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
clip_len   = 20;     // length along the pipe axis
mouth_emt  = 20.0;   // top opening width, EMT clip (< OD so it retains)
mouth_pvc  = 18.0;   // top opening width, PVC clip
tie_w      = 3.0;    // zip-tie groove width
tie_deep   = 0.8;    // zip-tie groove depth
tie_y      = 3.0;    // groove offset along the pipe axis
screw_d    = 3.4;    // lock-screw clearance (#6 / M3)
screw_y    = 7.0;    // screw offset along the pipe axis
web        = 1.0;    // gap between the two pipe surfaces where they cross
top_angle  = 90;     // plan angle of the top (PVC) clip about Z (90 = square cross, 45 = diagonal)

$fn = 84;

slice_off = 5.5;                          // how much to shave flat off the top and bottom edges.
                                          // Must exceed the mouth-tip inset (~4mm) to cut at all;
                                          // stays clear of the bores/mouths up to ~8.5mm.

// ---------- Derived ----------
commonOD = emt_od + 2*clip_wall;         // both clips share this OD
R        = commonOD/2;
sep      = emt_od/2 + pvc_od/2 + web;     // bore-center separation (Z)
z_emt    = R;                             // EMT clip (bottom)
z_pvc    = R + sep;                       // PVC clip (top), rotated 90
z_bottom = slice_off;                     // flat bottom plane
z_top    = z_pvc + R - slice_off;         // flat top plane

// ------------------------------------------------------------
//  One snap clip (from conduit_clip.scad): tube axis Y, mouth up.
// ------------------------------------------------------------
module clip(pipe_od, mouth_w) {
    bore_r = pipe_od/2 + grip_clear;
    difference() {
        rotate([90, 0, 0]) cylinder(h = clip_len, d = commonOD, center = true);   // body
        rotate([90, 0, 0]) cylinder(h = clip_len + 1, r = bore_r, center = true); // bore
        translate([-mouth_w/2, -(clip_len+1)/2, 0])                                // top mouth
            cube([mouth_w, clip_len + 1, commonOD]);
        for (sy = [-1, 1])                                                         // zip grooves
            translate([0, sy*tie_y, 0]) rotate([90, 0, 0])
                difference() {
                    cylinder(h = tie_w, d = commonOD + 1, center = true);
                    cylinder(h = tie_w + 1, d = commonOD - 2*tie_deep, center = true);
                }
        for (sy = [-1, 1])                                                         // lock screws
            translate([0, sy*screw_y, 0]) cylinder(h = commonOD + 2, d = screw_d, center = true);
    }
}

// ------------------------------------------------------------
//  The two clips fused at 90 deg, with a central block bridging
//  their backs. Both pipe bores and mouths are re-cut through the
//  block so the pipes still pass and the clips still snap.
// ------------------------------------------------------------
module cross_clamp() {
    intersection() {
        difference() {
            union() {
                translate([0, 0, z_emt]) rotate([180, 0, 0]) clip(emt_od, mouth_emt);  // EMT, axis Y, mouth DOWN
                translate([0, 0, z_pvc]) rotate([0, 0, top_angle]) clip(pvc_od, mouth_pvc);  // PVC, mouth UP, swung top_angle
                translate([0, 0, (z_emt + z_pvc)/2])                                   // central fusion post
                    cylinder(h = sep + 2, d = commonOD*0.72, center = true);
            }
            // re-cut both bores so the post/backs never fill the pipe channels
            translate([0, 0, z_emt]) rotate([90, 0, 0]) cylinder(h = clip_len + 2, r = emt_od/2 + grip_clear, center = true);
            translate([0, 0, z_pvc]) rotate([0, 0, top_angle]) rotate([0, 90, 0]) cylinder(h = clip_len + 2, r = pvc_od/2 + grip_clear, center = true);
        }
        // shave flat planes off the top and bottom edges
        translate([0, 0, (z_bottom + z_top)/2]) cube([4*commonOD, 4*commonOD, z_top - z_bottom], center = true);
    }
}

cross_clamp();
