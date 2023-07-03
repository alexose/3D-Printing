.PHONY: all cap cap_with_hole plate tube 

all: cap cap_with_hole plate tube 

cap:
	openscad cylindrical_battery_pack.scad -D render_cap=1 -D render_cap_with_hole=0 -D render_plate=0 -D render_tube=0 -o cap.stl --enable=fast-csg

cap_with_hole:
	openscad cylindrical_battery_pack.scad -D render_cap=0 -D render_cap_with_hole=1 -D render_plate=0 -D render_tube=0 -o cap_with_hole.stl --enable=fast-csg

plate:
	openscad cylindrical_battery_pack.scad -D render_cap=0 -D render_cap_with_hole=0 -D render_plate=1 -D render_tube=0 -o plate.stl --enable=fast-csg

tube:
	openscad cylindrical_battery_pack.scad -D render_cap=0 -D render_cap_with_hole=0 -D render_plate=0 -D render_tube=1 -o tube.stl --enable=fast-csg
