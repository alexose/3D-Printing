.PHONY: all cap plate tube 

all: cap plate tube 

cap:
	openscad cylindrical_battery_pack.scad -D render_cap=1 -D render_plate=0 -D render_tube=0 -o cap.stl --enable=fast-csg

plate:
	openscad cylindrical_battery_pack.scad -D render_cap=0 -D render_plate=1 -D render_tube=0 -o plate.stl --enable=fast-csg

tube:
	openscad cylindrical_battery_pack.scad -D render_cap=0 -D render_plate=0 -D render_tube=1 -o tube.stl --enable=fast-csg
