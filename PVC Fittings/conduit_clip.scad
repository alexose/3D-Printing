// ============================================================
//  Conduit cross-clamp
//  Snap clip for 3/4" EMT  <-- ball joint -->  snap clip for 1/2" PVC
//  100% print-in-place, prints FLAT on the bed, no supports.
//
//  Both clips share one outer diameter so they rest on the bed at the same
//  height. A print-in-place BALL JOINT links them, laid horizontal (stem
//  along the line between the clips) so nothing stacks: the socket's dome
//  bridges over the ball with a clearance gap, exactly like a normal
//  print-in-place ball. You clock each clip on its pipe at install, and the
//  ball's swing takes up the rest, so the pipes can cross at any angle.
//  Each clip snaps on and a zip tie in the grooves locks it to the pipe.
// ============================================================

// ---------- Pipe sizes ----------
emt_od     = 23.4;   // 3/4" EMT outer diameter (0.922")
pvc_od     = 21.34;  // 1/2" Sch-40 PVC / conduit OD (0.840")

// ---------- Clip ----------
grip_clear = 0.05;   // radial gap: bore = pipe_od/2 + this (TIGHT; C-clip flexes on)
clip_wall  = 3.0;    // wall around the pipe
clip_len   = 20;     // length along the pipe axis (Y)
mouth_emt  = 20.0;   // top opening width, EMT clip (< OD so it retains)
mouth_pvc  = 18.0;   // top opening width, PVC clip
tie_w      = 3.0;    // zip-tie groove width
tie_deep   = 0.8;    // zip-tie groove depth (shallow: just locates the tie)
tie_y      = 3.0;    // zip grooves inboard, screws outboard, so they don't clash
screw_d    = 3.4;    // clip lock screw clearance (#6 / M3 self-tapper into conduit)
screw_y    = 7.0;    // clip screw offset along the pipe axis (Y)

// ---------- Ball joint ----------
ball_r      = 7.0;   // ball radius
ball_gap    = 0.4;   // print-in-place clearance between ball and socket
socket_wall = 3.2;   // socket shell thickness
stem_r      = 4.0;   // stem / stub radius
mouth_deg   = 58;    // socket mouth cone half-angle (bigger = more swing, less capture)
socket_merge= 2;     // how far the socket sinks into the EMT clip face (flares on)
arm_len     = 3;     // short arm from the PVC clip to the ball (this is what swings)

$fn = 84;

// ---------- Derived ----------
commonOD  = emt_od + 2*clip_wall;   // both clips share this OD
R         = commonOD/2;             // clip radius = clip axis height on the bed
socket_ir = ball_r + ball_gap;      // socket inner radius (ball cavity)
socket_or = socket_ir + socket_wall;// socket outer radius
zc        = R;                      // joint on the pipe centerline -> concentric with the clips
emt_cx    = -(socket_or - socket_merge + R); // EMT clip: socket flares off its face
pvc_cx    =  (ball_r + arm_len + R);         // PVC clip: ball on a short arm

// ------------------------------------------------------------
//  One snap clip. Tube axis along Y, mouth opening UP (+Z) so it
//  prints as a "U" (no overhang) and the pipe snaps down into it.
//  Two circumferential grooves take a zip tie that cinches it shut.
// ------------------------------------------------------------
module clip(pipe_od, mouth_w) {
    bore_r = pipe_od/2 + grip_clear;
    difference() {
        rotate([90, 0, 0]) cylinder(h = clip_len, d = commonOD, center = true);   // body
        rotate([90, 0, 0]) cylinder(h = clip_len + 1, r = bore_r, center = true); // bore
        translate([-mouth_w/2, -(clip_len+1)/2, 0])                                // top mouth
            cube([mouth_w, clip_len + 1, commonOD]);
        for (sy = [-1, 1])                                                         // zip grooves (inboard)
            translate([0, sy*tie_y, 0]) rotate([90, 0, 0])
                difference() {
                    cylinder(h = tie_w, d = commonOD + 1, center = true);
                    cylinder(h = tie_w + 1, d = commonOD - 2*tie_deep, center = true);
                }
        for (sy = [-1, 1])                                                         // lock screws (outboard)
            translate([0, sy*screw_y, 0])                                          // drilled along Z, into the pipe
                cylinder(h = commonOD + 2, d = screw_d, center = true);
    }
}

// ------------------------------------------------------------
//  Socket: wraps the ball past its equator; a cone mouth on the +X
//  side (toward the PVC clip) lets the ball's arm exit and swing.
//  Mouth faces horizontal, so the socket dome bridges over the ball
//  as it prints.
// ------------------------------------------------------------
module socket() {
    difference() {
        sphere(socket_or);                                            // shell outer
        sphere(socket_ir);                                            // ball cavity (+gap)
        rotate([0, 90, 0]) cylinder(h = socket_or + 2, r1 = 0,        // +X mouth cone
                                    r2 = (socket_or + 2) * tan(mouth_deg));
    }
}

// ------------------------------------------------------------
//  EMT side: clip with the SOCKET flared straight off its face
//  (the socket's solid -X back merges into the clip -> no rod).
// ------------------------------------------------------------
module emt_side() {
    difference() {
        union() {
            translate([emt_cx, 0, R]) clip(emt_od, mouth_emt);
            hull() {                                                   // fat solid haunch: socket merges straight into the clip
                translate([emt_cx + R - 5, 0, zc]) rotate([0,90,0]) cylinder(h = 5, r = socket_or);
                translate([0, 0, zc]) sphere(socket_or);
            }
            translate([0, 0, zc]) socket();
        }
        translate([emt_cx, 0, R]) rotate([90,0,0])                     // keep the bore clear
            cylinder(h = clip_len + 2, r = emt_od/2 + grip_clear, center = true);
        translate([0, 0, zc]) sphere(socket_ir);                       // keep the ball cavity clear
        translate([0, 0, zc]) rotate([0, 90, 0]) cylinder(h = socket_or + 2, r1 = 0,   // keep the mouth open
                                     r2 = (socket_or + 2) * tan(mouth_deg));
    }
}

// ------------------------------------------------------------
//  PVC side: clip + a short arm carrying the ball. The arm exits
//  the socket mouth and is what swings, giving the joint its range.
// ------------------------------------------------------------
module pvc_side() {
    difference() {
        union() {
            translate([pvc_cx, 0, R]) clip(pvc_od, mouth_pvc);
            hull() {                                                   // short STRAIGHT arm: clip -> ball, both at joint height
                translate([pvc_cx - R + 1, 0, zc]) sphere(stem_r);
                translate([ball_r - 2, 0, zc]) sphere(stem_r);
            }
            translate([0, 0, zc]) sphere(ball_r);                      // the ball
        }
        translate([pvc_cx, 0, R]) rotate([90,0,0])                     // keep the bore clear
            cylinder(h = clip_len + 2, r = pvc_od/2 + grip_clear, center = true);
    }
}

emt_side();
pvc_side();
