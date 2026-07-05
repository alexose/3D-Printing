length = 60;
width = 15;
height = 7;

screw_spacing = 35;

cone_top_dia = 6;
cone_tip_dia = 1;
cone_depth = 7;

$fn = 64;

module cone_recess() {
    translate([0, 0, height - cone_depth + 0.01])
        cylinder(h = cone_depth, d1 = cone_tip_dia, d2 = cone_top_dia);
}

difference() {
    cube([length, width, height]);

    translate([(length - screw_spacing) / 2, width / 2, 0]) cone_recess();
    translate([(length + screw_spacing) / 2, width / 2, 0]) cone_recess();
}
