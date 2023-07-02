.PHONY: all outer_shell us100 soil_moisture_sensor dht22

all: outer_shell us100 soil_moisture dht22

outer_shell:
	openscad dorothy_sensor.scad -D render_outer_shell=1 -D render_brain=0 -o outer_shell.stl --enable=fast-csg

us100:
	openscad dorothy_sensor.scad -D render_outer_shell=0 -D render_brain=1 -D brain_type="us100" -o us100_brain.stl --enable=fast-csg

soil_moisture:
	openscad dorothy_sensor.scad -D render_outer_shell=0 -D render_brain=1 -D brain_type="soil_moisture" -o soil_moisture_brain.stl --enable=fast-csg

dht22:
	openscad dorothy_sensor.scad -D render_outer_shell=0 -D render_brain=1 -D brain_type="dht22" -o dht22_brain.stl --enable=fast-csg
